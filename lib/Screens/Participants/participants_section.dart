import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;
  List<UserModel> _participantsList = [];
  EventModel? selectedEvent;
  List<EventModel>? events;

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    UserModel? user = getCurrentUser(context);
    List<EventModel>? eventList = getAllEventsList(context);
    setState(() {
      events = eventList;
      selectedEvent = events?.isNotEmpty == true ? events![0] : null;
      checkIfUserInEvent();
      getUsersByIds(selectedEvent?.participants ?? []);
    });
  }

  Future<void> checkIfUserInEvent() async {
    bool isUserInEvent =
        await RegisterController().isUserInEventParticipants(selectedEvent!);
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

  Future<void> joinEvent() async {
    List<String> res =
        await RegisterController().joinEvent(selectedEvent!.eventId, context);
    if (mounted && res.length - 1 == selectedEvent!.participants.length) {
      setState(() {
        _isUserInEvent = true;
        selectedEvent!.participants = res;
      });
      getUsersByIds(selectedEvent!.participants);
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (events != null && events!.isNotEmpty)
                      Column(
                        children: [
                          DropdownButton<EventModel>(
                            value: selectedEvent,
                            onChanged: (EventModel? newValue) {
                              setState(() {
                                selectedEvent = newValue;
                                checkIfUserInEvent();
                                getUsersByIds(
                                    selectedEvent?.participants ?? []);
                              });
                            },
                            items: events!.map<DropdownMenuItem<EventModel>>(
                              (EventModel event) {
                                return DropdownMenuItem<EventModel>(
                                  value: event,
                                  child: Text(event.eventName),
                                );
                              },
                            ).toList(),
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
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _participantsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?size=626&ext=jpg&ga=GA1.1.329329622.1688323921&semt=ais"),
                                    ),
                                    title: Text(
                                      "${_participantsList[index].nickname} ${_participantsList[index].name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: _isUserInEvent ? null : joinEvent,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _isUserInEvent ? 'C6 !' : 'Partecipa',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const Text('No events available'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}
