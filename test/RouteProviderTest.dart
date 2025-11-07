import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:cyclepathsg/provider/route_provider.dart';

void main() {
  late RouteProvider routeProvider;
  late Route testRoute;

  setUp(() {
    routeProvider = RouteProvider();

    testRoute = Route(
      "Test Route",
      "id_test",
      RouteType.suggested,
      [
        LatLng(1.3000, 103.8000),
        LatLng(1.3010, 103.8010),
        LatLng(1.3020, 103.8020),
      ],
    );
  });

  test('Initial state', () {
    expect(routeProvider.getRoute, null);
    expect(routeProvider.getSuggestedRoutes.isNotEmpty, true); // default suggested routes loaded in _init
    expect(routeProvider.getPolylines.isEmpty, true);
    expect(routeProvider.getMarkers.isEmpty, true);
  });

  test('Set route updates route, polylines, and markers', () {
    routeProvider.setRoute(testRoute);

    expect(routeProvider.getRoute, testRoute);
    expect(routeProvider.getPolylines.length, 1);

    final polyline = routeProvider.getPolylines.first;
    expect(polyline.points, testRoute.getCoordinatesList);

    expect(routeProvider.getMarkers.length, 2);
    expect(routeProvider.getMarkers.any((m) => m.markerId.value == "origin"), true);
    expect(routeProvider.getMarkers.any((m) => m.markerId.value == "destination"), true);
  });

  test('Add suggested route', () {
    final initialCount = routeProvider.getSuggestedRoutes.length;
    final newRoute = Route(
      "New Suggested Route",
      "id_new",
      RouteType.suggested,
      [LatLng(1.3100, 103.8100), LatLng(1.3110, 103.8110)],
    );

    routeProvider.addSuggestedRoute(newRoute);

    expect(routeProvider.getSuggestedRoutes.length, initialCount + 1);
    expect(routeProvider.getSuggestedRoutes.contains(newRoute), true);
  });

  test('Polyline points mapping', () {
    routeProvider.setRoute(testRoute);
    final polyline = routeProvider.getPolylines.first;
    expect(polyline.points.first.latitude, testRoute.getCoordinatesList.first.latitude);
    expect(polyline.points.first.longitude, testRoute.getCoordinatesList.first.longitude);
    expect(polyline.points.last.latitude, testRoute.getCoordinatesList.last.latitude);
    expect(polyline.points.last.longitude, testRoute.getCoordinatesList.last.longitude);
  });
}
