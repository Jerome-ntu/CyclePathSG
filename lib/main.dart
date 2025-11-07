import 'package:cyclepathsg/screen/LoginUI.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';
import 'package:cyclepathsg/provider/route_provider.dart';
import 'package:cyclepathsg/provider/pcn_provider.dart';
import 'package:cyclepathsg/register.dart';
import 'package:cyclepathsg/navigation.dart';
import 'package:cyclepathsg/screen/LoginUI.dart';
import 'package:cyclepathsg/screen/app_main_screen.dart';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(DevicePreview(builder: (context)=>MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentLocationProvider()),
        ChangeNotifierProvider(create: (_) => PcnProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
      ],
      child: MaterialApp(
        title: 'CyclePathSG',
        debugShowCheckedModeBanner: false,
        // home: RegisterPage(),
        // home: AppMainScreen(),
        //home: LoginUI(),
        home: AppMainScreen(email: "jeromeke@gmail.com",), // for testing only, please use LoginUI()
      ),
    );
  }
}