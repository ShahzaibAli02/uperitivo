import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  final Function(Position, String) onLocationSelected;

  const MapScreen({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Marker> _markers = [];
  String? _selectedPharmacyName;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromCoordinates(position.latitude, position.longitude);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Location permission denied.');
    }
  }

  void _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = placemark.street ?? '';
        String city = placemark.locality ?? '';
        String state = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';

        setState(() {
          _currentAddress = '$address, $city, $state, $country';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Column(
        children: [
          _currentPosition != null
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Location:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Latitude: ${_currentPosition?.latitude}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Longitude: ${_currentPosition?.longitude}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Address: ${_currentAddress ?? 'Fetching address...'}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Selected Pharmacy:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Expanded(
            child: _currentPosition != null
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: Set<Marker>.from(_markers),
                    onTap: (LatLng location) {
                      setState(() {
                        _selectedPharmacyName = null;
                      });
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentPosition != null) {
            widget.onLocationSelected(_currentPosition!, _currentAddress!);
          } else {
            print('Please select a location');
          }
        },
        label: const Text('Continue'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
