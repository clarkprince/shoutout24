import 'package:geolocator/geolocator.dart';
import 'package:shoutout24/model/userLocationModel.dart';

class LocationService {
  Future<UserLocationModel> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    Position _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return UserLocationModel(
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude,
        time: new DateTime.now().toString());
  }
}
