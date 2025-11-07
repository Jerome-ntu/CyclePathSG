import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Route{
  String routeName;
  String routeId;
  RouteType routeType;
  List<LatLng> coordinatesList;

  Route(this.routeName, this.routeId, this.routeType, this.coordinatesList);

  // getters
  String get getRouteName => routeName;
  String get getRouteId => routeId;
  RouteType get getRouteType => routeType;
  List<LatLng> get getCoordinatesList => coordinatesList;

  // setters
  set setRouteName(String name) => routeName = name;
  set setRouteId(String id) => routeId = id;
  set setRouteType(RouteType type) => routeType = type;
  set setCoordinatesList(List<LatLng> newRoute) => coordinatesList = newRoute;

  void addToCoordinates(LatLng coor){
    coordinatesList.add(coor);
  }

  void addToCoordinatesList(List<LatLng> coors){
    coordinatesList.addAll(coors);
  }
}