import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Provider/user_provider.dart';
import 'package:uperitivo/Screens/AddEvent/add_event.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/Home/event_card.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  UserModel? user;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String? _selectedValue = null;
  String orderBy = "data";
  double userLatitude = 0.0;
  double userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    user = getCurrentUser(context);
    getUserLocation();
  }

  void getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    void openDrawer() {
      scaffoldKey.currentState?.openEndDrawer();
    }

    void showSortOptions() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Center(child: Text('> Ordina per data')),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      orderBy = "data";
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Center(child: Text('> Ordina per distanza')),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      orderBy = "distance";
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Center(
                      child: Text('? Ordina per ordine alfabetico')),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      orderBy = "alphabet";
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              openDrawer();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                    value: 'All',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  const Text('All'),
                  Radio(
                    value: 'recurring',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  const Text('Sempre'),
                  Radio(
                    value: 'special',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  const Text('Speciale'),
                ],
              ),
              Row(
                children: [
                  const Text('Ordina'),
                  IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      showSortOptions();
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                List<EventModel> events = userProvider.getcurrentUserEvents();

                if (_selectedValue == "recurring") {
                  events = events
                      .where((event) => event.eventType == "recurring")
                      .toList();
                } else if (_selectedValue == "special") {
                  events = events
                      .where((event) => event.eventType == "special")
                      .toList();
                }

                if (orderBy == "distance") {
                  // Sort events by distance based on longitude and latitude
                  events.sort((a, b) {
                    // Replace 'a' and 'b' with the actual names of your latitude and longitude fields
                    double distanceA = calculateDistance(
                        a.latitude, a.longitude, userLatitude, userLongitude);
                    double distanceB = calculateDistance(
                        b.latitude, b.longitude, userLatitude, userLongitude);

                    return distanceA.compareTo(distanceB);
                  });
                } else if (orderBy == "alphabet") {
                  // Sort events by eventName in ascending order
                  events.sort((a, b) => a.eventName.compareTo(b.eventName));
                }

                return events.isNotEmpty
                    ? ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          EventModel event = events[index];
                          return SizedBox(
                            height: 500,
                            child: EventCard(
                              event: event,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No events to show',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: user?.userType == 'company'
          ? FloatingActionButton(
              onPressed: () {
                getScreen(context, () => const AddEventHome());
              },
              shape: const CircleBorder(),
              backgroundColor: const Color(0xff5887DC),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: const DrawerScreen(),
    );
  }
}