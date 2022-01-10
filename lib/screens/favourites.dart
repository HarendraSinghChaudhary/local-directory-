import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/guest_account.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/account.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/services/api_client.dart';






class BusFav extends StatefulWidget {
  const BusFav({ Key? key }) : super(key: key);

  @override
  State<BusFav> createState() => _BusFavState();
}

class _BusFavState extends State<BusFav> {
  var ids = "";
   bool isloading = false;

   @override
   void initState() {
     super.initState();
     give();
   }



  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kCyanColor,
        centerTitle: true,
        title: Text(
          "Favorites",
          style:
              TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
        ),
      ),

     body: isloading
            ? Align(
                alignment: Alignment.center,
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator())
            : ids.toString() != '72'
                ? Favorites()
                : FavGuest()
                );


      

      
    
  }

  give () async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    ids = id.toString();
    print("idsss" +ids.toString());
    setState(() {
      
    });

  }
}








class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
  bool clicked = true;
  bool isloading = false;

  List<NearBy> favouriteRestaurantList = [];

  @override
  void initState() {
    getFavourite();
    super.initState();
  }

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kCyanColor,
      //   title: Center(
      //     child: Padding(
      //       padding: EdgeInsets.only(right: 15.w),
      //       child: Text(
      //         "Favorites",
      //         style:
      //             TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
      //       ),
      //     ),
      //   ),
      // ),
      body: isloading==true?Center(child: Platform.isIOS?CupertinoActivityIndicator():CircularProgressIndicator(),): ListView.builder(
        padding: EdgeInsets.only(top: 1.h),
        // shrinkWrap: true,
        // controller: _controller,
        itemCount: favouriteRestaurantList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBussiness()));
              },
              child: Container(
                width: double.infinity,
                height: 15.h,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 2.h,
                      child: Container(
                        margin: EdgeInsets.only(left: 2.5.w),
                        height: 13.h,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                            color: kBackgroundColor),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            CachedNetworkImage(
                              imageUrl: favouriteRestaurantList[index]
                                  .business_images
                                  .toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 14.h,
                                width: 16.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            // "assets/images/11.jpeg",

                                            favouriteRestaurantList[index]
                                                .business_images
                                                .toString()),
                                        fit: BoxFit.fill)),
                              ),
                              placeholder: (context, url) => Container(
                                height: 14.h,
                                width: 16.h,
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 14.h,
                                width: 16.h,
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
                                Text(
                                  // "Restaurant Name ",
                                  favouriteRestaurantList[index]
                                              .business_name
                                              .toString() !=
                                          "null"
                                      ? favouriteRestaurantList[index]
                                          .business_name
                                          .toString()
                                      : "Business Name",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: kCyanColor,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Segoepr"),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      favouriteRestaurantList[index]
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
                                      // "4.5",
                                      favouriteRestaurantList[index]
                                                  .ratting
                                                  .toString() !=
                                              "null"
                                          ? favouriteRestaurantList[index]
                                              .ratting
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
                                    //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
                                    favouriteRestaurantList[index]
                                                .description
                                                .toString() !=
                                            "null"
                                        ? favouriteRestaurantList[index]
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
                      child: InkWell(
                          onTap: () {
                            if (clicked) {
                              isloading = true;
                              businessFavApi(favouriteRestaurantList[index]
                                  .id
                                  .toString(), index);
                            }

                          },
                          child: SvgPicture.asset(
                            "assets/icons/-heart.svg",
                            color:
                                favouriteRestaurantList[index].fav.toString() ==
                                        "1"
                                    ? Colors.white
                                    : kCyanColor,
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

   Future<dynamic> businessFavApi(String business_id, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
     // clicked = false;
    });
   

    var request = http.post(
        Uri.parse(
          RestDatasource.BUSSINESSFAV_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": business_id,
          "fav": "0",
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

        favouriteRestaurantList.clear();
      

        setState(() {
          isloading = false;
        });

        getFavourite();

     

        //nearBy();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));

        

      } else {
        // if(fav=="1"){
        //   nearByRestaurantList[index].fav = "0";
        // }else{
        //   nearByRestaurantList[index].fav = "1";
        // }
        setState(() {
          clicked = true;
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }

    } else {
      setState(() {
        clicked = true;
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }



  Future<dynamic> getFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.GETFAVOURITE_URL,
        ),
        body: {
          "user_id": id.toString(),
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
          modelAgentSearch.fav = jsonArray[i]["category_name"].toString();

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.business_name.toString());

          favouriteRestaurantList.add(modelAgentSearch);

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
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }
}
