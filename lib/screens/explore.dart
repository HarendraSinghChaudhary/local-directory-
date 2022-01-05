import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/components/shimmerEffect.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/account.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/screens/signup_Screen.dart';
import 'package:wemarkthespot/services/api_client.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  _getRequests() async {}

  bool _hasBeenPressed = true;
  var ids = "";
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
  var lat = "";
  var long = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<NearBy> nearByRestaurantList = [];
  bool isRefresh = false;

  @override
  void initState() {
    nearBy();
    give();
    super.initState();
  }

  bool isloading = false;
  List<Map<String, String>> sliderImages = [
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg.jpg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg.jpg"
    },
  ];

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    print("name1 : " + business_name.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "Explore",
          style: TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () {
          _refreshController.loadNoData();
        },
        child: isloading
            ? Align(
                alignment: Alignment.center,
                child: Platform.isAndroid
                    ? ShimmerEffect()
                    : CupertinoActivityIndicator())
            : ListView(
                shrinkWrap: true,
                controller: _controller,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          "Featured Business",
                          style: TextStyle(
                              fontSize: 14.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Segoepr"),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        CustomSliderWidget(
                          items: [
                            "assets/images/11.jpeg",
                            "assets/images/11.jpeg",
                            "assets/images/restaurant.jpeg"
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          "Restaurant Nearby ",
                          style: TextStyle(
                              fontSize: 14.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Segoepr"),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        isloading
                            ? Align(
                                alignment: Alignment.center,
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator())
                            : resCard()
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Column guestCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.h),
          height: 10.h,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Profile",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Log in or sign up to view your complete profile",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        DefaultButton(
            width: 45.w,
            height: 6.5.h,
            text: "Continue",
            press: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (route) => false);
            }),
      ],
    );
  }

  ListView resCard() {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: nearByRestaurantList.length,
      itemBuilder: (BuildContext context, int index) {
        print("name : " + business_name.toString());
        return Column(
          children: [




            InkWell(
              onTap: () {

                if (ids.toString() != '72') {
                  Navigator.of(context)
                    .push(
                      new MaterialPageRoute(
                          builder: (_) => new DetailBussiness(
                                nearBy: nearByRestaurantList[index],
                              )),
                    )
                    .then((val) => val ? _getRequests() : null);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ));

                visitApi(nearByRestaurantList[index].id.toString(), index);
                  
                } else {

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please login or signup first to view business profile")));
                }
             
              },
              child: Container(
                height: 16.h,
                child: Stack(
                  children: [
                    Positioned(
                      //top: 2.5.h,

                      child: Container(
                        height: 13.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                            color: kBackgroundColor),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: nearByRestaurantList[index]
                                  .business_images
                                  .toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 14.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            // "assets/images/11.jpeg",

                                            nearByRestaurantList[index]
                                                .business_images
                                                .toString()),
                                        fit: BoxFit.fill)),
                              ),
                              placeholder: (context, url) => Container(
                                height: 14.h,
                                width: 15.h,
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 14.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/Business.png",
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 0.3.h,
                                ),
                                Container(
                                  width: 51.w,
                                  child: Text(
                                    //"Restaurant Name ",

                                    nearByRestaurantList[index]
                                                .business_name
                                                .toString() !=
                                            "null"
                                        ? nearByRestaurantList[index]
                                            .business_name
                                            .toString()
                                        : "Business Name",
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: kCyanColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Segoepr"),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      nearByRestaurantList[index]
                                              .distance
                                              .toString() +
                                          " miles away",
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                      width: 1.2.w,
                                    ),
                                    Text(
                                      "|",
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                      width: 1.2.w,
                                    ),
                                    Text(
                                      //"4.5",
                                      nearByRestaurantList[index]
                                                  .avgratting
                                                  .toString() !=
                                              "null"
                                          ? nearByRestaurantList[index]
                                              .avgratting
                                              .toString()
                                          : "0",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: kPrimaryColor,
                                        //fontWeight: FontWeight.w700
                                        //fontFamily: "Segoepr"
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/star.svg",
                                      color: kPrimaryColor,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Container(
                                  width: 56.w,
                                  child: Text(
                                    // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
                                    nearByRestaurantList[index]
                                                .description
                                                .toString() !=
                                            "null"
                                        ? nearByRestaurantList[index]
                                            .description
                                            .toString()
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 8.sp, color: Colors.white
                                        //fontWeight: FontWeight.w700
                                        //fontFamily: "Segoepr"
                                        ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1.w,
                      top: 0.2.h,
                      child: ids.toString() != '72'
                          ? InkWell(
                              onTap: () {
                                var favv = nearByRestaurantList[index]
                                            .fav
                                            .toString() ==
                                        "1"
                                    ? "0"
                                    : "1";
                                setState(() {
                                  nearByRestaurantList[index].fav = favv;
                                });

                                businessFavApi(
                                    nearByRestaurantList[index].id.toString(),
                                    favv,
                                    index);
                              },
                              child:
                                  nearByRestaurantList[index].fav.toString() ==
                                          "1"
                                      ? SvgPicture.asset(
                                          "assets/icons/active-hear.svg",

                                          // color: _hasBeenPressed ? kCyanColor : Colors.white,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/-heart.svg",
                                        ),
                            )
                          : InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please login or signup first to make favourite business")));
                              },
                              child:
                                  nearByRestaurantList[index].fav.toString() ==
                                          "1"
                                      ? SvgPicture.asset(
                                          "assets/icons/active-hear.svg",

                                          // color: _hasBeenPressed ? kCyanColor : Colors.white,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/-heart.svg",
                                        ),
                            ),
                    )
                  ],
                ),
              ),
            ),

            // SizedBox(height: 0.5.h,),
          ],
        );
      },
    );
  }

  give() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    ids = id.toString();
    print("idsss" + ids.toString());
    setState(() {});
  }

  void _onRefresh() async {
    isRefresh = true;
    nearBy();
  }

  Future<dynamic> businessFavApi(
      String business_id, String fav, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");

    ids = id.toString();
    print("id Print: " + id.toString());
    setState(() {
      // isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.BUSSINESSFAV_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": business_id,
          "fav": fav,
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
        setState(() {
          //isloading = false;
        });

        isloading = false;

        //nearBy();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
      } else {
        if (fav == "1") {
          nearByRestaurantList[index].fav = "0";
        } else {
          nearByRestaurantList[index].fav = "1";
        }
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

  Future<dynamic> visitApi(String business_id, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      // isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.VISIT_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": business_id,
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
        setState(() {
          //isloading = false;
        });

        isloading = false;

        //nearBy();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));

      } else {
        // if(fav=="1"){
        //   nearByRestaurantList[index].fav = "0";
        // }else{
        //   nearByRestaurantList[index].fav = "1";
        // }
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
      nearByRestaurantList.clear();
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
          modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
          modelAgentSearch.countUserreview =
              jsonArray[i]["totalReviewusers"].toString();

          print("id: " + modelAgentSearch.id.toString());
          print("ratting: " + modelAgentSearch.avgratting.toString());

          nearByRestaurantList.add(modelAgentSearch);

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

class NearBy {
  var id = "";
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
  var fav = "";
  var lat = "";
  var long = "";
  var avgratting = "";
  var countUserreview = "";
}

class CustomSliderWidget extends StatefulWidget {
  // final List<String> items;
  final List items;

  CustomSliderWidget({required this.items});

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  int activeIndex = 0;
  setActiveDot(index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              onPageChanged: (index, reason) {
                setActiveDot(index);
              },
              enableInfiniteScroll: false,
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              autoPlayAnimationDuration: Duration(seconds: 2),
              // autoPlay: true,
              viewportFraction: 1.0,
            ),
            items: widget.items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(children: [
                    Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.w),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Image.asset(),
                    ),
                    Positioned(
                      bottom: 6.h,
                      left: 8.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Business",
                          //   style: TextStyle(
                          //       fontSize: 21.sp,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w700
                          //       //fontFamily: "Segoepr"
                          //       ),
                          // ),
                          Text(
                            "Restaurant Name",
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
                      bottom: 6.h,
                      right: 6.w,
                      child: Row(
                        children: [
                          Text(
                            "4.5",
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
                            color: kPrimaryColor,
                          )
                        ],
                      ),
                    ),
                  ]);
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          left: 20,
          right: 0,
          bottom: 20,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (idx) {
                return activeIndex == idx ? ActiveDot() : InactiveDot();
              })),
        )
      ],
    );
  }
}

class ActiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class InactiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
