import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Utils/helpers.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
      UserModel user, String password, BuildContext context) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Save user details to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nickname': user.nickname,
        'name': user.name,
        'cmpName': user.cmpName,
        'typeOfActivity': user.typeOfActivity,
        'surname': user.surname,
        'via': user.via,
        'civico': user.civico,
        'city': user.city,
        'province': user.province,
        'mobile': user.mobile,
        'email': user.email,
        'site': user.site,
        'cf': user.cf,
        'image': user.image,
        'userType': user.userType,
      });

      if (context.mounted) {
        showSuccessSnackBar(context, "Account created");
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, 'Error during registration: $e');
      }
      rethrow;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user details from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel(
        uid: userDoc.id,
        nickname: userDoc['nickname'],
        name: userDoc['name'],
        cmpName: userDoc['cmpName'],
        typeOfActivity: userDoc['typeOfActivity'],
        surname: userDoc['surname'],
        via: userDoc['via'],
        civico: userDoc['civico'],
        city: userDoc['city'],
        province: userDoc['province'],
        mobile: userDoc['mobile'],
        email: userDoc['email'],
        site: userDoc['site'],
        cf: userDoc['cf'],
        image: userDoc['image'],
        userType: userDoc['userType'],
      );
    } catch (e) {
      print('Error during sign-in: $e');
      return null;
    }
  }

  Future<UserModel?> getSignedInUser() async {
    try {
      // Check if a user is signed in
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Retrieve user details from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        return UserModel(
          uid: userDoc.id,
          nickname: userDoc['nickname'],
          name: userDoc['name'],
          cmpName: userDoc['cmpName'],
          typeOfActivity: userDoc['typeOfActivity'],
          surname: userDoc['surname'],
          via: userDoc['via'],
          civico: userDoc['civico'],
          city: userDoc['city'],
          province: userDoc['province'],
          mobile: userDoc['mobile'],
          email: userDoc['email'],
          site: userDoc['site'],
          cf: userDoc['cf'],
          image: userDoc['image'],
          userType: userDoc['userType'],
        );
      }
    } catch (e) {
      print('Error during user retrieval: $e');
    }

    return null;
  }
}
