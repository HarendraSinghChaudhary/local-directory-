import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:wemarkthespot/screens/introduction_Screen.dart';
import 'package:sizer/sizer.dart';



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
        child: Container(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
              child: 
              
              Image.asset('assets/images/bg.png'),
            ),

            Center(child: SvgPicture.asset("assets/icons/logo-2.svg")),
           
            Positioned(
              bottom: 5.h,
              left: 30.w,

              child: Image.asset("assets/images/where.png"))
            ],
          ),
        ),
      ),
    );
  }

  getLoginStatus() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // id = prefs.getString("id").toString();
    // print("id :" + id + "^");

    Future.delayed(Duration(seconds: 3), () {

      Navigator.push(context, MaterialPageRoute(builder: (context) => IntdroductionScreen()));


      // id.toString() == "" || id.toString() == "null" || id == null
      //     ? Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (context) => Login()))
      //     : Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (context) => HomeNav()));
    });
  }
}