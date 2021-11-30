import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/aboutUs.dart';
import 'package:wemarkthespot/screens/contactUs.dart';
import 'package:wemarkthespot/screens/faqs.dart';
import 'package:wemarkthespot/screens/privacy.dart';
import 'package:wemarkthespot/screens/privacyAndPolicy.dart';
import 'package:wemarkthespot/screens/termsAndConditions.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Settings",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About Us",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => CheckIn()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifications",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        Center(
                          child: Container(
                            child: FlutterSwitch(
                              activeColor: kPrimaryColor,
                              width: 12.w,
                              height: 3.h,
                              valueFontSize: 0.0,
                              toggleSize: 20.0,
                              toggleColor: Colors.black,
                              value: status,
                              borderRadius: 30.0,
                              //padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  status = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contact Us",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQS()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "FAQs",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),


                     SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyAndPolicy()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Terms & Conditions",
                          style: TextStyle(
                              color: kCyanColor,
                              fontSize: 13.sp,
                              fontFamily: 'Roboto'),
                        ),
                        SvgPicture.asset(
                          "assets/icons/-right.svg",
                          width: 2.5.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
