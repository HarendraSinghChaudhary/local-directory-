// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';
import 'package:wemarkthespot/screens/explore.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapLocationTestingState createState() =>
      _GoogleMapLocationTestingState();
}

class _GoogleMapLocationTestingState extends State<GoogleMapScreen> {
  LatLng sourceLocation = LatLng(26.862471, 75.762413);
  bool isloading = false;

  Completer <GoogleMapController> _controllerGoogleMap = Completer();


  late GoogleMapController newGoogleMapController;
 late Position currentPosition;
  // late Position position;

  @override
  void initState() {
    locatePosition();
    super.initState();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


        currentPosition = position;

        LatLng latLngPosition = LatLng(position.latitude, position.longitude);
        print("lat: "+position.latitude.toString());
        print("long "+position.longitude.toString());

        CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 15);

        newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


  
  }



  static final CameraPosition _currentPosition  = CameraPosition(
    target:LatLng(26.862471, 75.762413),
    zoom: 16
  );

  @override
  Widget build(BuildContext context) {
    // CameraPosition initialCameraPosition = CameraPosition(
    //     tilt: 80,
    //     bearing: 30,
    //     zoom: 14.0,
    //     target: LatLng(position.latitude, position.longitude));
    return Scaffold(
        backgroundColor: Colors.white,

         appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Explore()));
                },
                child: SvgPicture.asset(
                  "assets/icons/explore.svg",
                  width: 26,
                  color: Colors.white,
                ),
              ),

              SizedBox(
                width: 6.h,
              ),

              //Image.asset("assets/images/logo_name.png"),

              Text(
                "WE MARK THE SPOT",
                style: TextStyle(
                    fontSize: 17.sp, color: Colors.white, fontFamily: "Roboto"),
              )
            ],
          ),

          actions: [

             Padding(
               padding: EdgeInsets.only(right: 3.w),
               child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FliterScreen()));
                  },
                  child: SvgPicture.asset(
                    "assets/icons/filter-list.svg",
                    width: 26,
                    color: Colors.white,
                  ),
                ),
             ),

          ],
        ),
        body: SafeArea(
            child: GoogleMap(
          initialCameraPosition: _currentPosition,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {

            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
            setState(() {
              
            });
         
          },
        ))
        );
  }
}
