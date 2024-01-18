import 'package:flutter/material.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/AddEvent/add_event.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/Home/event_card.dart';
import 'package:uperitivo/Utils/helpers.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = getCurrentUser(context);
    List<EventModel>? events = getCurrentUserEventsList(context);

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
            child: ListView.builder(
              itemCount: events!.length,
              itemBuilder: (context, index) {
                EventModel event = events[index];
                return SizedBox(
                  height: 450, // Set your desired fixed height for the cards
                  child:
                      EventCard(event), // Assuming you have an EventCard widget
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
