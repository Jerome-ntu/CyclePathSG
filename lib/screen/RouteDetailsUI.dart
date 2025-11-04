import 'package:cyclepathsg/provider/route_provider.dart';

import 'package:cyclepathsg/widgets/route_details_card.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RouteDetailsUI extends StatefulWidget {
  const RouteDetailsUI({
    super.key,
  });

  @override
  State<RouteDetailsUI> createState() => _RouteDetailsUIState();
}

class _RouteDetailsUIState extends State<RouteDetailsUI> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  // callback when google maps is ready
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: Consumer<RouteProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              // google map
              _buildGoogleMap(provider),
              // show route details below
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: RouteDetailsCard(route: provider.route!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // google maps
  Widget _buildGoogleMap(RouteProvider provider) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        List<LatLng> coordList = provider.getRoute!.getCoordinatesList;
        // Go to the start of the route
        _moveToLocation(coordList[(coordList.length ~/ 2)]);
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(27.7033, 85.3066),
        zoom: 14.0,
      ),
      markers: provider.getMarkers,
      polylines: provider.getPolylines,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
    );
  }

  // smoothly moves map camera to specified location with animation according to the marker
  void _moveToLocation(LatLng location) {
    location = LatLng(location.latitude - 0.005, location.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
  }
}
