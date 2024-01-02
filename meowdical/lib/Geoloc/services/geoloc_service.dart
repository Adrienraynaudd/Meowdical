import 'package:geolocator/geolocator.dart';

class GeolocService {
  Future<Position> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle the case when the user permanently denies location permission
        throw GeolocException('Location permission denied forever.');
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else {
        // Handle the case when the user denies location permission
        throw GeolocException('Location permission denied.');
      }
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }
}

class GeolocException implements Exception {
  final String message;

  GeolocException(this.message);

  @override
  String toString() => 'GeolocException: $message';
}
