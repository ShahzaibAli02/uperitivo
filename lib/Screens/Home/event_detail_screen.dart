import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/AddEvent/add_event.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/Home/event_participants.dart';
import 'package:uperitivo/Screens/UserAccount/login.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventDetailScreen extends StatefulWidget {
  EventModel event;
  final void Function(String)? onBackClicked;

  final String action;

  EventDetailScreen(
      {super.key,
      required this.event,
      required this.onBackClicked,
      required this.action});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isUserInEvent = false;
  bool isCheckingUserStatus = false;
  bool joinRequest = false;
  bool cancelRequest = false;
  UserModel? user;
  int userRating = -1;
  bool isChild = false;
  late EventModel clickedEvent;

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
    if (!isEventOpen(widget.event.eventType, widget.event.eventTime,
            widget.event.untilDate, widget.event.eventDate) &&
        _isUserInEvent &&
        !widget.event.hasUserRated(user!.uid)) {
      // showRatingModal = true;
      _openRatingModal();
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
      });
    }
    setState(() {
      joinRequest = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> cancelEvent() async {
    setState(() {
      cancelRequest = true;
    });
    List<String> res =
        await RegisterController().removeEvent(widget.event.eventId, context);
    if (kDebugMode) {
      print(res.length);
      print(widget.event.participants.length);
    }

    if (mounted && res.length == widget.event.participants.length - 1) {
      setState(() {
        _isUserInEvent = false;
        widget.event.participants = res;
      });
    }
    setState(() {
      cancelRequest = false;
    });
  }

  void _showLocationModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.event.longitude,
                      widget.event.latitude,
                    ),
                    zoom: 0,
                  ),
                  onMapCreated: (GoogleMapController controller) {},
                  onTap: (LatLng location) {
                    // Handle map tap
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: <Marker>{
                    Marker(
                      markerId: MarkerId(widget.event.eventId),
                      position:
                          LatLng(widget.event.latitude, widget.event.longitude),
                      infoWindow: InfoWindow(
                        title: widget.event.eventName,
                        snippet: widget.event.companyName,
                      ),
                    )
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openRatingModal() async {
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Rate the Event',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: userRating == 0,
                        onChanged: (value) {
                          setState(() {
                            userRating = value! ? 0 : -1;
                          });
                        },
                      ),
                      const Text('I haven\'t attended the event'),
                    ],
                  ),
                  if (userRating != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          return IconButton(
                            icon: Icon(
                              index < userRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              setState(() {
                                userRating = index + 1;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) {
                        print('User Rating: $userRating');
                      }

                      bool res = await RegisterController()
                          .addRating(widget.event.eventId, userRating, context);

                      if (res) {
                        if (context.mounted) {
                          await RegisterController()
                              .getAllEventsForCompanies(context);
                        }
                        if (context.mounted) {
                          showSuccessSnackBar(
                              context, 'Thanks for your feedback');
                        }
                      } else {
                        if (context.mounted) {
                          showErrorSnackBar(
                              context, "Error while recording rating!");
                        }
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit Rating'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isChild
        ? EventParticipantsScreen(
            event: widget.event,
            onBackClicked: () {
              setState(() {
                isChild = false;
              });
            })
        : Scaffold(
            key: _scaffoldKey,
            drawerEnableOpenDragGesture: false,
            body: Column(
              children: [
                Header(
                  onIconTap: () {
                    widget.onBackClicked!("");
                  },
                  onDrawerTap: () {
                    _openDrawer();
                  },
                  showBackButton: true,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       widget.event.companyName,
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 20,
                                //           color: Color(0xff354052)),
                                //     ),
                                //     Row(
                                //       children: [
                                //         InkWell(
                                //             onTap: () {
                                //               getScreen(
                                //                   context,
                                //                   () => EventParticipantsScreen(
                                //                       event: widget.event));
                                //             },
                                //             child: const Icon(
                                //               Icons.people,
                                //               size: 40,
                                //             )),
                                //         const SizedBox(width: 5),
                                //         Text(
                                //           "${widget.event.participants.length}",
                                //           style: const TextStyle(fontSize: 25),
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),

                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   widget.event.eventName.length > 33
                                    //       ? '${widget.event.eventName.substring(0, 33)}...'
                                    //       : widget.event.eventName,
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 20,
                                    //     color: Color(0xff354052),
                                    //   ),
                                    // ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.location_on,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _showLocationModal();
                                      },
                                      tooltip: 'Show Location',
                                      splashColor: Colors.blue.withOpacity(0.2),
                                      highlightColor:
                                          Colors.blue.withOpacity(0.1),
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            color: Colors.white,
                            elevation: 10,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(12.0),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                widget.event.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Center(
                                          // Wrap the Text widget with a Center widget
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                8.0), // Add some padding around the text
                                            color: Colors.black.withOpacity(
                                                0.5), // Semi-transparent black background
                                            child: Text(
                                              widget.event.eventName,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius:
                                                        10, // Increase the blur radius
                                                    color: Colors.black,
                                                    offset: Offset(4,
                                                        4), // Increase the offset
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                          color: Color(int.parse(widget
                                              .event.categoryColor
                                              .toString())),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color:
                                            widget.event.eventType == "special"
                                                ? const Color(0xffD9C301)
                                                : Colors.white,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          bottom: Radius.circular(12.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            widget.event.companyName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          // Limited to 2 lines
                                          Text(
                                            widget.event.eventDescription,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            height: 1.0,
                                            color: const Color(0xFF707070),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatItalianDate(
                                                    widget.event.eventDate),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text(
                                                "|",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isChild = true;
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.people,
                                                      color: widget.event
                                                                  .eventType !=
                                                              "special"
                                                          ? const Color(
                                                              0xffA0A0A0)
                                                          : Colors.white,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      "${widget.event.participants.length}",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                "|",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Text(
                                                  'Partecipa !',
                                                  style: TextStyle(
                                                      color: widget.event
                                                                  .eventType !=
                                                              "special"
                                                          ? const Color(
                                                              0xffEC6500)
                                                          : Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ...List.generate(
                                              5,
                                              (index) => Icon(
                                                index <
                                                        widget.event
                                                            .calRating()
                                                            .floor()
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (user != null)
                                  if (user!.userType == "company" &&
                                      widget.action == "self")
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              getScreen(
                                                  context,
                                                  () => AddEventHome(
                                                        action: "edit",
                                                        event: widget.event,
                                                        onBackClicked:
                                                            (eventModel) {
                                                          widget.event =
                                                              eventModel;
                                                          setState(() {});
                                                        },
                                                      ));
                                            },
                                            child: Tooltip(
                                              message: 'Edit',
                                              child: Material(
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: widget.event.eventType !=
                                                        "special"
                                                    ? const Color(0xffEC6500)
                                                    : Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: widget.event
                                                                .eventType !=
                                                            "special"
                                                        ? Colors.white
                                                        : const Color(
                                                            0xffEC6500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Confirm Deletion"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this event?"),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();

                                                          bool res = await RegisterController()
                                                              .deleteEventInUserEvents(
                                                                  widget.event
                                                                      .eventId,
                                                                  context);

                                                          if (res) {
                                                            widget.onBackClicked!(
                                                                "deleted");
                                                          } else {
                                                            if (context
                                                                .mounted) {
                                                              showErrorSnackBar(
                                                                  context,
                                                                  'Error deleting event');
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                            "Delete"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Tooltip(
                                              message: 'Delete',
                                              child: Material(
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: widget.event.eventType !=
                                                        "special"
                                                    ? const Color(0xffEC6500)
                                                    : Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: widget.event
                                                                .eventType !=
                                                            "special"
                                                        ? Colors.white
                                                        : const Color(
                                                            0xffEC6500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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
                                  widget.event.eventType,
                                  widget.event.eventTime,
                                  widget.event.untilDate,
                                  widget.event.eventDate))
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: _isUserInEvent ||
                                        isCheckingUserStatus ||
                                        user.runtimeType.toString() == "null"
                                    ? cancelEvent
                                    : joinEvent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isUserInEvent
                                      ? Colors.white
                                      : Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.green),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: joinRequest || cancelRequest
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: joinRequest
                                                ? Colors.white
                                                : Colors.green,
                                          ),
                                        )
                                      : Text(
                                          _isUserInEvent ? 'C6 !' : 'Partecipa',
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
