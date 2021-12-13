import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:wemarkthespot/screens/account.dart';

import 'package:wemarkthespot/screens/home_screen.dart';
import 'package:wemarkthespot/screens/hotspot.dart';
import 'package:wemarkthespot/screens/inTheKnow.dart';

import 'package:wemarkthespot/screens/mapScreen.dart';

class HomeNav extends StatefulWidget {
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _index = 0;
  List widgets = <Widget>[
    Home(),
    // Scaffold(), Scaffold(), Scaffold(),
    MapScreen(), Hotspot(), TextScreen(),
    Account()
  ];

  //LanguageChange languageChange = new LanguageChange();
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widgets.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _index,
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: true,
          selectedIconTheme: IconThemeData(color: Color(0xFF1DC2C2)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF7A7A7A)),
          selectedLabelStyle: TextStyle(fontSize: 12, color: Color(0xFF1DC2C2)),
          unselectedLabelStyle:
              TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
          selectedItemColor: Color(0xFF1DC2C2),
          unselectedItemColor: Color(0xFF7A7A7A),
          onTap: (page) {
            setState(() {
              _index = page;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                width: 8.w,
                color: _index == 0 ? Color(0xFF1DC2C2) : Color(0xFF7A7A7A),
              ),
              //dashboard
              label: "",
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/location1.svg',
                  width: 6.w,
                  color: _index == 1 ? Color(0xFF1DC2C2) : Color(0xFF7A7A7A),
                ),

                //Enquiry
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/fire.svg',
                  width: 5.w,
                  color: _index == 2 ? Color(0xFF1DC2C2) : Color(0xFF7A7A7A),
                ),

                //Property
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/tab_feed1.svg',
                  width: 6.w,
                  color: _index == 3 ? Color(0xFF1DC2C2) : Color(0xFF7A7A7A),
                ),

                //Menu
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/tab_profile1.svg',
                  width: 6.w,
                  color: _index == 4 ? Color(0xFF1DC2C2) : Color(0xFF7A7A7A),
                ),

                //Menu
                label: "")
          ]),
    );
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    var email = pref.getString("email").toString();
    final BottomNavigationBar? navigationBar =
        globalKey.currentWidget as BottomNavigationBar?;
    navigationBar!.onTap!(1);
  }
}
