import 'package:cyclepathsg/models/Route.dart';
import 'package:flutter/material.dart' hide Route;

class RouteProvider extends ChangeNotifier{
  Route? route;

  RouteProvider();

  Route? get getRoute => route;

  void setRoute(Route route) {
    print(route.getCoordinatesList);
    this.route = route;
    notifyListeners(); // important: triggers Consumer to rebuild
  }
}