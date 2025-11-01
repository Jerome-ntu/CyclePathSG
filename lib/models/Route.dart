import 'package:cyclepathsg/models/Location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Route{
  String routeName;
  String routeId;
  List<LatLng> coordinatesList;

  Route(this.routeName, this.routeId, this.coordinatesList);

  // getters
  String get getRouteName => routeName;
  String get getRouteId => routeId;
  List<LatLng> get getCoordinatesList => coordinatesList;

  // setters
  set setRouteName(String name) => routeName = name;
  set setRouteId(String id) => routeId = id;
  set setCoordinatesList(List<LatLng> newRoute) => coordinatesList = newRoute;
}