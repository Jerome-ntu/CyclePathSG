import 'package:cyclepathsg/models/Route.dart';
import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:cyclepathsg/utils/colors.dart';

import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // convert coords to name

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PcnProvider extends ChangeNotifier {
  final List<Route> _pcnList = [];
  final Map<String, Route> _pcnListByArea = {};
  final Set<Polyline> _pcnPolylines = {};
  bool _isLoading = true;

  List<Route> get pcnList => _pcnList;
  Set<Polyline> get pcnPolylines => _pcnPolylines;
  bool get isLoading => _isLoading;

  PcnProvider(){
    _init();
  }

  Future<void> _init() async {
    await _getPcnData(); // wait for data to finish
    _buildPolylines();   // now build polylines safely
    _isLoading = false;
    notifyListeners();
  }

  Future<String> fetchUrlData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch data from $url: ${response.statusCode}');
    }

    return response.body;
  }

  Future<void> _getPcnData() async {
    const datasetId = 'd_8f468b25193f64be8a16fa7d8f60f553';
    final url = 'https://api-open.data.gov.sg/v1/public/api/datasets/$datasetId/poll-download';

    try {
      // Fetch the initial JSON response
      final jsonResponse = await fetchUrlData(url);

      // Parse JSON
      final Map<String, dynamic> root = json.decode(jsonResponse);

      // Check the 'code' field
      if (root['code'] != 0) {
        throw Exception(root['errMsg']);
      }

      // Get the fetch URL from the JSON response
      final String fetchUrl = root['data']['url'];

      // Fetch the data from the inner URL
      final dataResponse = await fetchUrlData(fetchUrl);

      // Decode the JSON string into a Dart object
      final Map<String, dynamic> dataJson = json.decode(dataResponse);

      // get the data
      for (var i = 0; i < dataJson["features"].length; i++){
        var data = dataJson["features"][i];

        Route route = Route(data["properties"]["Name"], "PCN$i",
            RouteType.pcn, parseCoordinates(data["geometry"]["coordinates"]));

        _pcnList.add(route);

        // Regex to extract the area
        final regex = RegExp(r'<th>CYL_PATH<\/th>\s*<td>(.*?)<\/td>', caseSensitive: false);
        final match = regex.firstMatch(data["properties"]["Description"]);

        if (match != null) {
          final area = match.group(1)!; // example: "Bedok"

          // If the key doesn't exist, create a new list
          _pcnListByArea.putIfAbsent(area, () => Route(area, area, RouteType.pcn, []));

          // Add a route to the list
          _pcnListByArea[area]!.addToCoordinatesList(parseCoordinates(data["geometry"]["coordinates"]));
          // Output: {Bedok: [Instance of 'Route']}
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // creates route line on map showing path between locations
  void _buildPolylines() async {
    for (int i = 0; i < _pcnList.length; i++) {
      _pcnPolylines.add(
        Polyline(
          polylineId: PolylineId("route_$i"),
          points: _pcnList[i].coordinatesList,
          color: Colors.blueAccent,
          width: 4,
        ),
      );
    }
  }

  List<LatLng> parseCoordinates(dynamic coordinates) {
    List<LatLng> latLngPoints = [];

    if (coordinates.isEmpty) return latLngPoints;

    if (coordinates[0][0] is double) {
      // LineString: [[lng, lat, 0.0], ...]
      latLngPoints = (coordinates as List<dynamic>).map<LatLng>((coord) {
        final c = coord as List<dynamic>;
        final double lng = c[0] as double;
        final double lat = c[1] as double;
        return LatLng(lat, lng);
      }).toList();
    } else {
      // MultiLineString: [[[lng, lat, 0.0], ...], [...]]
      for (var line in coordinates) {
        line = line as List<dynamic>;
        latLngPoints.addAll(line.map<LatLng>((coord) {
          final c = coord as List<dynamic>;
          final double lng = c[0] as double;
          final double lat = c[1] as double;
          return LatLng(lat, lng);
        }));
      }
    }

    return latLngPoints;
  }

  Map<String, Route> get pcnListByArea => _pcnListByArea;
}