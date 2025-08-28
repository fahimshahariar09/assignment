import 'package:assignment/features/set_alams/view/home_alarm.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as lat_lng; // For map coordinates

class SelectedLocation extends StatefulWidget {
  const SelectedLocation({super.key});

  @override
  State<SelectedLocation> createState() => _SelectedLocationState();
}

class _SelectedLocationState extends State<SelectedLocation> {
  lat_lng.LatLng? _liveLocation; // Current live location coordinates
  lat_lng.LatLng? _selectedLocation; // Selected location coordinates
  Stream<Position>? _positionStream;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _startLocationUpdates(); // Start live location updates
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<void> _startLocationUpdates() async {
    await _checkAndRequestPermission();

    // Start listening to location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update only when user moves 10 meters
      ),
    );

    // Listen to the stream for live location updates
    _positionStream!.listen((Position position) {
      setState(() {
        _liveLocation = lat_lng.LatLng(position.latitude, position.longitude);
        // Move map to the live location
        if (_liveLocation != null) {
          _mapController.move(_liveLocation!, 15.0); // Zoom level 15
        }
      });
    });
  }

  // Function to select the current live location
  Future<void> _selectCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLocation = lat_lng.LatLng(
          position.latitude,
          position.longitude,
        );
      });
    } catch (e) {
      // Optionally show a snackbar or dialog for error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error selecting location")));
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Access")),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _liveLocation ?? lat_lng.LatLng(0, 0), // Default center
                initialZoom: 15.0,
                interactionOptions: InteractionOptions(
                  flags:
                      InteractiveFlag.all &
                      ~InteractiveFlag.rotate, // Disable rotation
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'], // OpenStreetMap tiles
                ),
                MarkerLayer(
                  markers: [
                    // Live location marker
                    if (_liveLocation != null)
                      Marker(
                        point: _liveLocation!,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    // Selected location marker
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:(){
                    Get.to(HomeAlarm());
                  },
                  child: ElevatedButton(
                    onPressed: _selectCurrentLocation,
                    child: Text("Select Location"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
