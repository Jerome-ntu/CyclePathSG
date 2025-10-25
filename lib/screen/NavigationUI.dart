import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NavigationUI extends StatefulWidget {
  const NavigationUI({super.key});

  @override
  State<NavigationUI> createState() => _NavigationUIState();
}

class _NavigationUIState extends State<NavigationUI> {
  GoogleMapController ? mapController;
  bool isOnline = true;

  // callback when google maps is ready
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // create markers for current location on map
  Set<Marker> _buildMarkers(LatLng currentLocation) {
    return {
      Marker(markerId: MarkerId("current_location"),
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
                  child: Column(children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                    Text("Getting your current location"),
                  ],)
              );
            }
            // show the error message after permission denied
            if (locationProvider.errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPersistentFrameCallback((_) {
                showAppSnackBar(
                  context: context,
                  type: SnackbarType.error,
                  description: locationProvider.errorMessage,
                );
              });
            }
            Size size = MediaQuery
                .of(context)
                .size;
            return Stack(
              children: [
                // display the google map
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _buildMarkers(locationProvider.currentLocation),
                  initialCameraPosition: CameraPosition(
                      target: locationProvider.currentLocation,
                      zoom: 15),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                ),
                if(locationProvider.errorMessage.isEmpty)
                // show order car at bottom TODO
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(15), child: Text("Hello"),
                    ),
                  ),

                // show static online button at the top
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: size.height * 0.12,
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Center(
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 200,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.red, width: 2),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Row(children: [
                                        // online button
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius
                                                  .circular(30),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("Online",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500)
                                            ),
                                          ),
                                        ),
                                        Expanded(child: SizedBox())
                                      ],
                                      ),
                                    ),
                                  )
                              )
                          )
                      )
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}
