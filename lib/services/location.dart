import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CurretLocation {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
  Future<String> getAddress(Position position) async {
    print('getting address...');
    List<Placemark> placeMark=await placemarkFromCoordinates(position.latitude, position.longitude);
    print('printing address: ${placeMark}');
    Placemark place=placeMark[2];
    String Address='${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
    return Address; 
  }
}
