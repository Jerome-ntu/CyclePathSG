import 'package:cyclepathsg/utils/colors.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';

import 'package:flutter/material.dart' hide Route;

class LocationCard extends StatelessWidget {
  final CurrentLocationProvider provider;

  const LocationCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // new order availabe header,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Current Location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                // Text(
                //   "₹320",
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     color: buttonMainColor,
                //   ),
                // ),
                // Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Icon(Icons.close),
                // ),
              ],
            ),
          ),
          // order details,
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // items info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.radio_button_checked,
                          color: Colors.black54,
                          size: 20,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    SizedBox(width: 4),
                    routeInfo(
                      null,
                      getAddressFromCoordinates(
                        provider.currentLocation.latitude,
                        provider.currentLocation.longitude,
                      ),
                      null,
                    ),
                  ],
                ),
                // action buttons ,
                // SizedBox(
                //   width: double.maxFinite,
                //   child: CustomButton(
                //     title: "View order details",
                //     onPressed: () {
                //       // move delivery boy to pickup location and navigate to map
                //       Route route = new Route("3", "3", [LatLng(0.3, 3.0)]);
                //       context.read<RouteProvider>().setRoute(route);
                //       NavigationHelper.pushReplacement(
                //         context,
                //         NavigationUI(),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded routeInfo(
    String? title,
    Future<String> futureAddress,
    String? subtitle,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (title != null)
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              Expanded(
                flex: 9,
                child: FutureBuilder<String>(
                  future: futureAddress,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Fetching address...",
                        overflow: TextOverflow.ellipsis,
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        "Error getting address",
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        snapshot.data ?? "Unknown address",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Text(subtitle, style: const TextStyle(color: Colors.black38)),
        ],
      ),
    );
  }
}
