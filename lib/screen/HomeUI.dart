import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/utils/snackbar_helper.dart';
import 'package:cyclepathsg/widgets/location_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  GoogleMapController? mapController;
  bool isOnline = true;

  // callback when google maps is ready
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // create markers for current location on map
  Set<Marker> _buildMarkers(LatLng currentLocation) {
    return {
      Marker(
        markerId: MarkerId("current_location"),
        position: currentLocation,
        infoWindow: InfoWindow(
          title: "Current Location",
          snippet: "You are here!",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(target: LatLng(27.7, 85.3)),
      // ),
      body: Consumer<CurrentLocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isLoading) {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text("Getting your current location"),
                ],
              ),
            );
          }
          // show the error message after permission denied
          if (locationProvider.errorMessage.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAppSnackBar(
                context: context,
                type: SnackbarType.error,
                description: locationProvider.errorMessage,
              );
            });
          }
          Size size = MediaQuery.of(context).size;
          return Stack(
            children: [
              // display the google map
              GoogleMap(
                onMapCreated: _onMapCreated,
                markers: _buildMarkers(locationProvider.currentLocation),
                initialCameraPosition: CameraPosition(
                  target: locationProvider.currentLocation,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
              ),
              if (locationProvider.errorMessage.isEmpty)
                // show order car at bottom TODO
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    child: LocationCard(provider: locationProvider,),
                  ),
                ),

              // show static online button at the top
            ],
          );
        },
      ),
    );
  }
}
