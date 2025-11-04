import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/utils/image_strings.dart';
import 'package:cyclepathsg/utils/colors.dart';

import 'package:cyclepathsg/models/Route.dart';

import 'package:cyclepathsg/screen/NavigationUI.dart';

import 'package:cyclepathsg/widgets/dash_vertical_line.dart';
import 'package:cyclepathsg/widgets/custom_button.dart';

import 'package:cyclepathsg/route.dart';
import 'package:flutter/material.dart' hide Route;

class RouteDetailsCard extends StatelessWidget {
  final Route route;

  const RouteDetailsCard({super.key, required this.route});

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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Route Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 15),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // route details,
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // items info
                  Material(
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.black26,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(TImages.tenderCoconut),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(text: route.routeName),
                              // TextSpan(
                              //   text: " * 4",
                              //   style: TextStyle(color: Colors.black38),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // start
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
                          SizedBox(
                            height: 20,
                            child: DashVerticalLine(dashHeight: 6, dashGap: 3,),
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      pickupAndDeliveryInfo(
                        "",
                        getAddressFromCoordinates(
                          route.coordinatesList[0].latitude,
                          route.coordinatesList[0].longitude,
                        ),
                        ""
                      ),
                    ],
                  ),

                  // destination
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: buttonMainColor,
                        size: 22,
                      ),
                      SizedBox(width: 5),
                      pickupAndDeliveryInfo(
                        "",
                        getAddressFromCoordinates(
                          route.coordinatesList[route.coordinatesList.length-1].latitude,
                          route.coordinatesList[route.coordinatesList.length-1].longitude,
                        ),
                        "",
                      ),
                    ],
                  ),

                  SizedBox(height: 15),
                  // action buttons ,
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      title: "Start Navigation",
                      color: Colors.green,
                      onPressed: () {
                        // Provider.of<RouteProvider>(context, listen: false).setRoute(route);
                        NavigationHelper.push(context, NavigationUI());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Expanded pickupAndDeliveryInfo(title, Future<String> futureAddress, subtitle) {
    return Expanded(
      child: FutureBuilder<String>(
        future: futureAddress,
        builder: (context, snapshot) {
          final displayAddress = snapshot.connectionState == ConnectionState.done
              ? (snapshot.data ?? "Unknown address")
              : "Loading address...";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(
                      displayAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                ],
              ),
              Text(subtitle, style: TextStyle(color: Colors.black38)),
            ],
          );
        }
      ),
    );
  }
}
