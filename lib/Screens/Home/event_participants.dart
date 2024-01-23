import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventParticipantsScreen extends StatefulWidget {
  final EventModel event;

  EventParticipantsScreen({required this.event});

  @override
  _EventParticipantsScreenState createState() =>
      _EventParticipantsScreenState();
}

class _EventParticipantsScreenState extends State<EventParticipantsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;
  List<UserModel> _participantsList = [];
  bool isGettingUsers = false;
  bool isCheckingUserStatus = false;
  UserModel? user;

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    checkIfUserInEvent();
    getUsersByIds(widget.event.participants);
  }

  Future<void> checkIfUserInEvent() async {
    setState(() {
      isCheckingUserStatus = true;
    });
    user = getCurrentUser(context);
    bool isUserInEvent =
        await RegisterController().isUserInEventParticipants(widget.event);
    print(isUserInEvent);
    if (mounted) {
      setState(() {
        _isUserInEvent = isUserInEvent;
        isCheckingUserStatus = false;
      });
    }
  }

  Future<void> getUsersByIds(List<String> userIds) async {
    setState(() {
      isGettingUsers = true;
    });
    List<UserModel> participantsList =
        await RegisterController().getUsersByIds(userIds);
    if (mounted) {
      setState(() {
        _participantsList = participantsList;
        isGettingUsers = false;
      });
    }
  }

  Future<void> joinEvent() async {
    List<String> res =
        await RegisterController().joinEvent(widget.event.eventId, context);
    if (mounted && res.length - 1 == widget.event.participants.length) {
      setState(() {
        _isUserInEvent = true;
        widget.event.participants = res;
      });
      getUsersByIds(widget.event.participants);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.event.companyName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff354052)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 5),
                            Text(
                              "${widget.event.participants.length}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.event.category,
                      style: const TextStyle(
                          color: Color(0xff354052), fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.eventName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xff354052)),
                    ),
                    const SizedBox(height: 16),
                    if (_participantsList.isEmpty && !isGettingUsers)
                      const Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Center(
                            child: Text("No Participants for this event"),
                          ),
                        ],
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _participantsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _participantsList[index].image),
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
                    if (user!.userType != "company")
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: _isUserInEvent ||
                                  isCheckingUserStatus ||
                                  !isEventOpen(
                                      widget.event.eventType,
                                      widget.event.eventTime,
                                      widget.event.untilDate,
                                      widget.event.eventDate)
                              ? null
                              : joinEvent,
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
