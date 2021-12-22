// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemarkthespot/components/shimmerEffect.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/favourites.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    bool isloading = false;

    var latPosition ;
    var longPosition ;

    


late Future gethomedata;



   late Position currentPosition;

  
 fetchLocation()async{
    await Geolocator.checkPermission().then((value)
    async {
      print("Check Permission "+value.toString()+"__");

      if(value==LocationPermission.denied){
        await Geolocator.requestPermission().then((value) async {
          print("Request Permission "+value.toString()+"_");
          if(value==LocationPermission.always){
            await Geolocator.getCurrentPosition().then((value)  {
              print("Lat "+value.latitude.toString());
              print("Long "+value.longitude.toString());
              latPosition = value.latitude;
              longPosition = value.longitude;
              
            });
          }else if(value==LocationPermission.whileInUse){
            await Geolocator.getCurrentPosition().then((value)  {
              print("Lat "+value.latitude.toString());
              print("Long "+value.longitude.toString());
              latPosition = value.latitude;
              longPosition = value.longitude;

            });
          }
        });
      }else if(value==LocationPermission.always){
        await Geolocator.getCurrentPosition().then((value)  {
          print("Lat "+value.latitude.toString());
          print("Long "+value.longitude.toString());
          latPosition = value.latitude;
          longPosition = value.longitude;

        });
      }else if(value==LocationPermission.whileInUse){
        await Geolocator.getCurrentPosition().then((value)  {
          print("Lat "+value.latitude.toString());
          print("Long "+value.longitude.toString());
          latPosition = value.latitude;
          longPosition = value.longitude;
        });


      }else if(value==LocationPermission.deniedForever){
        await Geolocator.requestPermission().then((value) async {
          print("Request Permission "+value.toString()+"_");
          if(value==LocationPermission.always){
            await Geolocator.getCurrentPosition().then((value)  {
              print("Lat "+value.latitude.toString());
              print("Long "+value.longitude.toString());
              latPosition = value.latitude;
              longPosition = value.longitude;
            });
          }else if(value==LocationPermission.whileInUse){
            await Geolocator.getCurrentPosition().then((value)  {
              print("Lat "+value.latitude.toString());
              print("Long "+value.longitude.toString());
              latPosition = value.latitude;
              longPosition = value.longitude;
            });
          }

        });
      }
    }).then((value) {
  homeApi();
    });
    /*  await Geolocator.getCurrentPosition().then((value) => {
      lat = value.latitude,
      long = value.longitude,
      print("Lat "+lat.toString()+""),
      print("Long "+long.toString()+"")
    });*/
  
 
  }
  void locatePosition() async {

    await Geolocator.checkPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


        currentPosition = position;

        LatLng latLngPosition = LatLng(position.latitude, position.longitude);
        print("lat: "+position.latitude.toString());
        print("long "+position.longitude.toString());

        latPosition = position.latitude.toString();
        longPosition = position.longitude.toString();

         homeApi();


  
  }



  var quoatesid,
      quoatesname,
      quoatesimage,
      quoatestitle,
      quoatesvideo,
      quoatesdescription;
  var dataid,
      name,
      username,
      email,
      image,
      opeing_hour,
      closing_hour,
      description,
      ratting,
      business_name,
      category_name,
      distance;

  @override
  void initState()  {
     //locatePosition();
     fetchLocation();

  
  
    

    super.initState();
  }


  static String videoID = 'mEZ74WnXGzw';

  // YouTube Video Full URL : https://www.youtube.com/watch?v=dFKhWe2bBkM&feature=emb_title&ab_channel=BBKiVines

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoID,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      loop: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
     print("lat1: "+latPosition.toString());
        print("long1 "+longPosition.toString());
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Favorites()));
                    },
                    child: SvgPicture.asset(
                      "assets/icons/heart1.svg",
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
                        fontSize: 18.sp, color: Colors.white, fontFamily: "Roboto"),
                  )
                ],
              ),
            ),
            body:  isloading
                    ? Align(
                        alignment: Alignment.center,
                        child: Platform.isAndroid
                            ? ShimmerEffectHome()
                            : CupertinoActivityIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Quote of the week",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: kCyanColor,
                                      fontFamily: "Segoepr"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            CachedNetworkImage(
                              imageUrl: quoatesimage.toString(),
                              imageBuilder: (context, imageProvider) =>  Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 23.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.w),
                                //color: Colors.white,
                                image: DecorationImage(
                                  // image: AssetImage("assets/images/Business.png"), fit: BoxFit.fill
                                image:  NetworkImage(
                                      //"assets/images/restaurant.jpeg"
                                      quoatesimage.toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // child: Image.network(quoatesimage.toString(), fit: BoxFit.fill)
                            ),
                              placeholder: (context, url) =>
                                  Image.asset("assets/images/Business.png", fit: BoxFit.fill,),
                              errorWidget: (context, url, error) => Image.asset("assets/images/Business.png", fit: BoxFit.fill,),
                            ),
                        
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                // "“Lorem Ipsum”",
                                quoatestitle.toString() != "null"
                                    ? "'" + quoatestitle.toString().trim() + "'"
                                    : "",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontFamily: "Segoepr"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut placerat orci nulla. Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Tempor id eu nisl nunc mi ipsum faucibus. Fusce id velit ut tortor pretium. Massa ultricies mi quis hendrerit dolor magna eget. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed",
                                quoatesdescription.toString() != "null"
                                    ? quoatesdescription.toString()
                                    : "",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Color(0xFFCECECE),
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 23.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                  color: Colors.white),
                              child: YoutubePlayer(
                                controller: _controller,
                                liveUIColor: Colors.amber,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  height: 20.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          //"assets/images/restaurant.jpeg"
                                          image.toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  // child: Image.asset(),
                                ),
                                Positioned(
                                  bottom: 2.h,
                                  left: 8.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                       // "Business",
            
                                       business_name.toString(),
            
            
                                        style: TextStyle(
                                            fontSize: 21.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700
                                            //fontFamily: "Segoepr"
                                            ),
                                      ),
                                      Text(
                                        // "Restaurant Name",
                                        category_name.toString() != "null" ? category_name.toString() : "",
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                          //fontWeight: FontWeight.w700
                                          //fontFamily: "Segoepr"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 3.h,
                                  right: 6.w,
                                  child: Row(
                                    children: [
                                      Text(
                                        //"4.5",
                                        ratting.toString(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                          //fontWeight: FontWeight.w700
                                          //fontFamily: "Segoepr"
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      SvgPicture.asset(
                                        "assets/icons/star.svg",
                                        color: Color(0xFFE8CD73),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Open time: " + opeing_hour.toString() + " AM",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500
                                            //fontFamily: "Segoepr"
                                            ),
                                      ),
                                      Text(
                                        "Close time: " +
                                            closing_hour.toString() +
                                            " PM",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500
                                            //fontFamily: "Segoepr"
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Text(
                                    "Distance: " + distance.toString() + " mi",
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500
                                        //fontFamily: "Segoepr"
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                description.toString(),
                                // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Color(0xFFCECECE),
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                "Giveaways",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: kCyanColor,
                                    fontFamily: "Segoepr"),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Color(0xFFCECECE),
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Color(0xFFCECECE),
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      )
             );
  }

  Future<dynamic> homeApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id lat: " + latPosition.toString());
    print("id long: " + longPosition.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.HOMEAPI_URL,
        ),
        body: {
          "id": id.toString(),
          "lat": latPosition.toString(),
          "long": longPosition.toString(),

          
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
        quoatesid = jsonRes["quoatesdata"]["id"].toString();
        print("id:" + quoatesid.toString());
        quoatestitle = jsonRes["quoatesdata"]["title"].toString();
        quoatesdescription = jsonRes["quoatesdata"]["description"].toString();
        quoatesimage = jsonRes["quoatesdata"]["image"].toString();
        quoatesvideo = jsonRes["quoatesdata"]["video"].toString();
        dataid = jsonRes["data"]["id"].toString();
        name = jsonRes["data"]["name"].toString();
        opeing_hour = jsonRes["data"]["opeing_hour"].toString();
        closing_hour = jsonRes["data"]["closing_hour"].toString();
        description = jsonRes["data"]["description"].toString();
        image = jsonRes["data"]["image"].toString();
        distance = jsonRes["data"]["distance"].toString();
        print("distance: " + distance.toString());
        ratting = jsonRes["data"]["ratting"].toString();
        business_name = jsonRes["data"]["business_name"].toString();
        category_name = jsonRes["data"]["category_name"].toString();

        setState(() {
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
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }
}
