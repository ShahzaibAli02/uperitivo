import 'package:flutter/material.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  Map<String, List<EventModel>> _companyEventsMap = {};

  UserModel? get currentUser => _currentUser;

  Map<String, List<EventModel>> get companyEventsMap => _companyEventsMap;

  set companyEventsMap(Map<String, List<EventModel>> eventsMap) {
    _companyEventsMap = eventsMap;
    notifyListeners();
  }

  Future<void> updateCurrentUser(UserModel newUser) async {
    _currentUser = newUser;
    notifyListeners();
  }

  List<EventModel> getAllCompanyEvents() {
    List<EventModel> allCompanyEvents = [];

    _companyEventsMap.forEach((companyId, eventsList) {
      allCompanyEvents.addAll(eventsList);
    });

    return allCompanyEvents;
  }

  List<EventModel> getcurrentUserEvents() {
    List<EventModel> allCompanyEvents = [];

    _companyEventsMap.forEach((companyId, eventsList) {
      if (_currentUser!.uid == companyId &&
          _currentUser!.userType == "company") {
        allCompanyEvents.addAll(eventsList);
      }
      if (_currentUser!.userType == "person") {
        eventsList.forEach((event) {
          if (event.participants.contains(_currentUser!.uid)) {
            allCompanyEvents.add(event);
          }
        });
      }
    });

    return allCompanyEvents;
  }
}
