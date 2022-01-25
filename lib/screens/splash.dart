import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemarkthespot/screens/homenave.dart';

import 'package:wemarkthespot/screens/introduction_Screen.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String id = "";

  @override
  void initState() {
    getLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.fill
                )
              ) ,
            ),
            Center(child: SvgPicture.asset("assets/icons/logo-2.svg")),
            Positioned(
                bottom: 5.h,
                left: 30.w,
                child: Image.asset("assets/images/where.png"))
          ],
        ),
      ),
    );
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id").toString();
    var firstTime = true;
    firstTime = prefs.getBool("isFirstTimeLaunch")?? true;
    print("id :" + id.toString() + "^");

    Future.delayed(Duration(seconds: 3), () {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => IntdroductionScreen()));

      id.toString() == "" || id.toString() == "null" || id == ''
          ? firstTime!=null?firstTime?
      Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => IntdroductionScreen())):
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen())):
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()))
          : id.toString() == '72' ? Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()))
          :
           Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeNav(index: 0,)));
    });
  }
}
