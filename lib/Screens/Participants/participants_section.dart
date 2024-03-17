import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/UserAccount/login.dart';
import 'package:uperitivo/Utils/helpers.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;

  List<UserModel> _participantsList = [];
  bool isGettingUsers = false;
  EventModel? selectedEvent;
  List<EventModel>? events;
  bool isCheckingUserStatus = false;
  bool joinRequest = false;
  UserModel? user;
  String query = "";
  List<EventModel> filteredList = [];

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    user = getCurrentUser(context);
    List<EventModel>? eventList = getAllEventsList(context);
    setState(() {
      events = eventList;
      selectedEvent = events?.isNotEmpty == true ? events![0] : null;
      checkIfUserInEvent();
      getUsersByIds(selectedEvent?.participants ?? []);
    });
  }

  Future<void> checkIfUserInEvent() async {
    setState(() {
      isCheckingUserStatus = true;
    });
    bool isUserInEvent =
        await RegisterController().isUserInEventParticipants(selectedEvent!);
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
    setState(() {
      joinRequest = true;
    });
    List<String> res =
        await RegisterController().joinEvent(selectedEvent!.eventId, context);
    if (mounted && res.length - 1 == selectedEvent!.participants.length) {
      setState(() {
        _isUserInEvent = true;
        selectedEvent!.participants = res;
        joinRequest = false;
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
            showSearch: true,
            onSearchChanged: (value) {
              query = value;
              filteredList = events!
                  .where((event) =>
                      event.city.toLowerCase().contains(query.toLowerCase()))
                  .toList();

              if (filteredList.isNotEmpty) {
                selectedEvent = filteredList[0];
              }
              setState(() {});
            },
          ),
          if (query.isNotEmpty && filteredList.isEmpty)
            const Expanded(
                child: Center(
              child: Text("Nessun evento trovato per questa città"),
            ))
          else if (query.isEmpty)
            const Expanded(
                child: Center(
              child: Text(
                  "Inserisci la tua città per cercare i partecipanti all'evento"),
            ))
          else
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
                            Text(
                                "Risultato abbinato alla città : ${selectedEvent!.city}"),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedEvent!.companyName,
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
                            if (_participantsList.isEmpty && !isGettingUsers)
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Center(
                                    child:
                                        Text("No Participants for this event"),
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
                                        _participantsList[index].nickname,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                );
                              },
                            ),
                            if (user == null)
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    getScreen(
                                        context,
                                        () => LoginScreen(
                                              isFromInside: true,
                                              onPop: () {
                                                user = getCurrentUser(context);
                                                setState(() {});
                                              },
                                            ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5887DC),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    child: Text(
                                      'Accedi per partecipare',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              )
                            else if (user!.userType != "company" &&
                                isEventOpen(
                                    selectedEvent!.eventType,
                                    selectedEvent!.eventTime,
                                    selectedEvent!.untilDate,
                                    selectedEvent!.eventDate))
                              Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ElevatedButton(
                                  onPressed:
                                      _isUserInEvent || isCheckingUserStatus
                                          ? () {}
                                          : joinEvent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isUserInEvent
                                        ? Colors.white
                                        : Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side:
                                          const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: joinRequest || isCheckingUserStatus
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            _isUserInEvent
                                                ? 'C6 !'
                                                : 'Partecipa',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: _isUserInEvent
                                                  ? Colors.green
                                                  : Colors.white,
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
