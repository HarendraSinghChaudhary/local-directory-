


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/services/api_client.dart';

class Businesslist extends StatefulWidget {
  const Businesslist({Key? key,}) : super(key: key);

  @override
  State<Businesslist> createState() => _BusinesslistState();
}

class _BusinesslistState extends State<Businesslist> {
 
  ScrollController _controller = new ScrollController();
  bool isloading = false;
    var ids = "";
     var business_name = "";
  List<NearBy> nearByRestaurantList = [];
   bool favEnable = true;
   @override
  void initState() {
    super.initState();
    nearBy();

   }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "Latest Bussiness ",
          style: TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
        ),
      ),
      body:ListView(
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
                      
                        
                        SizedBox(
                          height: 1.5.h,
                        ),
                        // Text(
                        //   "Restaurants Nearby ",
                        //   style: TextStyle(
                        //       fontSize: 14.5.sp,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w700,
                        //       fontFamily: "Segoepr"),
                        // ),
                        // SizedBox(
                        //   height: 1.5.h,
                        // ),
                       isloading?Align(
                         alignment:Alignment.center,
                         child:CircularProgressIndicator.adaptive()
                       ):
                       
                         resCard()
                      ],
                    ),
                  )
                ],
              ),
    );
  }





 ListView resCard() {
   print("neraby "+ nearByRestaurantList.length.toString());
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
                      .then((value) {
                    nearBy();
                  });

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
                                if (favEnable == true) {
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
                                }
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
  Future<dynamic> nearBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(
        Uri.parse(
          RestDatasource.LATEST,
        ));
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
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
          modelAgentSearch.totalReviewusers = jsonArray[i]["totalReviewusers"].toString();
          modelAgentSearch.checkIn_status = jsonArray[i]["checkIn_status"].toString();
          modelAgentSearch.countUserreview = jsonArray[i]["totalReviewusers"].toString();
          modelAgentSearch.opening_time = jsonArray[i]["opeing_hour"].toString();
          modelAgentSearch.closing_time = jsonArray[i]["closing_hour"].toString();


          nearByRestaurantList.add(modelAgentSearch);
          print("list"+ nearByRestaurantList.toString());
        }
        if(mounted) {
          setState(() {
            isloading = false;
          });
        }

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
  Future<dynamic> businessFavApi(
      String business_id, String fav, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");

    ids = id.toString();
    print("id Print: " + id.toString());
    setState(() {
      // isloading = true;
      favEnable = false;
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
      favEnable = true;
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
}
