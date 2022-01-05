import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotSpotReply.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/screens/testing_overlay.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:select_dialog/select_dialog.dart';

class Hotspot extends StatefulWidget {
  const Hotspot({Key? key}) : super(key: key);

  @override
  _HotspotState createState() => _HotspotState();
}

class _HotspotState extends State<Hotspot> {
  var selectedId = "";
  var person_name = "";
  var user_image = "";
  var business_user_name = "";
  var id = "";
  var user_id = "";
  var business_id = "";
  var message = "";
  var created_at = "";
  bool isloading = false;
  ScrollController _controller = new ScrollController();
  TextEditingController mesageTextController = new TextEditingController();
  TextEditingController businessNameController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();

  List<GetHotSpotClass> getHostSpotList = [];

  List<GetAllBusiness> getAllBusinessList = [];

  String selectedName = "";
  String selectedvalue = "";
  @override
  void initState() {
    getHotspotApi();
    getallBusinessDataApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              "The Hotspot",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 4.w),
        //     child: InkWell(
        //         onTap: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => TestApp()));
        //         },
        //         child: SvgPicture.asset("assets/icons/message.svg")),
        //   )
        // ],
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            controller: _controller,
            children: [
              SizedBox(
                height: 2.5.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 7.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: Colors.white),
                child: TextFormField(
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  controller: mesageTextController,
                  onChanged: (value) {
                    searchData(value.toString());
                  },
                  validator: (val) {},
                  decoration: InputDecoration(
                    prefixIconConstraints: BoxConstraints(minWidth: 60),
                    suffixIconConstraints: BoxConstraints(minWidth: 60),
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
                            getHostSpotList.clear();

                            getHotspotApi();
                          },
                          child: SvgPicture.asset("assets/icons/cross.svg", width: 4.w, color: kPrimaryColor,)),
                      prefixIcon: SvgPicture.asset("assets/icons/-search.svg", width: 24, color: kPrimaryColor,), ),
                ),
              ),
              SizedBox(
                height: 3.5.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: getHostSpotList.length,
                itemBuilder: (BuildContext context, int index) {
                  TextEditingController messageController =
                      new TextEditingController();
                  return Column(
                    children: [
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          color: kBackgroundColor,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: CachedNetworkImage(
                                      imageUrl: getHostSpotList[index]
                                          .user_image
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: NetworkImage(
                                          getHostSpotList[index]
                                              .user_image
                                              .toString(),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: AssetImage(
                                            "assets/images/usericon.png"),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: AssetImage(
                                            "assets/images/usericon.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.9.w,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Container(
                                          width: 74.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [

                                                  Container(
                                                    width: 53.w,
                                                    child: Text(getHostSpotList[index]
                                                              .person_name
                                                              .toString() + " @ " +getHostSpotList[index]
                                                                .business_user_name
                                                                .toString(),

                                                                style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: kCyanColor,
                                                          fontFamily: "Segoepr"),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                                
                                                                ),
                                                  ),




                                                  // Text(
                                                  //   // "Person Name @ Bar Name",

                                                  //   getHostSpotList[index]
                                                  //               .person_name
                                                  //               .toString() !=
                                                  //           "null"
                                                  //       ? getHostSpotList[index]
                                                  //           .person_name
                                                  //           .toString()
                                                  //       : "User Name",
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  //   style: TextStyle(
                                                  //       fontSize: 11.sp,
                                                  //       color: kCyanColor,
                                                  //       fontFamily: "Segoepr"),
                                                  // ),
                                                  // Text(
                                                  //   " @ ",
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  //   style: TextStyle(
                                                  //       fontSize: 11.sp,
                                                  //       color: kCyanColor,
                                                  //       fontFamily: "Segoepr"),
                                                  // ),
                                                  // Container(
                                                  //   width: 34.w,
                                                  //   child: Text(
                                                  //     // "Person Name @ Bar Name",
                                                    
                                                  //     getHostSpotList[index]
                                                  //                 .business_user_name
                                                  //                 .toString() !=
                                                  //             "null"
                                                  //         ? getHostSpotList[index]
                                                  //             .business_user_name
                                                  //             .toString()
                                                  //         : "",
                                                      
                                                        
                                                  //         maxLines: 2,
                                                  //     style: TextStyle(
                                                  //         fontSize: 11.sp,
                                                  //         color: kCyanColor,
                                                  //         fontFamily: "Segoepr"),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 2.w),
                                                child: Text(
                                                  //  "2m ago",

                                                  getHostSpotList[index]
                                                      .timedelay
                                                      .toString()
                                                      ,
                                                      
                                                      overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.1.h,
                                        ),
                                        Container(
                                          width: 74.w,
                                          child: Text(
                                            // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
                                            getHostSpotList[index]
                                                        .message
                                                        .toString() !=
                                                    "null"
                                                ? getHostSpotList[index]
                                                    .message
                                                    .toString()
                                                : "",
                                            style: TextStyle(
                                                // overflow: TextOverflow.ellipsis,
                                                fontSize: 10.2.sp,
                                                color: Color(0xFFCECECE),
                                                fontFamily: 'Roboto'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Container(
                                          width: 74.w,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HotSpotReply(
                                                                  id: getHostSpotList[
                                                                          index]
                                                                      .id
                                                                      .toString(),

                                                                      username: getHostSpotList[
                                                                          index]
                                                                      .person_name
                                                                      .toString(),

                                                                      businessname: getHostSpotList[
                                                                          index]
                                                                      .business_user_name
                                                                      .toString(),

                                                                      image:getHostSpotList[
                                                                          index]
                                                                      .user_image
                                                                      .toString(),

                                                                      message: getHostSpotList[
                                                                          index]
                                                                      .message
                                                                      .toString(),

                                                                      time: getHostSpotList[
                                                                          index]
                                                                      .timedelay
                                                                      .toString(),


                                                                      ),
                                                                      
                                                                      ));
                                                },
                                                child: Text(
                                                  "View Replies",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.white,
                                                      fontFamily: "Roboto"),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: SizedBox(
                                                  width: 50.w,
                                                  child: TextField(
                                                    controller:
                                                        messageController,
                                                    onChanged: (val) {
                                                      print(val);

                                                      getHostSpotList[index]
                                                              .messageText =
                                                          val.toString();
                                                    },
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                    ),
                                                    maxLines: 50,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        0.h,
                                                                    horizontal:
                                                                        4.w),
                                                        fillColor: Colors.black,
                                                        filled: true,
                                                        hintText: "Reply",
                                                        suffixIcon: InkWell(
                                                            onTap: () {
                                                              var mesage =
                                                                  messageController
                                                                      .text
                                                                      .toString();

                                                              if (mesage ==
                                                                      "" ||
                                                                  mesage ==
                                                                      "null") {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text("Please enter reply")));
                                                              } else {

                                                                replyOnHotspotReviewApi(
                                                                  getHostSpotList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  getHostSpotList[
                                                                          index]
                                                                      .messageText
                                                                      .toString());

                                                              }

                                                              

                                                              messageController
                                                                  .clear();
                                                            },
                                                            child: Icon(
                                                                Icons.send,
                                                                color:
                                                                    kPrimaryColor)),
                                                        hintStyle: TextStyle(
                                                            fontSize: 9.sp,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      //replyWidget(controller: _controller),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),

          
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 6.w),
        child: buildMessageFormField(),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      height: 7.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(9.w)),
      child: TextField(
        onSubmitted: (value) {},
        style: TextStyle(color: Colors.black, fontSize: 15.0),
        // controller: _textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type your message...',
          hintStyle: TextStyle(color: Colors.grey),
         
        ),
        // focusNode: focusNode,
      ),
    );
  }

  Future<dynamic> searchData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("key Print: " + key.toString());

    var request = http.post(
        Uri.parse(RestDatasource.SEARCHDATA_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "id": id.toString(),
          "key": key.toString(),
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
      final date2 = DateTime.now();
      if (jsonRes["status"] == true) {
        getHostSpotList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          GetHotSpotClass modelAgentSearch = new GetHotSpotClass();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.person_name = jsonArray[i]["person_name"].toString();
          modelAgentSearch.user_image = jsonArray[i]["user_image"].toString();
          modelAgentSearch.business_user_name =
              jsonArray[i]["business_user_name"].toString();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.user_id = jsonArray[i]["user_id"].toString();
          modelAgentSearch.business_id = jsonArray[i]["business_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
           var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inSeconds;
                      modelAgentSearch.timedelay = difference.toString()+" seconds ago";
                      if(difference>60){
                        var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inMinutes;
                        modelAgentSearch.timedelay = difference.toString()+ " minutes ago";

                        if(difference>60){
                          var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inHours;
                          modelAgentSearch.timedelay = difference.toString()+" hours ago";
                          if(difference > 24){
                            modelAgentSearch.timedelay = modelAgentSearch.created_at.toString().substring(0,10);
                          }
                        }
                      }

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.person_name.toString());

          getHostSpotList.add(modelAgentSearch);

          setState(() {});
        }

        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Please try later")));
        });
      }
    }
  }

  Future<dynamic> addHotspotReviewApi(String message, [String? sec = '307']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("business_idPrint: " + sec.toString());
    print("message Print: " + reviewController.text.toString());

    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.ADDHOTSPOT_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": sec != "" ? sec : "307",
          "message": reviewController.text
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
          isloading = false;
        });

        getHostSpotList.clear();
        getHotspotApi();
        reviewController.clear();
        reviewController.text.toString() == "";
        

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));

        // getHotspotApi();
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

  Future<dynamic> replyOnHotspotReviewApi(
      String review_id, String messageText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.COMMUNITYREPLYONREVIEW_URL,
        ),
        body: {
          "user_id": id.toString(),
          "review_id": review_id,
          "reply_id": "0",
          "type": "HOTSPOT",
          "message": messageText
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
          isloading = false;
        });
       

         ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));

       
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

  Future<dynamic> getallBusinessDataApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(Uri.parse(RestDatasource.GETALLBUSINESS_URL));

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
          GetAllBusiness modelAgentSearch = new GetAllBusiness();
          modelAgentSearch.business_id = jsonArray[i]["business_id"].toString();
          modelAgentSearch.business_name =
              jsonArray[i]["business_name"].toString();

          print("id: " + modelAgentSearch.business_id.toString());
          print("Bussiness: " + modelAgentSearch.business_name.toString());

          getAllBusinessList.add(modelAgentSearch);

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

  Future<dynamic> getHotspotApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(Uri.parse(RestDatasource.GETHOTSPOT_URL));

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

      final date2 = DateTime.now();

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          GetHotSpotClass modelAgentSearch = new GetHotSpotClass();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.person_name = jsonArray[i]["person_name"].toString();
          modelAgentSearch.user_image = jsonArray[i]["user_image"].toString();
          modelAgentSearch.business_user_name =
              jsonArray[i]["business_user_name"].toString();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.user_id = jsonArray[i]["user_id"].toString();
          modelAgentSearch.business_id = jsonArray[i]["business_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();


           var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inSeconds;
                      modelAgentSearch.timedelay = difference.toString()+" seconds ago";
                      if(difference>60){
                        var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inMinutes;
                        modelAgentSearch.timedelay = difference.toString()+ " minutes ago";

                        if(difference>60){
                          var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inHours;
                          modelAgentSearch.timedelay = difference.toString()+" hours ago";
                          if(difference > 24){
                            modelAgentSearch.timedelay = modelAgentSearch.created_at.toString().substring(0,10);
                          }
                        }
                      }

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.person_name.toString());

          getHostSpotList.add(modelAgentSearch);

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

  TextFormField buildMessageFormField() {
    return TextFormField(
      controller: reviewController,
      onChanged: (val) {
        selectedvalue = val.toString();

          if (val.toString().substring(val.toString().length - 1) == "@") {
          print("Hello: " + getAllBusinessList.length.toString());

          //  _showOverlay(context);
          SelectDialog.showModal<GetAllBusiness>(
            context,
            label: " Please select a business",
            titleStyle: TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600, fontSize: 16.sp),
           
            items: getAllBusinessList,
            showSearchBox: true,
            searchBoxDecoration: InputDecoration(
              hintText: " Search Business...",
              contentPadding: EdgeInsets.all(8)
              
            ),
            // onFind: ,
            itemBuilder:
                (BuildContext context, GetAllBusiness item, bool isSelected) {
              return Container(
                decoration: !isSelected
                    ? null
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                child: InkWell(
                  onTap: () {
                    print("lendth: " + getAllBusinessList.length.toString());
                    selectedId = item.business_id;

                    print("id selected" + selectedId.toString());

                    selectedName = item.business_name.toString();
                    reviewController.text = selectedvalue + selectedName;

                    //   serviceController.text = "";

                    // isLoading = true;
                    //  personalInfoPresenter.getSubCat(catId.toString());
                    Navigator.of(context, rootNavigator: true).pop();
                    reviewController.selection = TextSelection.fromPosition(
                        TextPosition(offset: reviewController.text.length));
                  },
                  child: ListTile(
                    leading: item.business_name == "null"
                        ? null
                        : Text(
                            item.business_name.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                    selected: isSelected,
                  ),
                ),
              );
            },
          );
        }



       
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        suffixIcon: 
        Visibility(
          visible: reviewController.text.toString()=="" || reviewController.text.toString()== "null"?true:false,
          child: InkWell(
              onTap: () {

                 var mesage  = reviewController.text.toString();


                if (mesage == "" || mesage == "null") {
                  ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Please write message")));

                } else {
                  addHotspotReviewApi(reviewController.text.toString(), selectedId.toString());
                }


                reviewController.text.toString() == "";





              },
              child: Icon(Icons.send, size: 9.w, color: Colors.white)),
        ),
        fillColor: kPrimaryColor, filled: true,
        //filled: true,

        hintText: "Leave a message...",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 2.0,
          ),
        ),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  void _showOverlay(BuildContext context) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      // You can return any widget you like here
      // to be displayed on the Overlay
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.2,
        top: MediaQuery.of(context).size.height * 0.3,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                color: Colors.white,
                height: 25.h,
                width: double.infinity,
                child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: getAllBusinessList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // overlayEntry.remove();
                      },
                      child: Text(
                        getAllBusinessList[index].business_name.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11.sp,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Positioned(
              //   top: MediaQuery.of(context).size.height * 0.13,
              //   left: MediaQuery.of(context).size.width * 0.13,
              //   child: Row(
              //     children: [
              //       Material(
              //         color: Colors.transparent,
              //         child: Text(
              //           'This is a button!',
              //           style: TextStyle(
              //               fontSize: MediaQuery.of(context).size.height * 0.03,
              //               color: Colors.green),
              //         ),
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.18,
              //       ),
              //       GestureDetector(
              //         onTap: () {

              //           // When the icon is pressed the OverlayEntry
              //           // is removed from Overlay
              //          // overlayEntry.remove();
              //         },
              //         child: Icon(Icons.close,
              //             color: Colors.green,
              //             size: MediaQuery.of(context).size.height * 0.025),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      );
    });

    // Inserting the OverlayEntry into the Overlay
    overlayState!.insert(overlayEntry);
  }
}

class GetHotSpotClass {
  var person_name = "";
  var user_image = "";
  var business_user_name = "";
  var id = "";
  var user_id = "";
  var business_id = "";
  var message = "";
  var created_at = "";
  var messageText = "";
  var timedelay = "Secconds";
}

class GetAllBusiness {
  var business_id = "";
  var business_name = "";
}

class SearchSurffixIcon extends StatelessWidget {
  const SearchSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        20,
        20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 28,
        width: 12,
        color: kPrimaryColor,
      ),
    );
  }
}


