import 'package:geolocator/geolocator.dart';

Future<Map<String, double>> getLocation() async {
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return {"lat": pos.latitude, "lng": pos.longitude};
}
