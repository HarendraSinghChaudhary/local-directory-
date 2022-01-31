// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
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
import 'dart:ui' as ui;

class GoogleMapScreen extends StatefulWidget {
  var list;
  var route;

  GoogleMapScreen({Key? key, this.list, this.route}):super(key:key);
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
 bool isCheckinClicked = false;
 
  var avgratting = "";
  var countUserreview = "";
  var firecount = 0;
  var okcount = 0;
  var notcool_count = 0;
  double? lat;
  double? long;

  List<NearBy> nearByRestaurantList = [];

  BitmapDescriptor? customIcon;
  BitmapDescriptor? fireIcon;
  BitmapDescriptor? okIcon;
  BitmapDescriptor? notcoolIcon;
  TextEditingController mesageTextController = new TextEditingController();
  String searchText = "";
  LatLng sourceLocation = LatLng(26.862471, 75.762413);
  bool isloading = false;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapController;
  late Position currentPosition;
  List<Marker> markers = [];

  late BitmapDescriptor mapMarker;
  // late Position position;
  Timer? debounce;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/fire.png");

    final Uint8List fireI = await getBytesFromAsset('assets/images/fire.png', 50);
    final Uint8List notcoolI = await getBytesFromAsset('assets/snow/snow.png', 50);
    final Uint8List okI = await getBytesFromAsset('assets/beckance/bakance.png', 50);
    fireIcon = BitmapDescriptor.fromBytes(fireI);
    notcoolIcon = BitmapDescriptor.fromBytes(notcoolI);
    okIcon = BitmapDescriptor.fromBytes(okI);
    /*BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1, 1)),
        'assets/images/fire.png')
        .then((d) {
      customIcon = d;
    });*/
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  initilize(List<NearBy> businessList) {
    print("into the initalizer method");
    print("businessLength "+businessList.length.toString()+"");
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
                firecount = business.firecount;
                notcool_count = business.notcool_count;
                user_count = business.user_count.toString();
                review_count = business.totalReviewusers.toString();
                business_images = business.business_images.toString();
                id = business.id.toString();

                okcount = business.okcount;
                print("okok: "+okcount.toString());

              });
            },
            markerId: MarkerId(business.id),
            position:
            LatLng(double.parse(business.lat), double.parse(business.long)),
            infoWindow: InfoWindow(
              title: business_name = business.business_name.toString(),
            ),
           /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
            icon:business.firecount>business.okcount?business.firecount>business.notcool_count?fireIcon!:notcoolIcon!:business.okcount>business.notcool_count?okIcon!:notcoolIcon!
          );
          markers.add(firstMarker);
          print("markerslength: "+markers.length.toString());
          print("business_lat: "+business.lat.toString());
        }
      }
    }

 

    setState(() {
       print("running: "+ "running",);
    });
  }

  @override
  void initState() {


    super.initState();
    setCustomMarker();
  print(widget.route.toString()+"**");
    this.mesageTextController.addListener(_onSearchChanged);
    if(widget.route.toString()=="home"){
      print("RunHomeRoute");
      WidgetsBinding.instance!
          .addPostFrameCallback((_) {
        locatePosition();
      });

      nearBy();
      initilize(nearByRestaurantList);

    }else{
      if(widget.list!=null) {
        print("widget Length: " + widget.list.length.toString());
        print("widget list: " + widget.list.toString());
        if (widget.list.length.toString() == "0") {
          locatePosition();
          nearBy();
          initilize(nearByRestaurantList);
        } else {
          locatePosition();
          filterData(widget.list);

        }
      }else{
        locatePosition();
        nearBy();
        initilize(nearByRestaurantList);
      }
      
    }

  }
