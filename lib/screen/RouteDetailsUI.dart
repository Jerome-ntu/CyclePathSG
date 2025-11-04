import 'package:cyclepathsg/provider/route_provider.dart';
import 'package:cyclepathsg/utils/colors.dart';
import 'package:cyclepathsg/utils/font_awesome_helper.dart';
import 'package:cyclepathsg/widgets/route_details_card.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RouteDetailsUI extends StatefulWidget {
  const RouteDetailsUI({
    super.key,
  });

  @override
  State<RouteDetailsUI> createState() => _RouteDetailsUIState();
}

class _RouteDetailsUIState extends State<RouteDetailsUI> {
  GoogleMapController? _mapController;
  BitmapDescriptor? faIcon;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  // callback when google maps is ready
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _loadIcon() async {
    faIcon = await getFontAwesomeBitmap(FontAwesomeIcons.flagCheckered, size: 80, color: Colors.black);
    setState(() {});
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
              // show current location on top
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
        // Go to the start of the route
        _moveToLocation(provider.getRoute!.getCoordinatesList[0]);
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(27.7033, 85.3066),
        zoom: 14.0,
      ),
      markers: _buildMarkers(provider),
      polylines: _buildPolylines(provider),
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
    );
  }

  Set<Marker> _buildMarkers(RouteProvider provider) {
    Set<Marker> markers = {};

    // origin marker
    markers.add(
      Marker(
        markerId: MarkerId("pickup"),
        position: provider.getRoute!.getCoordinatesList[0],
        icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "Pickup location"),
    ),
    );

    // destination marker
    var coord_list = provider.getRoute!.getCoordinatesList;
    markers.add(
    Marker(
    markerId: MarkerId("delivery"),
    position: coord_list[coord_list.length - 1],
    icon: faIcon ?? BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    ),
    anchor: const Offset(0.1, 1.0), // bottom center
    infoWindow: InfoWindow(title: "Delivery location"),
    )
    ,
    );
    // delivery boy marker (when moving)
    // if (provider.currentDeliveryBoyPosition != null) {
    //   markers.add(
    //     Marker(
    //       markerId: MarkerId("delivery_boy"),
    //       position: provider.currentDeliveryBoyPosition ?? LatLng(0.0, 0.0),
    //       icon: BitmapDescriptor.defaultMarkerWithHue(
    //         BitmapDescriptor.hueBlue,
    //       ),
    //       infoWindow: InfoWindow(title: "Delivery Boy"),
    //     ),
    //   );
    //   // move camer to follow delivery boy
    //   _moveToLocation(provider.currentDeliveryBoyPosition!);
    // }
    return
    markers;
  }

  // creates route line on map showing path between locations
  Set<Polyline> _buildPolylines(RouteProvider provider) {
    Set<Polyline> polylines = {};

    // show polyline when order is accepted

    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: provider.getRoute!.getCoordinatesList,
        color: buttonMainColor,
        width: 6,
      ),
    );

    return polylines;
  }

  // smoothly moves map camera to specified location with animation according to the marker
  void _moveToLocation(LatLng location) {
    location = LatLng(location.latitude - 0.005, location.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 14));
  }
}
