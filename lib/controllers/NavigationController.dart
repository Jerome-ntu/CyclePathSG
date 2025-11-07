import 'package:cyclepathsg/provider/pcn_provider.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/provider/route_provider.dart';
import 'package:cyclepathsg/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class NavigationController extends ChangeNotifier {
  final CurrentLocationProvider currentLocationProvider;
  final PcnProvider pcnProvider;
  final RouteProvider routeProvider;
  Set<Marker> _markers = {};
  final List<LatLng> route = [];
  Set<Polyline> _polylines = {};
  Polyline _routeOriginToDestination = Polyline(
    polylineId: PolylineId('empty'),
    points: const [],
  );

  NavigationController(
    this.currentLocationProvider,
    this.pcnProvider,
    this.routeProvider,
  ) {
    route.add(currentLocationProvider.currentLocation);
    // turn on continuously check for location change
    currentLocationProvider.continuouslyCheckLocationChange();
    currentLocationProvider.addListener(_onLocationChanged);

    _buildMarkers(currentLocationProvider, routeProvider);
    // 🔧 Schedule async init after constructor finishes
    Future.microtask(() async {
      await _init();
      notifyListeners();
    });
    print("test1");
  }

  Future<void> _init() async {
    print(this.routeProvider.route!.getCoordinatesList);
    List<LatLng> routePoints = await getRoutePoints(this.currentLocationProvider.currentLocation, this.routeProvider.route!.getCoordinatesList[0]);

    await Future.delayed(Duration.zero);
    _routeOriginToDestination = createPolyline("origin_to_destination", routePoints, Colors.blueAccent);
    String id = _routeOriginToDestination.polylineId.toString();
    print("test2 $id");

    _polylines = {
      ..._polylines,
      ...routeProvider.polylines,
      ...pcnProvider.pcnPolylines,
    };
    _polylines.add(_routeOriginToDestination);
    notifyListeners(); // ensures the map rebuilds
  }

  void _onLocationChanged() {
    if (currentLocationProvider.currentLocation != route[route.length-1]){
      route.add(currentLocationProvider.currentLocation);
    }
    _updatePolylines();
    print("Route $route");
    notifyListeners();
  }

  Future<List<LatLng>> getRoutePoints(LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints(apiKey: "AIzaSyArfU5Nu8f3VS1V6h1evUJIxpfDzbPYKU4");

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.bicycling,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
    } else {
      print(result.errorMessage);
      return [];
    }
  }

  void _buildMarkers(
    CurrentLocationProvider currentLocationProvider,
    RouteProvider routeProvider,
  ) {
    currentLocationProvider.loadCurrentLocationIcon();
    currentLocationProvider.loadOriginIcon();
    // origin marker
    _markers.add(
      Marker(
        markerId: MarkerId("origin"),
        position: currentLocationProvider.currentLocation,
        icon: currentLocationProvider.originIcon!,
        infoWindow: InfoWindow(title: "Origin location"),
      ),
    );

    // current location marker
    _markers.add(
      Marker(
        markerId: MarkerId("current_location"),
        position: currentLocationProvider.currentLocation,
        icon: currentLocationProvider.currentLocationIcon!,
        infoWindow: InfoWindow(title: "Current location"),
      ),
    );

    _markers = _markers.union(routeProvider.getMarkers);
  }

  Polyline createPolyline(String polylineId, List<LatLng> route, Color color){
    return Polyline(
      polylineId: PolylineId(polylineId),
      points: route,
      color: color,
      width: 6,
    );

  }

  void _updatePolylines() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId("current_route"),
        points: route,
        color: Colors.green,
        width: 6,
      ),
    );
    notifyListeners();
  }

  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
}
