import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';
import 'package:cyclepathsg/utils/colors.dart';
import 'package:cyclepathsg/utils/font_awesome_helper.dart';

import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    hide Route;

class RouteProvider extends ChangeNotifier {
  Route? route;
  List<Route> suggestedRoutes = [];
  Set<Polyline> polylines = {};
  BitmapDescriptor? destinationIcon;
  Set<Marker> markers = {};

  CurrentLocationProvider? currentLocationProvider;
  Polyline originToDest = Polyline(
    polylineId: PolylineId('empty'),
    points: const [],
  );

  RouteProvider() {
    _init();
  }

  Future<void> _init() async {
    _loadIcon();
    suggestedRoutes.add(
        Route("Marina Bay", "id1", RouteType.suggested, [
          LatLng(1.27411088541224, 103.860702151563999),
          LatLng(1.27437138501779, 103.860869464401006),
          LatLng(1.27569887026108, 103.861724272352006),
          LatLng(1.27559366117944, 103.862029997294997),
          LatLng(1.27569887026108, 103.861724272352006),
          LatLng(1.27598267060992, 103.861904357450996),
          LatLng(1.27382115923958, 103.865252298407),
          LatLng(1.27367337405472, 103.865050976977997),
          LatLng(1.27413795755557, 103.864870128961996),
          LatLng(1.27389104054287, 103.864582116502007),
          LatLng(1.27389104054287, 103.864582116502007),
          LatLng(1.27367337405472, 103.865050976977997),
          LatLng(1.28016914079444, 103.868955068991994),
          LatLng(1.28013649530943, 103.869064654219997),
          LatLng(1.28096632150371, 103.858279264523006),
          LatLng(1.28087136449226, 103.858606221892998),
          LatLng(1.28149288475176, 103.860785453218),
          LatLng(1.2815905081523, 103.860369532489997),
          LatLng(1.2726433434847, 103.863528330709997),
          LatLng(1.27293086952388, 103.863106702598003),
          LatLng(1.2772662414915, 103.855901404351997),
          LatLng(1.27702239486204, 103.856207501396995),
          LatLng(1.27809931521694, 103.854648577511995),
          LatLng(1.27812355531169, 103.854600337939999),
          LatLng(1.27833297144179, 103.854757912565006),
          LatLng(1.27831448960267, 103.854786258569007),
        ]),
    );
    suggestedRoutes.add(
      Route("Toa Payoh", "id2", RouteType.suggested,
          [
            LatLng(1.33600806245757, 103.855564936134996),
            LatLng(1.33605531414845, 103.855514804218998),
            LatLng(1.33605531414845, 103.855514804218998),
            LatLng(1.33627016336069, 103.855287151099006),
            LatLng(1.33628793066538, 103.855269322070001),
            LatLng(1.33628793066538, 103.855269322070001),
            LatLng(1.33633172041989, 103.855221776161997),
            LatLng(1.33633172041989, 103.855221776161997),
            LatLng(1.33634975003875, 103.855198483002994),
            LatLng(1.33636161793874, 103.855206851378995),
            LatLng(1.33636659553351, 103.855209894839007),
            LatLng(1.33638841807308, 103.855184789321001),
            LatLng(1.33638841807308, 103.855184789321001),
            LatLng(1.33655610700505, 103.854997258143996),
            LatLng(1.33655610700505, 103.854997258143996),
            LatLng(1.33659511080746, 103.854955366810003),
            LatLng(1.33659511080746, 103.854955366810003),
            LatLng(1.33666250926946, 103.854876236779006),
            LatLng(1.33672417939008, 103.854807824695996),
            LatLng(1.33698298751203, 103.854519111206002),
            LatLng(1.33115128019779, 103.850167473602994),
            LatLng(1.33114668523408, 103.850282351274998),
            LatLng(1.33115357501457, 103.850494609147006),
            LatLng(1.33117118433888, 103.850688607536),
            LatLng(1.33122554698063, 103.851014221300005),
            LatLng(1.33126612673924, 103.851260714412007),
            LatLng(1.33129522267374, 103.851409066244997),
            LatLng(1.33134728890424, 103.851510250339999),
            LatLng(1.33141160693082, 103.851561223209004),
            LatLng(1.33140025519052, 103.851582279892),
          ]),
    );
    suggestedRoutes.add(
      Route("Gardens by the Bay", "id3", RouteType.suggested, [
        LatLng(1.2900, 103.8460),
        LatLng(1.2915, 103.8475),
        LatLng(1.2930, 103.8490),
        LatLng(1.2945, 103.8505),
        LatLng(1.2960, 103.8520),
      ]),
    );
  }

  Future<void> setOriginToDest() async {
    List<LatLng> guidedRoute = await getRoutePoints(
      currentLocationProvider!.currentLocation,
      route!.getCoordinatesList[0],
    );
    originToDest = Polyline(
      polylineId: PolylineId("current_route"),
      points: guidedRoute,
      color: Colors.green,
      width: 6,
    );
  }

  Future<List<LatLng>> getRoutePoints(LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: "AIzaSyArfU5Nu8f3VS1V6h1evUJIxpfDzbPYKU4",
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.bicycling,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    } else {
      print(result.errorMessage);
      return [];
    }
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
        icon:
        destinationIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        anchor: const Offset(0.1, 1.0),
        // bottom center
        infoWindow: InfoWindow(title: "Destination location"),
      ),
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
    destinationIcon = await getFontAwesomeBitmap(
      FontAwesomeIcons.flagCheckered,
      size: 80,
      color: Colors.black,
    );
  }

  void addSuggestedRoute(Route route) {
    suggestedRoutes.add(route);
  }
}
