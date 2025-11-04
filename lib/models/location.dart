import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  String locationName;
  LatLng coordinates;

  Location(this.locationName, this.coordinates);

  // Getters
  String get getLocationName => locationName;
  LatLng get getCoordinates => coordinates;

  // Setters
  set userEmail(String name) => locationName = name;
  set setCoordinates(LatLng coordinates) => coordinates = coordinates;
}