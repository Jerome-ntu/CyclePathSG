import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // convert coords to name

class CurrentLocationProvider extends ChangeNotifier {
  // default location: NTU
  LatLng _currentLocation = LatLng(1.348310, 103.683135);
  bool _isLoading = true;
  String _errorMessage = '';

  // pubic getters to access private variables
  LatLng get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

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