@override
  void dispose() {
  newGoogleMapController!.dispose();
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

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _currentPosition =
      CameraPosition(target: LatLng(26.862471, 75.762413), zoom: 16);

     

  @override
  Widget build(BuildContext context) {

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FliterScreen(list:widget.list)));
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
              onTap: (latLong) {
                setState(() {

                  viewVisible = false;
print("MarkersLength "+markers.length.toString()+"^^");
                });
              },
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
                    color: kPrimaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(minWidth: 50),
                    prefixIconConstraints: BoxConstraints(minWidth: 50),
                    contentPadding: EdgeInsets.only(top: 3),
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
                      "assets/icons/-search.svg",
                      width: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
           
          ],
        ),

      
        ),

            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 6.w),
        child:  Visibility(
              visible: viewVisible,
              child: Padding(
                // padding: EdgeInsets.only(top: 57.2.h, left: 13.5.w),
                padding: EdgeInsets.only(bottom: 7.h, right: 12.2.w),
                child: Container(
                  height: 20.h,
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
                            GestureDetector(
                              onTap: (){
                                if(isCheckinClicked==false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "fire");
                                }
                              },
                              child: Container(
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
                            ),
                            GestureDetector(
                              onTap: (){
                                if(isCheckinClicked==false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "OkOk");
                                }
                              },
                              child: Container(
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
                            ),
                            GestureDetector(
                              onTap: (){
                                if(isCheckinClicked==false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "Not Cool");
                                }
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/snow.svg",
                                        color: kNotCoolColor, width: 8.w),
                                    Text(
                                      "Not Cool("
                                          +notcool_count.toString()+
                                          ")",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,

                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
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
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBussinessDynamic(id: id)));

                        },
                        child: Padding(
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
                                      Container(
                                        width: 45.w,
                                        child: Text(
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ,
      ),
        );
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
          modelAgentSearch.firecount = jsonArray[i]["firecount"];
          modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
          modelAgentSearch.okcount = jsonArray[i]["okcount"];
          print("lat: " + modelAgentSearch.lat.toString());
          modelAgentSearch.totalReviewusers = jsonArray[i]["totalReviewusers"].toString();
          modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();

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
          print("lengthis "+nearByRestaurantList.length.toString()+"^");
          newGoogleMapController!.setMapStyle("[]");
          initilize(nearByRestaurantList);
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
    print("Run "+"GetAllbuisnessList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.GETALLBUSINESSLIST_URL,
        ),
    body: {
          "id":id
    }
    );
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
          modelAgentSearch.business_name = jsonArray[i]["business_name"].toString();
         modelAgentSearch.business_images = jsonArray[i]["business_images"].toString();
          modelAgentSearch.distance = jsonArray[i]["distance"].toString();
          modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
          modelAgentSearch.description = jsonArray[i]["description"].toString();
          modelAgentSearch.business_category = jsonArray[i]["business_category "].toString();
          modelAgentSearch.user_count = jsonArray[i]["user_count"].toString();
          modelAgentSearch.review_count = jsonArray[i]["review_count"].toString();
          modelAgentSearch.location = jsonArray[i]["location"].toString();
          modelAgentSearch.category_name = jsonArray[i]["category_name"].toString();
          modelAgentSearch.fav = jsonArray[i]["fav"].toString();
          modelAgentSearch.lat = jsonArray[i]["lat"].toString();
          modelAgentSearch.long = jsonArray[i]["long"].toString();
          modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
          modelAgentSearch.firecount = jsonArray[i]["firecount"];
          modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
          modelAgentSearch.okcount = jsonArray[i]["okcount"];
          modelAgentSearch.totalReviewusers = jsonArray[i]["totalReviewusers"].toString();
          modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();

          print("lat: " + modelAgentSearch.lat.toString());
          if(modelAgentSearch.lat!=null) {
            nearByRestaurantList.add(modelAgentSearch);
          }
   /*       id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/


         // print("lattttttt: " + lat.toString());

        }

        setState(() {
          if(newGoogleMapController!=null) {
            newGoogleMapController!.setMapStyle("[]");
          }
          print("length is "+nearByRestaurantList.length.toString());
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

  Future<dynamic> checkInApi(String id, String check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("id");
    print("user_id Prinnt: " + user_id.toString());
    print("id Prinnt: " + id.toString().toString());
    setState(() {
      isloading = true;
    });

    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.CHECKINAPI,
        ),
        body: {"id": id.toString(), "user_id": user_id.toString(), "type":"1"});

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
    });

    if (res?.statusCode == 200) {
      isCheckinClicked = false;

      if (jsonRes["status"].toString() == "true") {

        setState(() {
          isloading = false;
        });
        if(!jsonRes["message"].toString().contains("You are already")) {

            checkoutApi(
                id,
                check.toString());

        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

      } else {
        setState(() {
          isloading = false;
         // Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      isCheckinClicked = false;
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }


  Future<dynamic> filterData(List<LifeStyle> key) async {
    print("Filter");

    List<String> list = [];
    key.forEach((element) {
      if (element.subLifeStyle != null) {
        if (element.subLifeStyle.length > 0) {
          for (var j = 0; j < element.subLifeStyle.length; j++) {
            if (element.subLifeStyle[j].isSelected) {
              list.add(element.subLifeStyle[j].id);
            }
          }
        }
      }
    });

    String s = list.join(', ');
    print("ssss " + s.toString());
    print(list.toString());
    if (list.length == 0) {
      locatePosition();
      nearBy();
      initilize(nearByRestaurantList);
    } else {
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
            "key": list.toString(),
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
            modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
            modelAgentSearch.description =
                jsonArray[i]["description"].toString();
            modelAgentSearch.business_category =
                jsonArray[i]["business_category "].toString();
            modelAgentSearch.user_count = jsonArray[i]["user_count"].toString();
            modelAgentSearch.review_count =
                jsonArray[i]["review_count"].toString();
            modelAgentSearch.totalReviewusers = jsonArray[i]["totalReviewusers"].toString();

            modelAgentSearch.location = jsonArray[i]["location"].toString();
            modelAgentSearch.category_name =
                jsonArray[i]["category_name"].toString();
            modelAgentSearch.fav = jsonArray[i]["fav"].toString();
            modelAgentSearch.lat = jsonArray[i]["lat"].toString();
            modelAgentSearch.long = jsonArray[i]["long"].toString();
            modelAgentSearch.firecount = jsonArray[i]["firecount"];
            modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
            modelAgentSearch.okcount = jsonArray[i]["okcount"];
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


          }
          print("FilterListLength " + nearByRestaurantList.length.toString() +
              "^^");
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


  Future<dynamic> checkoutApi(String buisnessid, String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());


    print("id " + id.toString() + "");
    print("review " + "review".toString() + "");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.BUSINESSREVIEW_URL,
      ),
    );



    if (tag.toString() != "null" || tag.toString() != "") {
      request.fields["tag"] = tag;
      print("tag1: " + tag.toString());
    }
    request.fields["type"] = "REVIEW";
    request.fields["business_id"] = buisnessid.toString();
    request.fields["user_id"] = id.toString();


    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      check = "";

      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["statusReview"]);


    } else {
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

}
