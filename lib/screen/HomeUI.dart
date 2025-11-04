import 'package:cyclepathsg/models/enums/route_type.dart';
import 'package:cyclepathsg/provider/route_provider.dart';
import 'package:cyclepathsg/utils/snackbar_helper.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';

import 'package:cyclepathsg/models/Route.dart';

import 'package:cyclepathsg/widgets/location_card.dart';
import 'package:cyclepathsg/widgets/suggest_route_card.dart';

import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  GoogleMapController? mapController;

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

  // retrieve all routes from db
  final List<LatLng> nusRoutePoints = [
    LatLng(1.2966, 103.7764), // NUS Kent Ridge MRT
    LatLng(1.2956, 103.7755), // University Town
    LatLng(1.2948, 103.7742), // Central Library
    LatLng(1.2937, 103.7730), // Science Faculty area
    LatLng(1.2925, 103.7740), // School of Computing
    LatLng(1.2915, 103.7750), // University Hall
    LatLng(1.2905, 103.7760), // Faculty of Engineering
    LatLng(1.2898, 103.7770), // NUS Sports Centre
  ];
  late Route route = Route(
      "i am name", "i am route id", RouteType.suggested, nusRoutePoints);
  late List<Route> rountes = [route];

  @override
  Widget build(BuildContext context) {
    final pcnProvider = Provider.of<PcnProvider>(context); // triggers creation

    return Scaffold(
      backgroundColor: Colors.grey[250],
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(target: LatLng(27.7, 85.3)),
      // ),
      body: Consumer<CurrentLocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isLoading || pcnProvider.isLoading) {
            return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50), // space above
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 15),
                      Text("Getting your current location"),
                    ],
                  ),
                ),
              );
            }
                // show the error message after permission denied
                if (locationProvider.errorMessage.isNotEmpty)
            {
              WidgetsBinding.instance.addPostFrameCallback((_) {
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
            final routeProvider = Provider.of<RouteProvider>(context);
            final suggestedRoutes = routeProvider.suggestedRoutes;
            return Stack(
              children: [
                // display the google map
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _buildMarkers(locationProvider.currentLocation),
                  polylines: pcnProvider.pcnPolylines,
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.currentLocation,
                    zoom: 13,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                ),

                if (locationProvider.errorMessage.isEmpty)
                // show current location on top
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

                // suggest routes below

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 185, // height of the card
                      child: PageView.builder(
                        itemCount: suggestedRoutes.length,
                        controller: PageController(viewportFraction: 0.9),
                        // slightly smaller than screen
                        itemBuilder: (context, index) {
                          final route = suggestedRoutes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SuggestRouteCard(route: route),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                /*
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    child: SuggestRouteCard(route: route),
                  ),
                )
                */
              ],
            );
          },
      ),
    );
  }
}
