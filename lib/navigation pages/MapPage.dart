import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/loadingPage.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

// ✅ CONDITIONAL IMPORT — platform decides automatically
import 'package:signtalk/components/stub_location.dart'
    if (dart.library.html) 'package:signtalk/components/web_location.dart'
    if (dart.library.io) 'package:signtalk/components/mobile_location.dart';

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

  // ✅ IMPORTANT: Replace with your REAL API KEY
  final String apiKey = "YOUR_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    _loadUserAndNearbyHospitals();
  }

  // ✅ Universal location fetch (Web + iOS + Android)
  Future<void> _loadUserAndNearbyHospitals() async {
    try {
      final map = await getLocation(); // ✅ Works on Web + iOS + Android

      final userLoc = LatLng(map["lat"]!.toDouble(), map["lng"]!.toDouble());

      setState(() => _userLocation = userLoc);

      await _fetchNearbyHospitals(userLoc);
    } catch (e) {
      debugPrint("Location error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Fetch hospitals from Google Places API
  Future<void> _fetchNearbyHospitals(LatLng userLoc) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${userLoc.latitude},${userLoc.longitude}"
        "&radius=5000&type=hospital&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      debugPrint("API error: ${response.body}");
      return;
    }

    final data = json.decode(response.body);
    final hospitals = data['results'] as List;

    Set<Marker> markers = {
      // ✅ User location marker
      Marker(
        markerId: const MarkerId("user_location"),
        position: userLoc,
        infoWindow: const InfoWindow(title: "You are here"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),

      // ✅ Main hospital marker
      Marker(
        markerId: MarkerId(widget.name),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.name,
          snippet: "Main Hospital",
          onTap: () => _openInGoogleMaps(widget.latitude, widget.longitude),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    // ✅ Add nearby hospitals
    for (var h in hospitals) {
      final name = h['name'] ?? "Unknown Hospital";
      final lat = h['geometry']['location']['lat'];
      final lng = h['geometry']['location']['lng'];

      markers.add(
        Marker(
          markerId: MarkerId(name),
          position: LatLng(lat.toDouble(), lng.toDouble()),
          infoWindow: InfoWindow(
            title: name,
            snippet: h['vicinity'] ?? "",
            onTap: () => _openInGoogleMaps(lat, lng),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() => _markers = markers);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCameraOnHospital();
    });
  }

  // ✅ Focus camera on the selected hospital
  Future<void> _centerCameraOnHospital() async {
    final hospitalLoc = LatLng(widget.latitude, widget.longitude);
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: hospitalLoc, zoom: 16.5),
      ),
    );
  }

  // ✅ Open Google Maps external directions
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
              ? const Center(child: LoadingScreen(message: "Loading Map..."))
              : _userLocation == null
              ? const Center(child: Text("Unable to get your location"))
              : Column(
                children: [
                  // ✅ GOOGLE MAP
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: (controller) => mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: _markers,
                    ),
                  ),

                  // ✅ Directions button
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
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
