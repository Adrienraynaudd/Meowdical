import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

class GeolocPage extends StatefulWidget {
  const GeolocPage({Key? key}) : super(key: key);

  @override
  _GeolocPageState createState() => _GeolocPageState();
}

class _GeolocPageState extends State<GeolocPage> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  GooglePlace _googlePlace;
  List<SearchResult> _searchResults = [];

  _GeolocPageState()
      : _googlePlace = GooglePlace("AIzaSyCbTRSUYMFR-tAoPu6ocyPqqHPuYNIXGEI");

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
      print('Location services are disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (_currentPosition == null) {
        await _getCurrentLocation();
      }
    } else {
      print('Location permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _searchVets() async {
    try {
      final result = await _googlePlace.search.getNearBySearch(
        Location(
            lat: _currentPosition!.latitude, lng: _currentPosition!.longitude),
        5000,
        type: 'veterinary_care',
      );

      if (result != null &&
          result.results != null &&
          result.results!.isNotEmpty) {
        setState(() {
          _searchResults = result.results!;
        });
      }
    } catch (e) {
      print('Error searching vets: $e');
    }
  }

//eeeeeeeeeeeeeeeeeeeeeeeee
  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    if (_currentPosition != null) {
      markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'Your Location'),
      ));
    }

    for (var result in _searchResults) {
      markers.add(Marker(
        markerId: MarkerId(result.placeId ?? ""),
        position: LatLng(
          result.geometry?.location?.lat ?? 0.0,
          result.geometry?.location?.lng ?? 0.0,
        ),
        infoWindow: InfoWindow(title: result.name ?? ""),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation'),
      ),
      body: _currentPosition != null
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                    },
                    markers: _createMarkers(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _searchVets,
                  child: Text('Search Veterinarians'),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
