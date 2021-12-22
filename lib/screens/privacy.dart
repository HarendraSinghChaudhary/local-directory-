import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';


class Privacy extends StatefulWidget {
  const Privacy({ Key? key }) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {


  bool status = true;
// // Geolocator _gps = GeoLocator();
//   getGPS(){
//     bool status = _gps. 
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

         appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Privacy",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: InkWell(
                      onTap: () {
                        //  Navigator.push(context, MaterialPageRoute(builder: (context) => CheckIn()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Turn off Location",
                            style: TextStyle(
                                color: kCyanColor,
                                fontSize: 14.sp,
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
                  ),
        ],
      ),
      
    );
  }
}