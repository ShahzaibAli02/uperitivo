import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/Home/event_participants.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;
  bool isCheckingUserStatus = false;
  bool joinRequest = false;
  UserModel? user;

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    checkIfUserInEvent();
  }

  Future<void> checkIfUserInEvent() async {
    setState(() {
      isCheckingUserStatus = true;
    });
    user = getCurrentUser(context);
    bool isUserInEvent =
        await RegisterController().isUserInEventParticipants(widget.event);
    if (kDebugMode) {
      print(isUserInEvent);
    }
    if (mounted) {
      setState(() {
        _isUserInEvent = isUserInEvent;
        isCheckingUserStatus = false;
      });
    }
  }

  Future<void> joinEvent() async {
    setState(() {
      joinRequest = true;
    });
    List<String> res =
        await RegisterController().joinEvent(widget.event.eventId, context);
    if (mounted && res.length - 1 == widget.event.participants.length) {
      setState(() {
        _isUserInEvent = true;
        widget.event.participants = res;
        joinRequest = false;
      });
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
                        const Text(
                          "TOCAI & BUBU",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff354052)),
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  getScreen(
                                      context,
                                      () => EventParticipantsScreen(
                                          event: widget.event));
                                },
                                child: const Icon(Icons.people)),
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
                    // Card Widget with Event Image and Details
                    Card(
                      // margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 225,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        widget.event.image,
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 50,
                                child: SizedBox(
                                  width: 49,
                                  height: 42,
                                  child: Image.asset(
                                    "assets/images/${isEventOpen(widget.event.eventType, widget.event.eventTime, widget.event.untilDate, widget.event.eventDate) ? "open_badge" : "close_badge"}.png",
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 105,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        widget.event.categoryColor.toString())),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.access_time_filled,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.event.eventTime,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 225,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: widget.event.eventType == "special"
                                      ? const Color(0xffD9C301)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.event.eventName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      widget.event.eventDescription,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 105,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff4D4D4D),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ...List.generate(
                                        5,
                                        (index) => Icon(
                                          index < widget.event.rating.floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                            child: joinRequest
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
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
