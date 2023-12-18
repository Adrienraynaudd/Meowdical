import 'package:geolocator/geolocator.dart';

class GeolocService {
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }
}
