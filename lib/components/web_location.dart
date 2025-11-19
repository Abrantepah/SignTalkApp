// web_location.dart (Web-only)
// Only imported on Web.

import 'dart:html' as html;

Future<Map<String, double>> getLocation() async {
  final pos = await html.window.navigator.geolocation.getCurrentPosition();

  final lat = (pos.coords?.latitude ?? 0).toDouble();
  final lng = (pos.coords?.longitude ?? 0).toDouble();

  return {"lat": lat, "lng": lng};
}
