// stub_location.dart (iOS/Android/Desktop)
// Prevents dart:html from being imported.

Future<Map<String, double>> getLocation() async {
  throw UnsupportedError("Web geolocation is not supported on this platform.");
}
