// import 'package:cyclepathsg/screen/cyclist_home_screen.dart';
import 'package:cyclepathsg/screen/HomeUI.dart';
import 'package:cyclepathsg/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppMainScreen extends StatefulWidget {

  String email;

  AppMainScreen({super.key, required this.email});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {


  final List<Widget> pages = [
    HomeUI(),
    Center(child: Text("Profile")),
    Center(child: Text("Rewards")),
    Center(child: Text("DELETE_ME")),
  ];
  // initially display the index of the pages list
  int _currentIndex = 0;
  final List<IconData> _icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.boxOpen,
    FontAwesomeIcons.truckFast,
  ];
  final List<String> _labels = [
    "Home", "Profile", "Rewards"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
              BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -1),
            )
          ]
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index){
              final bool isSelected = _currentIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                child: Column(mainAxisSize: MainAxisSize.min, children:[
                  Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: isSelected ? BoxDecoration(
                    color: buttonSecondaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ) : null,
                    child: Icon(
                      _icons[index],
                      size: 18, color: isSelected ? buttonMainColor: Colors.black,
                    ),
                  ),
                  Text(_labels[index], style: TextStyle(color: isSelected ? buttonMainColor : Colors.black),
                  ),
                ]),
              );
          }),)
      ),
    );
  }
}