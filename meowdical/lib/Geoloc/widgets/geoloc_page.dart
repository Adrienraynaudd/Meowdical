import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geoloc_service.dart';

class GeolocPage extends StatefulWidget {
  const GeolocPage({Key? key}) : super(key: key);

  @override
  _GeolocPageState createState() => _GeolocPageState();
}

class _GeolocPageState extends State<GeolocPage> {
  final GeolocService _geolocService = GeolocService();
  late GoogleMapController _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeGeolocation();
  }

  void _initializeGeolocation() async {
    await _requestLocationPermissionAndGetCurrentLocation();
  }

  Future<void> _requestLocationPermissionAndGetCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // Location services are not enabled
      // You may want to show an alert or guide the user to enable location services
      print('Location services are disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
    } else {
      // Handle the case when the user denies location permission
      print('Location permission denied');
      // You may want to show an alert or guide the user to grant location permission
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _geolocService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
      // Handle the case when there's an error getting the location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation'),
      ),
      body: _currentPosition != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentPosition,
                  infoWindow: InfoWindow(title: 'Your Location'),
                ),
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
