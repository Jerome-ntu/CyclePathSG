import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RouteProvider extends ChangeNotifier{
  Route? route;
  List<Route> suggestedRoutes = [];

  RouteProvider(){
    _init();
  }

  Future<void> _init() async {
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

  void setRoute(Route route) {
    print(route.getCoordinatesList);
    this.route = route;
    notifyListeners(); // important: triggers Consumer to rebuild
  }

  void addSuggestedRoute(Route route){
    suggestedRoutes.add(route);
  }
}