// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/services/api_client.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapLocationTestingState createState() =>
      _GoogleMapLocationTestingState();
}

class _GoogleMapLocationTestingState extends State<GoogleMapScreen> {

   bool _hasBeenPressed = true;
  var id = "";
  var fav = "";
  var business_name = "";
  var business_images = "";
  var distance = "";
  var ratting = "";
  var description = "";
  var business_category = "";
  var user_count = "";
  var review_count = "";
  var location = "";
  var category_name = "";
  var latlong_position = "";
  double? lat;
  double? long;

  List<NearBy> nearByRestaurantList = [];

 


  LatLng sourceLocation = LatLng(26.862471, 75.762413);
  bool isloading = false;

  Completer <GoogleMapController> _controllerGoogleMap = Completer();


  late GoogleMapController newGoogleMapController;
 late Position currentPosition;
 List<Marker> markers = [];
  // late Position position;

  initilize () {

    //  Marker zeroMarker = Marker(
    //   markerId: MarkerId(id.toString()),
    //   position: LatLng(lat!, long!),
    //   infoWindow: InfoWindow(title: business_name.toString()),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // );
    Marker firstMarker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(26.914326950753455, 75.73800626994411),
      infoWindow: InfoWindow(title: "Statue Circle"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

     Marker secondMarker = Marker(
      markerId: MarkerId("2"),
      position: LatLng(26.941456714172595, 75.7711352263281),
      infoWindow: InfoWindow(title: "Triton Mall"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

     Marker thirdMarker = Marker(
      markerId: MarkerId("3"),
      position: LatLng(26.85479593167254, 75.76673806809387),
      infoWindow: InfoWindow(title: "Mansarovar Plaza"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );


     Marker fourthMarker = Marker(
      markerId: MarkerId("4"),
      position: LatLng(26.937360507037585, 75.81551516809603),
      infoWindow: InfoWindow(title: "Nahargarh Fort"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

     Marker fifthMarker = Marker(
      markerId: MarkerId("5"),
      position: LatLng(26.876925402578138, 75.7530057257655),
      infoWindow: InfoWindow(title: "Appic Software"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(firstMarker);
    markers.add(secondMarker);
    markers.add(thirdMarker);
    markers.add(fourthMarker);
    markers.add(fifthMarker);

   // markers.add(zeroMarker);

    setState(() {
      
    });

  }

  @override
  void initState() {
    locatePosition();
    initilize();
     nearBy();
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
          markers: markers.map((e) => e).toSet(),
        ))
        );
  }


    Future<dynamic> nearBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.NEARBYRESTAURANT_URL,
        ),
        body: {
          "id": id.toString(),
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.business_name =
              jsonArray[i]["business_name"].toString();
          modelAgentSearch.business_images =
              jsonArray[i]["business_images"].toString();
          modelAgentSearch.distance = jsonArray[i]["distance"].toString();
          modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
          modelAgentSearch.description = jsonArray[i]["description"].toString();
          modelAgentSearch.business_category =
              jsonArray[i]["business_category "].toString();
          modelAgentSearch.user_count = jsonArray[i]["user_count"].toString();
          modelAgentSearch.review_count =
              jsonArray[i]["review_count"].toString();
          modelAgentSearch.location = jsonArray[i]["location"].toString();
          modelAgentSearch.category_name =
              jsonArray[i]["category_name"].toString();
          modelAgentSearch.fav = jsonArray[i]["fav"].toString();
          modelAgentSearch.lat = jsonArray[i]["lat"].toString();
          modelAgentSearch.long = jsonArray[i]["long"].toString();

          print("lat: " + modelAgentSearch.lat.toString());
         

          nearByRestaurantList.add(modelAgentSearch);
          id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
           print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString()+","+" " + jsonArray[i]["long"].toString();
          print("lay: "+latlong_position.toString());
          lat = jsonArray[i]["lat"];
          long = jsonArray[i]["long"];

         // markers.add(modelAgentSearch);

          setState(() {});
        }

        setState(() {
          isloading = false;
        });
        //Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));
        // sliderBannerApi();
        //Navigator.pop(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Banners()));

      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
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


