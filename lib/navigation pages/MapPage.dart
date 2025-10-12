import 'dart:async';
import 'dart:convert';
import 'dart:html' as html; // ✅ Web geolocation
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/loadingPage.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalMapPage extends StatefulWidget {
  final String name;
  final double latitude;
  final double longitude;

  const HospitalMapPage({
    super.key,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<HospitalMapPage> createState() => _HospitalMapPageState();
}

class _HospitalMapPageState extends State<HospitalMapPage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  LatLng? _userLocation;
  bool _isLoading = true;

  // ⚠️ Replace with your real API key (secure it via environment variables or backend proxy)
  final String apiKey = "AIzaSyCwJe7_szSsj9ImfsV9QyymOJ7uFdlFIMg";

  @override
  void initState() {
    super.initState();
    _loadUserAndNearbyHospitals();
  }

  /// ✅ Hybrid geolocation (mobile + web)
  Future<void> _loadUserAndNearbyHospitals() async {
    try {
      LatLng? userLoc;

      if (kIsWeb) {
        final completer = Completer<LatLng>();
        html.window.navigator.geolocation
            ?.getCurrentPosition()
            .then((position) {
              userLoc = LatLng(
                (position.coords?.latitude ?? 0).toDouble(),
                (position.coords?.longitude ?? 0).toDouble(),
              );
              completer.complete(userLoc);
            })
            .catchError((e) {
              debugPrint("Web location error: $e");
              completer.completeError(e);
            });

        userLoc = await completer.future;
      } else {
        // 📱 Mobile
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        userLoc = LatLng(position.latitude, position.longitude);
      }

      if (userLoc != null) {
        setState(() => _userLocation = userLoc!);
        await _fetchNearbyHospitals(userLoc!);
      }
    } catch (e) {
      debugPrint("Location error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🏥 Fetch nearby hospitals + add markers
  Future<void> _fetchNearbyHospitals(LatLng userLoc) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${userLoc.latitude},${userLoc.longitude}"
        "&radius=5000&type=hospital&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final hospitals = data['results'] as List;

      Set<Marker> markers = {
        // 👤 User location marker
        Marker(
          markerId: const MarkerId("user_location"),
          position: userLoc,
          infoWindow: const InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),

        // 🏥 Main hospital marker
        Marker(
          markerId: MarkerId(widget.name),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: widget.name,
            snippet: "Main Hospital Location",
            onTap: () => _openInGoogleMaps(widget.latitude, widget.longitude),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      };

      // Add nearby hospitals (optional)
      for (var h in hospitals) {
        final name = h['name'] ?? "Unknown Hospital";
        final lat = h['geometry']['location']['lat'];
        final lng = h['geometry']['location']['lng'];

        // Avoid duplicate hospital
        if ((lat - widget.latitude).abs() < 0.0001 &&
            (lng - widget.longitude).abs() < 0.0001)
          continue;

        markers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: name,
              snippet: h['vicinity'],
              onTap: () => _openInGoogleMaps(lat, lng),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      }

      setState(() => _markers = markers);

      // ✅ Center camera on the hospital location
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerCameraOnHospital();
      });
    } else {
      debugPrint("Failed to fetch hospitals: ${response.body}");
    }
  }

  /// 🎯 Focus map on the hospital marker
  Future<void> _centerCameraOnHospital() async {
    final hospitalLoc = LatLng(widget.latitude, widget.longitude);
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: hospitalLoc, zoom: 16.5),
      ),
    );
  }

  /// 🚗 Open hospital in Google Maps
  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.background,
      appBar: CustomAppBar(),
      body:
          _isLoading
              ? const Center(child: LoadingScreen(message: "Loading Map ....."))
              : _userLocation == null
              ? const Center(
                child: Text(
                  "Unable to get your location",
                  style: TextStyle(fontSize: 16),
                ),
              )
              : Column(
                children: [
                  // 🗺️ Google Map
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: (controller) => mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 15,
                      ),
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  ),

                  // 📍 Get Directions Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => _openInGoogleMaps(
                            widget.latitude,
                            widget.longitude,
                          ),
                      icon: const Icon(Icons.directions, color: Colors.white),
                      label: Text(
                        "Get Directions to ${widget.name}",
                        style: FontsConstant.buttonText,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        shadowColor: ColorsConstant.secondary.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
