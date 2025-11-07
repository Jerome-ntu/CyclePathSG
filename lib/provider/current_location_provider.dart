import 'dart:async';

import 'package:cyclepathsg/utils/font_awesome_helper.dart';

import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // convert coords to name
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentLocationProvider extends ChangeNotifier {
  // default location: NTU
  LatLng _currentLocation = LatLng(1.348310, 103.683135);
  bool _isLoading = true;
  String _errorMessage = '';
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  // pubic getters to access private variables
  LatLng get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  BitmapDescriptor? originIcon;
  BitmapDescriptor? currentLocationIcon;

  CurrentLocationProvider() {
    _getCurrentLocation();
  }

  // main function to get device's current location
  Future<void> _getCurrentLocation() async {
    try {
      // check if location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = "Location permission denied. Using default location";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      // check if location serice are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = "Location service is disabled";
        _isLoading = false;
        notifyListeners();
        return;
      }
      // get currrent position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // success -- update location and clear loading screen
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      // handle any errors during location retrival
      _errorMessage =
          "Error getting location ${e.toString()}. Using default location.";
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

  // public method to manually refresh location (can be called by UI)
  void refreshLocation() {
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
    _getCurrentLocation();
  }

  Future<void> continuouslyCheckLocationChange() async{
    // get initial location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentLocation = LatLng(position.latitude, position.longitude);

    // Start listening for continuous updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // only update if moved 5 meters
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
          _currentPosition = position;
          notifyListeners(); // update UI whenever position changes
        });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void loadOriginIcon() async {
    originIcon = await getFontAwesomeBitmap(FontAwesomeIcons.circle, size: 45, color: Colors.blueAccent);
  }

  void loadCurrentLocationIcon() async {
    currentLocationIcon = await getFontAwesomeBitmap(FontAwesomeIcons.solidCircle, size: 45, color: Colors.blueAccent);
  }
}

Future<String> getAddressFromCoordinates(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return "${place.street ?? ''}, "
              "${place.subLocality ?? ''}, "
              "${place.locality ?? ''}, "
              "${place.postalCode ?? ''}, "
              "${place.country ?? ''}"
          .replaceAll(RegExp(r', ,'), ',')
          .replaceAll(RegExp(r', $'), '');
    } else {
      return "Unknown location";
    }
  } catch (e) {
    print("Error: $e");
    return "Error getting location";
  }
}
