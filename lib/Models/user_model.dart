import 'package:uperitivo/Models/event_model.dart';

class UserModel {
  final String uid;
  final String nickname;
  final String name;
  final String cmpName;
  final String typeOfActivity;
  final String surname;
  final String via;
  final String civico;
  final String city;
  final String province;
  final String cap;
  final String mobile;
  final String email;
  final String site;
  final String cf;
  final String image;
  String userType;
  final String address;
  final double longitude;
  final double latitude;
  List<EventModel>? events;

  UserModel({
    required this.uid,
    required this.nickname,
    required this.name,
    required this.cmpName,
    required this.typeOfActivity,
    required this.surname,
    required this.via,
    required this.civico,
    required this.city,
    required this.province,
    required this.cap,
    required this.mobile,
    required this.email,
    required this.site,
    required this.cf,
    required this.image,
    required this.userType,
    required this.address,
    required this.longitude,
    required this.latitude,
    this.events,
  });
}
