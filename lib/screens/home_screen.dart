// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/shimmerEffect.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/communityRepliesById.dart';
import 'package:wemarkthespot/screens/detailBusinessdynamic.dart';
import 'package:wemarkthespot/screens/favourites.dart';
import 'package:wemarkthespot/screens/testingsheet.dart';
import 'package:wemarkthespot/screens/video_player_widget.dart';
import 'package:wemarkthespot/screens/video_player_widget4.dart';
import 'package:wemarkthespot/screens/video_player_widgett.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/body.dart';
import '../theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = false;
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? videoPlayerController2;

  late Future gethomedata;
  late Position currentPosition;
  FirebaseMessaging? messaging;
  fetchLocation() async {
    isloading = true;

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

  var isPlaying = false;
  var isInitialized = false;
  var isInitialized2 = false;

  var quoatesid,
      quoatesname,
      quoatesimage,
      quoatestitle,
      quoatesvideo,
      imgvideostatus,
      quoatesdescription;
  var dataid,
      name,
      username,
      email,
      image,
      opeing_hour,
      closing_hour,
      description,
      datavideo,
      datavideo_status,
      ratting,
      business_name,
      category_name,
      distance;
  var giveawayDesc, giveawaytitle, giveawayImage;

  Future<void>? _initializeVideoPlayerFuture;

  Future<void>? _initializeVideoPlayerFuture2;
  @override
  void initState() {
    //locatePosition();
    print("lat " + lat.toString() + "^^");
    if (lat.toString().trim() != "" && lat.toString().trim() != "null") {
      print("case1");
      homeApi();
    } else {
      print("case2");
      fetchLocation();
    }
    isPlaying = true;

    super.initState();
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print('Running Get Initial Message');

      if (message != null) {
        print(
            'Running Get Initial Message is ' + message.data.toString() + "^^");
        if (message.data != null) {
          var listdata = await breakPayload(message.data.toString());
          var type = "";
          var review_id = "";
          var reply_id = "";
          listdata.forEach((element) {
            if (element.contains("type")) {
              int i = element.indexOf(":") + 2;
              print("Type " + element.substring(i) + "^^");
              type = element.substring(i).toString();
            }

            if (element.contains("businessreview_id")) {
              int i = element.indexOf(":") + 2;
              print("businessreview_id " + element.substring(i) + "^^");
              review_id = element.substring(i).toString();
            }

            if (element.contains("reply_id")) {
              int i = element.indexOf(":") + 2;
              print("reply_id " + element.substring(i) + "^^");
              reply_id = element.substring(i).toString();
            }
          });

          switch (type.toLowerCase()) {
            case "review":
              NotificationModel model = NotificationModel();
              model.review_id = review_id;
              model.type = type;
              model.reply_id = reply_id;
              Navigator.pushNamed(context, "/communityReplyId",
                  arguments: model);

              break;
            case "hotspot":
              NotificationModel model = NotificationModel();
              model.review_id = review_id;
              model.type = type;
              model.reply_id = reply_id;
              Navigator.pushNamed(context, "/hotspotreply", arguments: model);

              break;
            case "addhotspot":
              await flutterLocalNotificationsPlugin.cancelAll();
              Navigator.pushNamed(context, "/addhotspot");

              break;
            case "giveaway":
              break;
            case "sendmail":
              break;
            case "business":
              NotificationModel model = NotificationModel();
              model.review_id = review_id.toString();
              model.reply_id = "";
              model.type = "business";

              Navigator.pushNamed(context, "/detailedbusiness",
                  arguments: model);
              break;

            case "businesslist":
              Navigator.pushReplacementNamed(context, "/explore");

              break;
            case "latest":
              Navigator.pushReplacementNamed(context, "/latestbusiness");

              break;

            default:
              Navigator.pushNamed(context, "/notification");
          }
          Map<String, dynamic> map = message.data;
          print(map.toString());
          createListMap(map);
          /*     const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'user_channel',
            'user_channel',
            channelDescription: 'User channel',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            enableLights: true,
            enableVibration: true,
            playSound: true,
          );
          const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
            10,
            message.data["title"].toString(),
            message.data["body"].toString(),
            platformChannelSpecifics,
            payload: map.toString(),
          );*/
        }
      }
    });
  }

