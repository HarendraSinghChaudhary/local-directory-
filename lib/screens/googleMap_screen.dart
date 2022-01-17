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
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:wemarkthespot/screens/detailBusinessdynamic.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/screens/hotspot.dart';
import 'package:wemarkthespot/services/api_client.dart';

class GoogleMapScreen extends StatefulWidget {
  var list;

  GoogleMapScreen({Key? key, this.list}):super(key:key);
  @override
  _GoogleMapLocationTestingState createState() =>
      _GoogleMapLocationTestingState();
}

class _GoogleMapLocationTestingState extends State<GoogleMapScreen> {
  bool viewVisible = false;
  var check = "";

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
 
 
  var avgratting = "";
  var countUserreview = "";
  var firecount = "";
  var okcount = "";
  var notcool_count = "";
  double? lat;
  double? long;

  List<NearBy> nearByRestaurantList = [];

  TextEditingController mesageTextController = new TextEditingController();
  String searchText = "";
  LatLng sourceLocation = LatLng(26.862471, 75.762413);
  bool isloading = false;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  List<Marker> markers = [];

  late BitmapDescriptor mapMarker;
  // late Position position;
  Timer? debounce;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/fire.png");
  }

  initilize(List<NearBy> businessList) {
    print("into the initalizer method");

    for (final business in businessList) {
      if(business.lat!=null && business.long!=null) {
        if (business.lat.toString() != "null" &&
            business.long.toString() != "null") {
          Marker firstMarker = Marker(
            onTap: () {
              setState(() {
                viewVisible = true;
                business_name = business.business_name.toString();
                avgratting = business.avgratting.toString();
                firecount = business.firecount.toString();
                notcool_count = business.notcool_count.toString();
                user_count = business.user_count.toString();
                review_count = business.review_count.toString();
                business_images = business.business_images.toString();
                id = business.id.toString();

                okcount = business.okcount.toString();
                print("okok: "+okcount.toString());

              });
            },
            markerId: MarkerId(business.id),
            position:
            LatLng(double.parse(business.lat), double.parse(business.long)),
            infoWindow: InfoWindow(
              title: business_name = business.business_name.toString(),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          );
          markers.add(firstMarker);
          print("business_name: "+business_name.toString());
        }
      }
    }

 

    setState(() {
       print("business_name2: "+ business_name.toString(),);
    });
  }

  @override
  void initState() {


    super.initState();
    setCustomMarker();

    this.mesageTextController.addListener(_onSearchChanged);
    if(widget.list!=null){
      locatePosition();
      filterData(widget.list);
    }else{
      locatePosition();
      nearBy();
      initilize(nearByRestaurantList);
    }
  }
@override
  void dispose() {
    this.mesageTextController.removeListener(_onSearchChanged);
    this.mesageTextController.dispose();
    debounce?.cancel();

    super.dispose();
  }
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    print("lat: " + position.latitude.toString());
    print("long " + position.longitude.toString());

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _currentPosition =
      CameraPosition(target: LatLng(26.862471, 75.762413), zoom: 16);

     

  @override
  Widget build(BuildContext context) {

      print("business_name1: "+business_name.toString());
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
                  debounce?.cancel();
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
            child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _currentPosition,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                locatePosition();
                setState(() {});
              },
              markers: markers.map((e) => e).toSet(),
            ),
            Padding(
              padding: EdgeInsets.only(right: 25.0, top: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                height: 6.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.w),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2, 3),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
                ),
                child: TextFormField(
                  controller: mesageTextController,
                  onChanged: (value) {
                    if(value.length==0){
                      nearBy();
                    }
                  },
                  validator: (val) {},
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixIconConstraints: BoxConstraints(minWidth: 60),
                    contentPadding: EdgeInsets.only(top: 0.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                    suffixIcon: InkWell(
                      onTap: () {
                        mesageTextController.clear();
                        // getHostSpotList.clear();

                        // getHotspotApi();
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        width: 15,
                        color: kPrimaryColor,
                      ),

                      // child: SearchPrefixIcon(svgIcon: "assets/icons/cross.svg")
                    ),
                    prefixIcon: SvgPicture.asset(
                      "assets/icons/search-.svg",
                      width: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: viewVisible,
              child: Padding(
                padding: EdgeInsets.only(top: 57.2.h, left: 13.5.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBussinessDynamic(id: id)));
                  },
                  child: Container(
                    height: 18.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.w),
                      color: kBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/file.svg",
                                        color: kPrimaryColor, width: 5.w),
                                    SizedBox(
                                      height: 0.6.h,
                                    ),
                                    Text(
                                      "Fire(" +firecount.toString()+")",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                
                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/bakance.svg",
                                        color: kokokColor, width: 10.w),
                                    Text(
                                      "Ok Ok("+okcount.toString()+")",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                
                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/snow.svg",
                                        color: kNotCoolColor, width: 8.w),
                                    Text(
                                      "Not Cool("+notcool_count.toString()+")",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                
                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset("assets/icons/star.svg",
                                        color: kPrimaryColor, width: 6.w),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      //"3.5",
                                      avgratting.toString(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white,
                
                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, left: 3.5.w),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16.w,
                                  width: 18.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.w),
                                      color: Colors.red,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              //"assets/images/restaurant.jpeg"
                                              business_images
                                              ),
                                          fit: BoxFit.fill)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //"Bar Name",
                                        business_name.toString(),
                                        // widget.nearBy.business_name.toString() != "null"
                                        //     ? widget.nearBy.business_name.toString()
                                        //     : "Bar Name",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: kCyanColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Segoepr"),
                                      ),
                
                                      SizedBox(height: 0.5.h,),
                
                
                                      Row(
                                        children: [
                                          Text(
                                            // communityReviewList != null &&
                                            //         communityReviewList.length > 0
                                            //     ? communityReviewList.length.toString() +
                                            //         " Reviews "
                                            review_count.toString()+" Reviews",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kPrimaryColor,
                                                // fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto"
                                                //fontFamily: "Segoepr"
                                                ),
                                          ),
                                          Text(
                                            " | ",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kPrimaryColor,
                                                // fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto"
                                                //fontFamily: "Segoepr"
                                                ),
                                          ),
                                          Text(
                                            // widget.nearBy.user_count.toString() +
                                            user_count.toString()+" People",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kPrimaryColor,
                                                // fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto"
                                                //fontFamily: "Segoepr"
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )));
  }

  _onSearchChanged(){
    if(debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), (){
      if(mesageTextController.text.toString().length==0){
        nearBy();
      }else if(searchText != mesageTextController.text){

        searchData(mesageTextController.text);

      }
    });
  }

  Future<dynamic> searchData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("key Print: " + key.toString());

    var request = http.post(
        Uri.parse(RestDatasource.SEARCHMAP_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "business_name": key.toString(),
          "user_id": id.toString(),

        });

    var jsonArray;
    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      jsonArray = jsonRes['data'];
    });

    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        nearByRestaurantList.clear();
        markers.clear();
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
/*          id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/


          print("object");

          print("lattttttt: " + lat.toString());

          setState(() {

          });
        }


        setState(() {
          newGoogleMapController.setMapStyle("[]");
          initilize(nearByRestaurantList);
          print("lengthis "+nearByRestaurantList.length.toString()+"^");
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonRes["message"])));
        });
      }
    }

    searchText = mesageTextController.text;

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
        nearByRestaurantList.clear();
        markers.clear();
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
          modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
          modelAgentSearch.firecount = jsonArray[i]["firecount"].toString();
          modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"].toString();
          modelAgentSearch.okcount = jsonArray[i]["okcount"].toString();

          print("lat: " + modelAgentSearch.lat.toString());

          nearByRestaurantList.add(modelAgentSearch);
   /*       id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/


          print("lattttttt: " + lat.toString());

        }

        setState(() {
          initilize(nearByRestaurantList);
          isloading = false;
        });
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



  Future<dynamic> filterData(List<String> key) async {
    print("Filter");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + widget.list.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.FILTER,
        ),
        body: {
          "key": widget.list.toString(),
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
        nearByRestaurantList.clear();
        markers.clear();
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
/*          id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/


          print("lattttttt: " + lat.toString());

        }
        print("FilterListLength "+nearByRestaurantList.length.toString()+"^^");
        setState(() {
          initilize(nearByRestaurantList);
          isloading = false;
        });
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
