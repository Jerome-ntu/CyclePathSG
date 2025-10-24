import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}


class _NavigationPageState extends State<NavigationPage> {
  GoogleMapController? mapController;

  final LatLng currentLocation = const LatLng(27.7172, 85.3240); // Example: Kathmandu, Nepal

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map in Flutter")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(("Mrker Id")),
            position: currentLocation,
            draggable: true,
            onDragEnd: (value) {},
            infoWindow: InfoWindow(
              title:"Title of marker",
              snippet: "More info about marker",
            )
          ),
        },
      ),
    );
  }
}