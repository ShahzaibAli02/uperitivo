import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;
  List<UserModel> _participantsList = [];
  EventModel? selectedEvent;
  List<EventModel>? events;
  GoogleMapController? _mapController;
  UserModel? user;

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    user = getCurrentUser(context);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<EventModel>? eventList = getAllEventsList(context);

    if (mounted) {
      setState(() {
        events = eventList;
        selectedEvent = events?.isNotEmpty == true ? events![0] : null;
        if (selectedEvent != null) {
          _updateSelectedEvent(selectedEvent!);
        }
      });
    }
  }

  Future<void> _updateSelectedEvent(EventModel event) async {
    await checkIfUserInEvent(event);
    await getUsersByIds(event.participants);
  }

  Future<void> checkIfUserInEvent(EventModel event) async {
    bool isUserInEvent =
        await RegisterController().isUserInEventParticipants(event);

    if (mounted) {
      setState(() {
        _isUserInEvent = isUserInEvent;
      });
    }
  }

  Future<void> getUsersByIds(List<String> userIds) async {
    List<UserModel> participantsList =
        await RegisterController().getUsersByIds(userIds);

    if (mounted) {
      setState(() {
        _participantsList = participantsList;
      });
    }
  }

  Future<void> joinEvent(EventModel event) async {
    List<String> res =
        await RegisterController().joinEvent(event.eventId, context);

    if (mounted && res.length - 1 == event.participants.length) {
      setState(() {
        _isUserInEvent = true;
        event.participants = res;
      });

      await getUsersByIds(event.participants);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
          ),
          if (selectedEvent != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<EventModel>(
                    value: selectedEvent,
                    onChanged: (EventModel? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedEvent = newValue;
                          _updateSelectedEvent(newValue);
                        });
                      }
                    },
                    items: events?.map<DropdownMenuItem<EventModel>>(
                          (EventModel event) {
                            return DropdownMenuItem<EventModel>(
                              value: event,
                              child: Text(event.eventName),
                            );
                          },
                        ).toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOCAI & BUBU",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff354052)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 5),
                          Text(
                            "${selectedEvent!.participants.length}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        selectedEvent!.category,
                        style: const TextStyle(
                            color: Color(0xff354052), fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        selectedEvent!.eventName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xff354052)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          // // else if (events != null && events!.isEmpty)
          // //   const Center(
          // //     child: Text('No event found'),
          // //   )
          // else
          //   const Center(child: CircularProgressIndicator()),
          Expanded(
            child: selectedEvent?.address.isNotEmpty == true
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        user!.latitude,
                        user!.longitude,
                      ),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    onTap: (LatLng location) {
                      // Handle map tap
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  )
                : Center(
                    child: (events != null && events!.isEmpty)
                        ? const Text('No event found')
                        : const CircularProgressIndicator()),
          ),
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}
