import 'package:flutter/material.dart' hide Route;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';
import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:cyclepathsg/utils/colors.dart';

void main() {
  group('PcnProvider Tests', () {
    late PcnProvider pcnProvider;

    setUp(() {
      pcnProvider = PcnProvider();
    });

    test('parseCoordinates parses LineString correctly', () {
      final coordinates = [
        [103.860702151563999, 1.27411088541224, 0.0],
        [103.860869464401006, 1.27437138501779, 0.0]
      ];

      final latLngs = pcnProvider.parseCoordinates(coordinates);

      expect(latLngs.length, 2);
      expect(latLngs[0], LatLng(1.27411088541224, 103.860702151563999));
      expect(latLngs[1], LatLng(1.27437138501779, 103.860869464401006));
    });

    test('parseCoordinates parses MultiLineString correctly', () {
      final coordinates = [
        [
          [103.860702151563999, 1.27411088541224, 0.0],
          [103.860869464401006, 1.27437138501779, 0.0]
        ],
        [
          [103.861724272352006, 1.27569887026108, 0.0],
          [103.862029997294997, 1.27559366117944, 0.0]
        ]
      ];

      final latLngs = pcnProvider.parseCoordinates(coordinates);

      expect(latLngs.length, 4);
      expect(latLngs[2], LatLng(1.27569887026108, 103.861724272352006));
      expect(latLngs[3], LatLng(1.27559366117944, 103.862029997294997));
    });

    test('isClose returns true for close points', () {
      final a = LatLng(1.0, 1.0);
      final b = LatLng(1.0 + 1e-6, 1.0 + 1e-6);

      expect(pcnProvider.isClose(a, b), true);
    });

    test('mergeFragments merges connected fragments', () {
      final fragments = [
        [
          LatLng(1.0, 1.0),
          LatLng(1.0, 2.0),
        ],
        [
          LatLng(1.0, 2.0),
          LatLng(1.0, 3.0),
        ],
      ];

      final merged = pcnProvider.mergeFragments(fragments);

      expect(merged.length, 3);
      expect(merged[0], LatLng(1.0, 1.0));
      expect(merged[2], LatLng(1.0, 3.0));
    });

    test('buildPolylines creates Polyline set', () async {
      // Manually add a route for testing
      final testRoute = Route(
        'TestRoute',
        'test',
        RouteType.pcn,
        [LatLng(1.0, 1.0), LatLng(1.0, 2.0)],
      );
      pcnProvider.pcnList.add(testRoute);
      pcnProvider.buildPolylines();

      expect(pcnProvider.pcnPolylines.length, 1);
      final polyline = pcnProvider.pcnPolylines.first;
      expect(polyline.points, testRoute.coordinatesList);
      expect(polyline.color, Colors.blueAccent);
    });
  });
}