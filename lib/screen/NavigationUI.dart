import 'package:cyclepathsg/utils/font_awesome_helper.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';
import 'package:cyclepathsg/provider/route_provider.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';

import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<CurrentLocationProvider>(context);
    final pcnProvider = Provider.of<PcnProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: Consumer<RouteProvider>(
        builder: (context, routeProvider, child) {
          return Stack(
            children: [
              // google map
              _buildGoogleMap(routeProvider, currentLocationProvider, pcnProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoogleMap(RouteProvider routeProvider,
      CurrentLocationProvider currentLocationProvider,
      PcnProvider pcnProvider) {
    Set<Polyline> polylines = routeProvider.getPolylines;
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        // Go to the start of the route
        _moveToLocation(currentLocationProvider.currentLocation);
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(27.7033, 85.3066),
        zoom: 16.0,
      ),
      markers: _buildMarkers(currentLocationProvider, routeProvider),
      polylines: polylines,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
    );
  }

  // smoothly moves map camera to specified location with animation according to the marker
  void _moveToLocation(LatLng location) {
    location = LatLng(location.latitude, location.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  Set<Marker> _buildMarkers(CurrentLocationProvider currentLocationProvider,
      RouteProvider routeProvider) {
    Set<Marker> markers = {};
    currentLocationProvider.loadCurrentLocationIcon();
    currentLocationProvider.loadOriginIcon();
    // origin marker
    markers.add(
      Marker(
        markerId: MarkerId("origin"),
        position: currentLocationProvider.currentLocation,
        icon: currentLocationProvider.originIcon!,
        infoWindow: InfoWindow(title: "Origin location"),
      ),
    );

    // current location marker
    markers.add(
      Marker(
        markerId: MarkerId("current_location"),
        position: currentLocationProvider.currentLocation,
        icon: currentLocationProvider.currentLocationIcon!,
        infoWindow: InfoWindow(title: "Current location"),
      ),
    );

    markers = markers.union(routeProvider.getMarkers);
    return markers;
  }
}
