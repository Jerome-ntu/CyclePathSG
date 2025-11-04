import 'package:cyclepathsg/utils/colors.dart';
import 'package:cyclepathsg/utils/font_awesome_helper.dart';

import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RouteProvider extends ChangeNotifier{
  Route? route;
  List<Route> suggestedRoutes = [];
  Set<Polyline> polylines = {};
  BitmapDescriptor? destinationIcon;
  Set<Marker> markers = {};

  RouteProvider(){
    _init();
  }

  Future<void> _init() async {
    _loadIcon();
    suggestedRoutes.add(Route("Marina Bay Tour", "id1", RouteType.suggested,
      [
        LatLng(1.3521, 103.8198), // Marina Bay
        LatLng(1.3550, 103.8205),
        LatLng(1.3580, 103.8210),
        LatLng(1.3600, 103.8230),
        LatLng(1.3620, 103.8250),
      ],));
    suggestedRoutes.add(Route("Explore Gardens by the Bay", "id2", RouteType.suggested,
      [
        LatLng(1.2900, 103.8460), // Gardens by the Bay
        LatLng(1.2915, 103.8475),
        LatLng(1.2930, 103.8490),
        LatLng(1.2945, 103.8505),
        LatLng(1.2960, 103.8520),
      ],));
  }

  Route? get getRoute => route;
  List<Route> get getSuggestedRoutes => suggestedRoutes;
  Set<Polyline> get getPolylines => polylines;
  Set<Marker> get getMarkers => markers;
  BitmapDescriptor? get getDestinationIcon => destinationIcon;


  void setRoute(Route route) {
    this.route = route;
    _buildPolylines();
    _buildMarkers();
    notifyListeners(); // important: triggers Consumer to rebuild
  }

  void _buildPolylines() {
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: route!.getCoordinatesList,
        color: buttonMainColor,
        width: 6,
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    // origin marker
    markers.add(
      Marker(
        markerId: MarkerId("origin"),
        position: route!.getCoordinatesList[0],
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Origin location"),
      ),
    );

    // destination marker
    var coord_list = route!.getCoordinatesList;
    markers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: coord_list[coord_list.length - 1],
        icon: destinationIcon ?? BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        anchor: const Offset(0.1, 1.0), // bottom center
        infoWindow: InfoWindow(title: "Destination location"),
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
    //   // move camera to follow delivery boy
    //   _moveToLocation(provider.currentDeliveryBoyPosition!);
    // }
    return markers;
  }

  void _loadIcon() async {
    destinationIcon = await getFontAwesomeBitmap(FontAwesomeIcons.flagCheckered, size: 80, color: Colors.black);
  }

  void addSuggestedRoute(Route route){
    suggestedRoutes.add(route);
  }
}