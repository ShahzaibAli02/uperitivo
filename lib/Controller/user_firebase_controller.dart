import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Utils/helpers.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
      UserModel user, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

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
        'address': user.address,
        'longitude': user.longitude,
        'latitude': user.latitude,
        'events': []
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

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      List<dynamic>? eventsData = userDoc['events'];
      List<EventModel> eventsList = [];

      if (eventsData != null) {
        eventsList = eventsData
            .map((dynamic item) =>
                EventModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

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
        address: userDoc['address'] ?? "",
        longitude: userDoc['longitude'] + 0.0 ?? 0.0,
        latitude: userDoc['latitude'] + 0.0 ?? 0.0,
        events: eventsList,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-in: $e');
      }
      return null;
    }
  }

  Future<UserModel?> getSignedInUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        List<dynamic>? eventsData = userDoc['events'];
        List<EventModel> eventsList = [];

        if (eventsData != null) {
          eventsList = eventsData
              .map((dynamic item) =>
                  EventModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

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
          address: userDoc['address'] ?? "",
          longitude: userDoc['longitude'] + 0.0 ?? 0.0,
          latitude: userDoc['latitude'] + 0.0 ?? 0.0,
          events: eventsList,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during user retrieval: $e');
      }
    }

    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (context.mounted) {
        showSuccessSnackBar(context, "Signed out successfully");
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, 'Error during sign out: $e');
      }
      rethrow;
    }
  }

  Future<void> addEventToUserEvents(
      EventModel event, BuildContext context) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        await _firestore.collection('users').doc(userId).update({
          'events': FieldValue.arrayUnion([event.toJson()]),
        });
        UserModel? user = await getSignedInUser();
        if (user != null && user.events!.isNotEmpty) {
          if (context.mounted) {
            updateCurrentUser(user, context);
          }
        }
        if (context.mounted) {
          showSuccessSnackBar(context, "Event added to user's events");
        }
      } else {
        if (context.mounted) {
          showErrorSnackBar(context,
              'Error adding event to user\'s events: User not signed in');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, 'Error adding event to user\'s events: $e');
      }
      rethrow;
    }
  }

  Future<void> getAllEventsForCompanies(BuildContext context) async {
    try {
      QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'company')
          .get();
      Map<String, List<EventModel>> companyEventsMap = {};

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        List<dynamic>? eventsData = userDoc['events'];
        List<EventModel> eventsList = [];

        if (eventsData != null) {
          eventsList = eventsData
              .map((dynamic item) =>
                  EventModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        companyEventsMap[userDoc.id] = eventsList;
        updateAllEventsForCompanies(companyEventsMap, context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting events for companies: $e');
      }
      rethrow;
    }
  }

  Future<List<String>> joinEvent(String eventId, BuildContext context) async {
    User? currentUser = _auth.currentUser;
    List<String> participants = [];

    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        List<dynamic>? userEvents = userDoc['events'];

        if (userEvents != null) {
          for (int i = 0; i < userEvents.length; i++) {
            if (userEvents[i]['eventId'] == eventId) {
              participants = List<String>.from(userEvents[i]['participants']);

              participants.add(currentUser!.uid);

              userEvents[i]['participants'] = participants;

              await _firestore.collection('users').doc(userDoc.id).update({
                'events': userEvents,
              });

              break;
            }
          }
        }
      }

      await getAllEventsForCompanies(context);
      showSuccessSnackBar(context,
          'Added user to event participants for all users successfully');
      return participants;
    } catch (e) {
      showErrorSnackBar(context, 'Error adding user to event participants: $e');
      return participants;
    }
  }

  Future<bool> isUserInEventParticipants(EventModel event) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      return event.participants.contains(userId);
    }

    return false;
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      List<UserModel> users = [];

      for (String userId in userIds) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          UserModel user = UserModel(
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
            address: userDoc['address'] ?? "",
            longitude: userDoc['longitude'] + 0.0 ?? 0.0,
            latitude: userDoc['latitude'] + 0.0 ?? 0.0,
            events: [],
          );

          users.add(user);
        }
      }

      return users;
    } catch (e) {
      print('Error getting users by IDs: $e');
      return [];
    }
  }
}
