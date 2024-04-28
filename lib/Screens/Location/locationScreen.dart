import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  EventModel? selectedEvent;
  List<EventModel>? events;
  UserModel? user;
  String query = "";
  List<EventModel> filteredList = [];
  GoogleMapController? _googleMapController;

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
        filteredList = eventList;
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
            showSearch: true,
            onSearchChanged: (value) {
              query = value;
              filteredList = events!
                  .where((event) =>
                      event.city.toLowerCase().contains(query.toLowerCase()))
                  .toList();

              setState(() {});
            },
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  filteredList.isNotEmpty ? filteredList[0].latitude : 0.0,
                  filteredList.isNotEmpty ? filteredList[0].longitude : 0.0,
                ),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
              onTap: (LatLng location) {
                // Handle map tap
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.from(filteredList.map((event) {
                    return Marker(
                      markerId: MarkerId(event.eventId),
                      position: LatLng(event.latitude, event.longitude),
                      infoWindow: InfoWindow(
                        title: event.eventName,
                        snippet: event.companyName,
                      ),
                    );
                  }) ??
                  []),
            ),
          ),
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}
