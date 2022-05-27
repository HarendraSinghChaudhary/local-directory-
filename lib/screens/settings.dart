import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/aboutUs.dart';
import 'package:wemarkthespot/screens/contactUs.dart';
import 'package:wemarkthespot/screens/faqs.dart';
import 'package:wemarkthespot/screens/privacy.dart';
import 'package:wemarkthespot/screens/privacyAndPolicy.dart';
import 'package:wemarkthespot/screens/select_location.dart';
import 'package:wemarkthespot/screens/termsAndConditions.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../services/api_client.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool status = false;

  bool isloading = false;
  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

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
                  InkWell(
                    onTap: () {
                      customDialogReview();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location",
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }






  customDialogReview() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            titlePadding: EdgeInsets.all(0),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))

              ),
              child: Center(
                child: Text(
                  "Select Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,

                  ),
                ),
              ),
            ),
            content: isloading == true?Center(child: Platform.isIOS?CupertinoActivityIndicator(color: kPrimaryColor,):CircularProgressIndicator(color: kPrimaryColor,),):Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isloading = true;
                    });
                    await homeApi().then((value) {
                      setState(() {
                        isloading = false;
                      });
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Location Updated")));
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Set current location",
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

                SizedBox(height: 20,),

                InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (builder)=> LocationSelector())).then((value) {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Choose different location",
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


                SizedBox(height: 40,),

                DefaultButton(height: 40,text: "Cancel", press: (){Navigator.of(context, rootNavigator: true).pop();}, width: 120,)
              ],
            ),
          );
        });
      },
    );
  }


  fetchLocation() async {
    await Geolocator.checkPermission().then((value) async {
      print("Check Permission " + value.toString() + "__");

      if (value == LocationPermission.denied) {
        await Geolocator.requestPermission().then((value) async {
          print("Request Permission " + value.toString() + "_");
          if (value == LocationPermission.always) {
            await Geolocator.getCurrentPosition().then((value) {
              print("Lat " + value.latitude.toString());
              print("Long " + value.longitude.toString());
              lat = value.latitude.toString();
              long = value.longitude.toString();
            });
          } else if (value == LocationPermission.whileInUse) {
            await Geolocator.getCurrentPosition().then((value) {
              print("Lat " + value.latitude.toString());
              print("Long " + value.longitude.toString());
              lat = value.latitude.toString();
              long = value.longitude.toString();
            });
          }
        });
      } else if (value == LocationPermission.always) {
        await Geolocator.getCurrentPosition().then((value) {
          print("Lat " + value.latitude.toString());
          print("Long " + value.longitude.toString());
          lat = value.latitude.toString();
          long = value.longitude.toString();
        });
      } else if (value == LocationPermission.whileInUse) {
        await Geolocator.getCurrentPosition().then((value) {
          print("Lat " + value.latitude.toString());
          print("Long " + value.longitude.toString());
          lat = value.latitude.toString();
          long = value.longitude.toString();
        });
      } else if (value == LocationPermission.deniedForever) {
        await Geolocator.requestPermission().then((value) async {
          print("Request Permission " + value.toString() + "_");
          if (value == LocationPermission.always) {
            await Geolocator.getCurrentPosition().then((value) {
              print("Lat " + value.latitude.toString());
              print("Long " + value.longitude.toString());
              lat = value.latitude.toString();
              long = value.longitude.toString();
            });
          } else if (value == LocationPermission.whileInUse) {
            await Geolocator.getCurrentPosition().then((value) {
              print("Lat " + value.latitude.toString());
              print("Long " + value.longitude.toString());
              lat = value.latitude.toString();
              long = value.longitude.toString();
            });
          }
        });
      }
    });
    /*  await Geolocator.getCurrentPosition().then((value) => {
      lat = value.latitude,
      long = value.longitude,
      print("Lat "+lat.toString()+""),
      print("Long "+long.toString()+"")
    });*/
  }

  Future<dynamic> homeApi() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id lat: " + lat.toString());
    print("id long: " + long.toString());
    print("fcm token: " + fcm_token.toString());

    if(mounted) {
      setState(() {
        isloading = true;
      });
    }

    var request = http.post(
        Uri.parse(
          RestDatasource.HOMEAPI_URL,
        ),
        body: {
          "id": id.toString(),
          "lat":  lat.toString(),//"26.8546714985159",
          "long":long.toString(),//"75.76675952576491"
          "fcm_token":fcm_token.toString(),//"75.76675952576491"
        });

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {

        setState(() {
          isloading = false;
        });


      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }


}
