import 'package:flutter/material.dart';

// Instead of using navigator every time we have to create a common nagivation helper
class NavigatorHelper {
  // push a new screen
  static void push(BuildContext context, Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // Replace current screen
  static void pushReplacement(BuildContext context, Widget screen){
    Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => screen),
    );
  }
}