/*
  static String videoID = '2iHoeHVmw0Q';

  // YouTube Video Full URL : https://www.youtube.com/watch?v=dFKhWe2bBkM&feature=emb_title&ab_channel=BBKiVines

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoID,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      loop: true,
    ),
  );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(14.0),
            child: InkWell(
              onTap: () {
                if (videoPlayerController != null) {
                  if (videoPlayerController!.value.isInitialized) {
                    videoPlayerController?.pause();
                  }
                }

                if (videoPlayerController2 != null) {
                  if (videoPlayerController2!.value.isInitialized) {
                    videoPlayerController2?.pause();
                  }
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => BusFav()));
              },
              child: SvgPicture.asset(
                "assets/icons/heart1.svg",
                width: 26,
                color: Colors.white,
              ),
            ),
          ),
          title: SvgPicture.asset(
            "assets/icons/Layer.svg",
            width: 50.w,
          ),
        ),
        body: isloading
            ? Align(alignment: Alignment.center, child: ShimmerEffectHome())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    imgvideostatus == 1
                        ? SizedBox(
                            height: 200,
                            child: VideoItems(
                              videoPlayerController: videoPlayerController2!,
                            ))
                        : CachedNetworkImage(
                            imageUrl: quoatesimage.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 23.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.w),
                                //color: Colors.white,
                                image: DecorationImage(
                                  // image: AssetImage("assets/images/Business.png"), fit: BoxFit.fill
                                  image: NetworkImage(
                                      //"assets/images/restaurant.jpeg"
                                      quoatesimage.toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // child: Image.network(quoatesimage.toString(), fit: BoxFit.fill)
                            ),
                            placeholder: (context, url) => Image.asset(
                              "assets/images/Business.png",
                              fit: BoxFit.fill,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/Business.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                    SizedBox(
                      height: 1.5.h,
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
                    Visibility(
                      visible: quoatestitle.toString() != "null",
                      child: SizedBox(
                        height: 2.h,
                      ),
                    ),
                    Visibility(
                      visible: quoatestitle.toString() != "null",
                      child: Container(
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
                    ),
                    Visibility(
                      visible: quoatesdescription.toString() != "null",
                      child: Container(
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
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    datavideo_status == 0
                        ? SizedBox(
                            height: 200,
                            child: VideoItems(
                              videoPlayerController: videoPlayerController!,
                            ))
                        : Container(),

                    /* YoutubePlayer(
                        controller: _controller,
                        liveUIColor: Colors.amber,
                        showVideoProgressIndicator: true,
                      ),*/

                    Visibility(
                      visible: image.toString() != "null",
                      child: SizedBox(
                        height: 2.h,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return loader;
                        //     });
                        NotificationModel model = NotificationModel();
                        model.review_id = dataid;
                        model.reply_id = "";
                        model.type = "business";
                        // Future.delayed(
                        //   Duration(seconds: 1),
                        //   (){

                            
                        //   }
                        // );
                        Navigator.pushNamed(context, "/detailedbusiness",
                                arguments: model);

                        
                      },
                      child: Stack(
                        children: [
                          Visibility(
                            visible: image.toString() != "null",
                            child: Container(
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
                          ),
                          Visibility(
                            visible: business_name.toString() != "null",
                            child: Positioned(
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
                                    category_name.toString() != "null"
                                        ? category_name.toString()
                                        : "",
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
                          ),
                          Visibility(
                            visible: ratting.toString() != "null",
                            child: Positioned(
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
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: opeing_hour.toString() != "null",
                      child: SizedBox(
                        height: 2.h,
                      ),
                    ),
                    Visibility(
                      visible: opeing_hour.toString() != "null",
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Open time: " +
                                      opeing_hour.toString() +
                                      " AM",
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
                            Visibility(
                              visible: distance.toString() != "null",
                              child: SizedBox(
                                height: 1.5.h,
                              ),
                            ),
                            Visibility(
                              visible: distance.toString() != "null",
                              child: Text(
                                "Distance: " + distance.toString() + " mi",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500
                                    //fontFamily: "Segoepr"
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    description.toString() != "null" ||
                            description.toString() != ""
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              description.toString() != "null"
                                  ? description.toString()
                                  : "",
                              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xFFCECECE),
                                  fontFamily: "Roboto"),
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    SizedBox(
                      height: 3.h,
                    ),
                    giveawayImage.toString() != "null"
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              "Giveaways",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: kCyanColor,
                                  fontFamily: "Segoepr"),
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    SizedBox(
                      height: 2.h,
                    ),
                    giveawayImage.toString() != "null"
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 20.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              image: DecorationImage(
                                image: NetworkImage(
                                    //"assets/images/restaurant.jpeg"
                                    giveawayImage.toString()),
                                fit: BoxFit.fill,
                              ),
                            ),
                            // child: Image.asset(),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    giveawayImage.toString() != "null"
                        ? SizedBox(
                            height: 2.h,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    giveawaytitle.toString() != "null"
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              "${giveawaytitle.toString()}",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: kCyanColor,
                                  fontFamily: "Segoepr"),
                            ),
                          )
                        : Container(),
                    giveawayDesc.toString() != "null"
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              giveawayDesc.toString() != "null"
                                  ? giveawayDesc.toString()
                                  : "",
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xFFCECECE),
                                  fontFamily: "Roboto"),
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    giveawayDesc.toString() != "null"
                        ? SizedBox(
                            height: 2.h,
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ));
  }

  @override
  Widget VideoPlayWidget(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Video Player',
              debugShowCheckedModeBanner: false,
              home: Stack(
                children: [
                  Center(
                    child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController!),
                            )
                          : Container(),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (videoPlayerController != null) {
                            if (videoPlayerController!.value.isPlaying) {
                              videoPlayerController?.pause();
                            } else {
                              videoPlayerController?.play();
                            }
                          }
                        });
                      },
                      child: Icon(
                        videoPlayerController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget VideoPlayWidget2(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture2,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Video Player',
              debugShowCheckedModeBanner: false,
              home: Stack(
                children: [
                  Center(
                    child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: videoPlayerController2!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  videoPlayerController2!.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController!),
                            )
                          : Container(),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (videoPlayerController2!.value.isPlaying) {
                            videoPlayerController2!.pause();
                          } else {
                            videoPlayerController2!.play();
                          }
                        });
                      },
                      child: Icon(
                        videoPlayerController2!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void dispose() {
    isPlaying = false;
/*

    if(videoPlayerController!=null) {
      if (videoPlayerController!.value.isInitialized) {
        videoPlayerController!.pause();
        videoPlayerController?.removeListener(() {
          checkVideo();
        });
        videoPlayerController?.dispose();
      }
    }

    if(videoPlayerController2!=null) {
      if (videoPlayerController2!.value.isInitialized) {
        videoPlayerController2?.pause();
        videoPlayerController?.removeListener(() {
          checkVideo2();
        });
        videoPlayerController2?.dispose();
      }
    }
*/

    super.dispose();
  }

  Future<dynamic> homeApi() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value.toString();
      print("FCM " + fcm_token.toString() + "^^");
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id lat: " + lat.toString());
    print("id long: " + long.toString());
    print("fcm token: " + fcm_token.toString());
    if (mounted) {
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
          "lat": lat.toString(), //"26.8546714985159",
          "long": long.toString(), //"75.76675952576491"
          "fcm_token": fcm_token.toString()
        });

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("ResponseHome: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);
      notification_status = jsonRes["notification_status"].toString();
      print("notification status " +
          jsonRes["notification_status"].toString() +
          "^^");
      if (jsonRes["status"].toString() == "true") {
        quoatesid = jsonRes["quoatesdata"]["id"].toString();
        print("id:" + quoatesid.toString());
        quoatestitle = jsonRes["quoatesdata"]["title"].toString();
        quoatesdescription = jsonRes["quoatesdata"]["description"].toString();
        quoatesimage = jsonRes["quoatesdata"]["image"].toString();
        imgvideostatus = jsonRes["quoatesdata"]["quote_video_image_status"];
        datavideo = jsonRes["quoatesdata"]["video"].toString();
        datavideo_status = jsonRes["quoatesdata"]["video_status"];
        //dataid = jsonRes["data"]["id"].toString();
        name = jsonRes["data"]["name"].toString();
        opeing_hour = jsonRes["data"]["opeing_hour"].toString();
        closing_hour = jsonRes["data"]["closing_hour"].toString();
        description = jsonRes["data"]["description"].toString();
        dataid = jsonRes["data"]["user_id"].toString();

        print("data id: " + dataid.toString());

        image = jsonRes["data"]["business_images"].toString();
        distance = jsonRes["data"]["distance"].toString();
        print("distance: " + distance.toString());
        ratting = jsonRes["data"]["avgratting"].toString();
        business_name = jsonRes["data"]["business_name"].toString();
        category_name = jsonRes["data"]["category_name"].toString();

        giveawayDesc = jsonRes["giweaways"]["description"].toString();
        giveawayImage = jsonRes["giweaways"]["image"].toString();
        giveawaytitle = jsonRes["giweaways"]["name"].toString();
        print("giveawayDesc " + giveawayDesc.toString() + "^^");
        print("giveawayImage " + giveawayImage.toString() + "^^");

        datavideo = jsonRes["quoatesdata"]["video"].toString();

        print("video: " + jsonRes["quoatesdata"]["video"].toString());
        if (datavideo != null) {
          videoPlayerController =
              await VideoPlayerController.network(datavideo);
        }
        if (imgvideostatus.toString() == "1") {
          videoPlayerController2 =
              new VideoPlayerController.network(quoatesimage);
        }
/*
      if(datavideo!=null) {
        videoPlayerController = new VideoPlayerController.network(datavideo);

        _initializeVideoPlayerFuture =
            videoPlayerController!.initialize().then((_) {
              isInitialized = true;

            });

          videoPlayerController!.addListener(() {
            checkVideo();
          });

      }


        if(imgvideostatus.toString()=="1") {
          videoPlayerController2 = new VideoPlayerController.network(quoatesimage);

          _initializeVideoPlayerFuture2 =
              videoPlayerController2!.initialize().then((_) {
                isInitialized2 = true;
              });
          videoPlayerController2!.addListener(() {
            checkVideo2();
          });
        }*/

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
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (videoPlayerController!.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (videoPlayerController!.value.position ==
        videoPlayerController!.value.duration) {
      print('video Ended');
    }
  }

  void checkVideo2() {
    // Implement your calls inside these conditions' bodies :
    if (videoPlayerController2!.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (videoPlayerController2!.value.position ==
        videoPlayerController2!.value.duration) {
      print('video Ended');
    }

    setState(() {});
  }
}
