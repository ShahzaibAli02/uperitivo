import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Events/events_screen.dart';
import 'package:uperitivo/Screens/Home/home.dart';
import 'package:uperitivo/SplashScreen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    EventsScreen(),
    ParticipantsScreen(),
    LocationScreen(),
    PreviousScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xffA0A0A0),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Color(0xffA0A0A0)),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Color(0xffA0A0A0)),
            label: 'Participants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Color(0xffA0A0A0)),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back, color: Color(0xffA0A0A0)),
            label: 'Previous',
          ),
        ],
      ),
    );
  }
}

class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Participants Screen'),
    );
  }
}

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Location Screen'),
    );
  }
}

class PreviousScreen extends StatelessWidget {
  const PreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await RegisterController().signOut(context);
          if (context.mounted) {
            getScreen(context, () => SplashScreen());
          }
        },
        child: const Text('Sign Out'),
      ),
    );
  }
}
