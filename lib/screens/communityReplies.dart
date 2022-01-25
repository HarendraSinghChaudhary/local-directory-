import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/components/slider_image.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotspot.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:wemarkthespot/screens/testingsheet.dart';
import 'package:wemarkthespot/services/api_client.dart';

import '../main.dart';
import 'package:path/path.dart' as path;

class CommunityReplies extends StatefulWidget {
  var review_id, image, username, message, buisness_id;

  CommunityReplies(
      {required this.review_id,
      required this.image,
      required this.username,
      required this.message,
      required this.buisness_id});

  @override
  _CommunityRepliesState createState() => _CommunityRepliesState();
}

class _CommunityRepliesState extends State<CommunityReplies> {
  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";
  TextEditingController messageController = new TextEditingController();

  List<GETREPLYONCOMMUNITY> getReplyOnCommunityList = [];
  bool isloading = false;
  ScrollController _controller = new ScrollController();
  bool viewVisible = false;
  var image_video_status = "0";
  File? file;
  String base64Image = "";
  String fileName = "";

  var tabOne = "";
  var selectedIndex = -1;
  List<Asset> images = [];
  List<File> fileList = [];

  @override
  void initState() {
    getReplyOnCommunityApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ID: " + widget.review_id.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Replies",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            controller: _controller,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Card(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.image.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage: NetworkImage(
                                    widget.image.toString(),
                                  ),
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage:
                                      AssetImage("assets/images/usericon.png"),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage:
                                      AssetImage("assets/images/usericon.png"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.9.w,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          //"Person Name",
                                          widget.username.toString() != "null"
                                              ? widget.username.toString()
                                              : "User Name",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: kCyanColor,
                                              fontFamily: "Segoepr"),
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
                                      //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",

                                      widget.message.toString() != "null"
                                          ? widget.message.toString()
                                          : "",
                                      style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                          fontSize: 10.2.sp,
                                          color: Colors.black,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  SizedBox(
                                    height: 0.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: getReplyOnCommunityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Card(
                              elevation: 0,
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.w)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                getReplyOnCommunityList[index]
                                                    .userProfile!
                                                    .image
                                                    .toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 6.5.w,
                                              backgroundImage: NetworkImage(
                                                  getReplyOnCommunityList[index]
                                                      .userProfile!
                                                      .image
                                                      .toString()),
                                            ),
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                              radius: 6.5.w,
                                              backgroundImage: AssetImage(
                                                  "assets/images/usericon.png"),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              radius: 6.5.w,
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
                                              Container(
                                                width: 74.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      //"Person Name",
                                                      getReplyOnCommunityList[
                                                                      index]
                                                                  .userProfile!
                                                                  .name
                                                                  .toString() !=
                                                              "null"
                                                          ? getReplyOnCommunityList[
                                                                  index]
                                                              .userProfile!
                                                              .name
                                                              .toString()
                                                          : "User Name",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: kCyanColor,
                                                          fontFamily:
                                                              "Segoepr"),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 3.w),
                                                      child: Text(
                                                        getReplyOnCommunityList[
                                                                index]
                                                            .timedelay
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 10,
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
                                                  //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",

                                                  getReplyOnCommunityList[index]
                                                              .message
                                                              .toString() !=
                                                          "null"
                                                      ? getReplyOnCommunityList[
                                                              index]
                                                          .message
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      //overflow: TextOverflow.ellipsis,
                                                      fontSize: 10.2.sp,
                                                      color: Colors.black,
                                                      fontFamily: 'Roboto'),
                                                ),
                                              ),
                                         
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                       SizedBox(
                                                height: 1.h,
                                              ),
                                              getReplyOnCommunityList[index]
                                                          .video_image_status
                                                          .toString() ==
                                                      "2"
                                                  ? SizedBox(
                                                      height: 200,
                                                      child: VideoItems(
                                                        videoPlayerController:
                                                            VideoPlayerController.network(
                                                                getReplyOnCommunityList[
                                                                        index]
                                                                    .image[0]),
                                                      ))
                                                  : Container(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                              getReplyOnCommunityList[index]
                                                          .video_image_status
                                                          .toString() ==
                                                      "1"
                                                  ? SizedBox(
                                                      height: 200,
                                                      child: HotspotImageSlider(
                                                          items:
                                                              getReplyOnCommunityList[
                                                                      index]
                                                                  .image),
                                                    )
                                                  : Container(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Container(
                                                width: 74.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    getReplyOnCommunityList[
                                                                index]
                                                            .viewV
                                                        ? InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                getReplyOnCommunityList[
                                                                            index]
                                                                        .viewV =
                                                                    false;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Hide Replies",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Roboto"),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              if(  getReplyOnCommunityList[
                                                              index].childrenList !=null){
                                                                if(getReplyOnCommunityList[
                                                                index].childrenList.length>0){
                                                                  setState(() {
                                                                    getReplyOnCommunityList[
                                                                    index]
                                                                        .viewV = true;
                                                                  });
                                                                }
                                                              }

                                                            },
                                                            child: Text(
                                                              "View Replies",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Roboto"),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.w),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            viewVisible = true;
                                                            selectedIndex =
                                                                index;

                                                            tabOne =
                                                                getReplyOnCommunityList[
                                                                        index]
                                                                    .id
                                                                    .toString();
                                                          });
                                                        },
                                                        child: Text(
                                                          "Reply",
                                                          style: TextStyle(
                                                              fontSize: 11.sp,
                                                              color:
                                                                  kPrimaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Roboto"),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                  replyWidget(index),
                                ],
                              )),
                          SizedBox(
                            height: 2.h,
                          ),
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
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: viewVisible,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: file == null ? false : true,
                child: file != null
                    ? image_video_status == "1"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: kBackgroundColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 2.h,
                                  ),

                                  Container(
                                    height: 8.h,
                                    width: 80.w,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: _controller,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: fileList.length == 0
                                          ? 0
                                          : fileList.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 9.h,
                                                  width: 9.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.w),
                                                      image: DecorationImage(
                                                          image: FileImage(
                                                              fileList[i]),
                                                          fit: BoxFit.fill)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 2.0, left: 14.w),
                                                  child: Container(
                                                    height: 2.h,
                                                    width: 2.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () {
                                                          fileList.removeAt(i);
                                                          images.removeAt(i);
                                                          if (fileList.length == 0) {

                                                            file = null;
                                                            fileName = "";
                                                            fileList.clear();
                                                            images.clear();
                                                            image_video_status = "0";

                                                          }
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/icons/cross.svg",
                                                          width: 8,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),

                                  // Flexible(
                                  //   flex: 9,
                                  //   child: Center(
                                  //     child: Container(
                                  //         height: 150,
                                  //         child: Image.file(
                                  //           file!,
                                  //           height: 80,
                                  //         )),
                                  //   ),
                                  // ),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  file = null;
                                                  fileName = "";
                                                  base64Image = "";
                                                  image_video_status = "0";
                                                  currentPath = "";
                                                  fileList.clear();
                                                  images.clear();
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: SvgPicture.asset(
                                                  "assets/icons/cross.svg",
                                                  color: Colors.white,
                                                  width: 4.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(flex: 2, child: Container())
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: kBackgroundColor),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              file = null;
                                              fileName = "";
                                              base64Image = "";
                                              image_video_status = "0";
                                              currentPath = "";
                                              fileList.clear();
                                              images.clear();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SvgPicture.asset(
                                              "assets/icons/cross.svg",
                                              color: Colors.white,
                                              width: 4.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        fileName,
                                        maxLines: 3,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : Container(
                        color: Colors.white,
                        height: 100,
                      )),
            Container(
              width: double.infinity,
              height: 8.h,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      file = null;
                      fileName = "";
                      base64Image = "";
                      image_video_status = "0";
                      currentPath = "";
                      fileList.clear();
                      images.clear();
                      setState(() {});
                      getFileDialog();
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 9.w,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  SizedBox(
                    width: 74.w,
                    height: 6.h,
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      maxLines: 1,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 0.h),
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        fillColor: kCyanColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: kCyanColor)),
                        hintText: "Type..",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  InkWell(
                      onTap: () {
                        if (messageController.text != "" &&
                            messageController.text != "null") {
                          replyOnHotspotReplyApi(tabOne.toString(),
                              messageController.text.toString());

                          setState(() {
                            messageController.text = "";

                            viewVisible = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter reply")));
                        }
                        messageController.clear();
                      },
                      child: SvgPicture.asset(
                        "assets/icons/send1.svg",
                        width: 8.w,
                        color: kPrimaryColor,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getReplyOnCommunityApi() async {
    print("Widget Id " + widget.review_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(
      Uri.parse(RestDatasource.GETREPLYONCOMMUNITYREVIEW_URL +
          // "3"
          widget.review_id.toString() +
          "&type=" +
          "REVIEW"),
    );
    String msg = "";
    var jsonArray;
    var jsonRes;
    var jsonErray;
    var childDataOne;
    var childrenOne;
    var childDataTwo;
    var childrenUserDataTwo;
    var childDataThree;
    var childrenUserDataThree;

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
      getReplyOnCommunityList.clear();
      if (jsonRes["status"].toString() == "true") {
        final date2 = DateTime.now();
        for (var i = 0; i < jsonArray.length; i++) {
          GETREPLYONCOMMUNITY modelAgentSearch = new GETREPLYONCOMMUNITY();

          // NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
          //modelAgentSearch.hour = jsonArray[i]["hour"];
          modelAgentSearch.review_id = jsonArray[i]["review_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.video_image_status =
              jsonArray[i]["video_image_status"].toString();
          modelAgentSearch.image = jsonArray[i]["image"];
          var difference = date2
              .difference(DateTime.parse(modelAgentSearch.created_at))
              .inSeconds;
          modelAgentSearch.timedelay = difference.toString() + " seconds ago";
          if (difference > 60) {
            var difference = date2
                .difference(DateTime.parse(modelAgentSearch.created_at))
                .inMinutes;
            modelAgentSearch.timedelay = difference.toString() + " minutes ago";

            if (difference > 60) {
              var difference = date2
                  .difference(DateTime.parse(modelAgentSearch.created_at))
                  .inHours;
              modelAgentSearch.timedelay = difference.toString() + " hours ago";
              if (difference > 24) {
                modelAgentSearch.timedelay =
                    modelAgentSearch.created_at.toString().substring(0, 10);
              }
            }
          }
          print("difference is " + modelAgentSearch.timedelay.toString());
          jsonErray = jsonRes['data'][i]['user'];
          UserData modelcheckIn = new UserData();

          modelcheckIn.id = jsonErray["id"].toString();
          modelcheckIn.name = jsonErray["name"].toString();
          modelcheckIn.image = jsonErray["image"].toString();

          print("name: aw  " + modelcheckIn.name.toString());

          modelAgentSearch.userProfile = modelcheckIn;

          childDataOne = jsonRes['data'][i]['children'];

          if (jsonRes['data'][i]['children'] != null) {
            if (childDataOne.length > 0) {
              for (var j = 0; j < childDataOne.length; j++) {
                GETREPLYONCOMMUNITY childModelOne = GETREPLYONCOMMUNITY();

                childModelOne.id = childDataOne[j]["id"].toString();
                childModelOne.created_at =
                    childDataOne[j]["created_at"].toString();
                childModelOne.review_id =
                    childDataOne[j]["review_id"].toString();
                childModelOne.message = childDataOne[j]["message"].toString();
                childModelOne.image = childDataOne[j]["image"];
                childModelOne.video_image_status =
                    childDataOne[j]["video_image_status"].toString();

                var difference = date2
                    .difference(DateTime.parse(childDataOne[j]["created_at"]))
                    .inSeconds;
                childModelOne.timedelay =
                    difference.toString() + " seconds ago";
                if (difference > 60) {
                  var difference = date2
                      .difference(DateTime.parse(childDataOne[j]["created_at"]))
                      .inMinutes;
                  childModelOne.timedelay =
                      difference.toString() + " minutes ago";

                  if (difference > 60) {
                    var difference = date2
                        .difference(
                            DateTime.parse(childDataOne[j]["created_at"]))
                        .inHours;
                    childModelOne.timedelay =
                        difference.toString() + " hours ago";
                    if (difference > 24) {
                      childModelOne.timedelay =
                          childModelOne.created_at.toString().substring(0, 10);
                    }
                  }
                }
                childrenOne = childDataOne[j]['user'];
                UserData childrenDataOneModel = UserData();
                childrenDataOneModel.id = childrenOne['id'].toString();
                childrenDataOneModel.name = childrenOne['name'].toString();
                childrenDataOneModel.image = childrenOne['image'].toString();

                childModelOne.userProfile = childrenDataOneModel;
                print("namechild: " + childrenDataOneModel.name.toString());

                modelAgentSearch.childrenList.add(childModelOne);

                childDataTwo = childDataOne[j]['children'];

                if (childDataOne[j]['children'] != null) {
                  if (childDataTwo.length > 0) {
                    for (var k = 0; k < childDataTwo.length; k++) {
                      GETREPLYONCOMMUNITY childrenModelTwo =
                          GETREPLYONCOMMUNITY();

                      childrenModelTwo.id = childDataTwo[k]["id"].toString();
                      childrenModelTwo.created_at =
                          childDataTwo[k]["created_at"].toString();
                      childrenModelTwo.review_id =
                          childDataTwo[k]["review_id"].toString();
                      childrenModelTwo.message =
                          childDataTwo[k]["message"].toString();
                      childrenModelTwo.image = childDataTwo[k]["image"];
                      childrenModelTwo.video_image_status =
                          childDataTwo[k]["video_image_status"].toString();

                      var difference = date2
                          .difference(
                              DateTime.parse(childDataTwo[k]["created_at"]))
                          .inSeconds;
                      childrenModelTwo.timedelay =
                          difference.toString() + " seconds ago";
                      if (difference > 60) {
                        var difference = date2
                            .difference(
                                DateTime.parse(childDataTwo[k]["created_at"]))
                            .inMinutes;
                        childrenModelTwo.timedelay =
                            difference.toString() + " minutes ago";

                        if (difference > 60) {
                          var difference = date2
                              .difference(
                                  DateTime.parse(childDataTwo[k]["created_at"]))
                              .inHours;
                          childrenModelTwo.timedelay =
                              difference.toString() + " hours ago";
                          if (difference > 24) {
                            childrenModelTwo.timedelay = childrenModelTwo
                                .created_at
                                .toString()
                                .substring(0, 10);
                          }
                        }
                      }
                      childrenUserDataTwo = childDataTwo[k]['user'];

                      UserData childrenDataTwoModel = UserData();
                      childrenDataTwoModel.id =
                          childrenUserDataTwo['id'].toString();
                      childrenDataTwoModel.name =
                          childrenUserDataTwo['name'].toString();
                      childrenDataTwoModel.image =
                          childrenUserDataTwo['image'].toString();

                      childrenModelTwo.userProfile = childrenDataTwoModel;
                      print("id....." + childDataTwo[k]["id"].toString());

                      print("namechild  //: " +
                          childrenDataTwoModel.id.toString());

                      modelAgentSearch.childrenList[j].childrenList
                          .add(childrenModelTwo);

                      childDataThree = childDataTwo[k]['children'];

                      if (childDataTwo[k]['children'] != null) {
                        if (childDataThree.length > 0) {
                          for (var l = 0; l < childDataThree.length; l++) {
                            GETREPLYONCOMMUNITY childrenModelThree =
                                GETREPLYONCOMMUNITY();

                            childrenModelThree.id =
                                childDataThree[l]["id"].toString();
                            childrenModelThree.created_at =
                                childDataThree[l]["created_at"].toString();
                            childrenModelThree.review_id =
                                childDataThree[l]["review_id"].toString();
                            childrenModelThree.message =
                                childDataThree[l]["message"].toString();

                            childrenModelThree.image =
                                childDataThree[l]["image"];

                            childrenModelThree.video_image_status =
                                childDataThree[l]["video_image_status"]
                                    .toString();

                            var difference = date2
                                .difference(DateTime.parse(
                                    childDataThree[l]["created_at"]))
                                .inSeconds;
                            childrenModelThree.timedelay =
                                difference.toString() + " seconds ago";
                            if (difference > 60) {
                              var difference = date2
                                  .difference(DateTime.parse(
                                      childDataThree[l]["created_at"]))
                                  .inMinutes;
                              childrenModelThree.timedelay =
                                  difference.toString() + " minutes ago";

                              if (difference > 60) {
                                var difference = date2
                                    .difference(DateTime.parse(
                                        childDataThree[l]["created_at"]))
                                    .inHours;
                                childrenModelThree.timedelay =
                                    difference.toString() + " hours ago";
                                if (difference > 24) {
                                  childrenModelThree.timedelay =
                                      childrenModelThree.created_at
                                          .toString()
                                          .substring(0, 10);
                                }
                              }
                            }
                            childrenUserDataThree = childDataThree[l]['user'];

                            UserData childrenDataThreeModel = UserData();
                            childrenDataThreeModel.id =
                                childrenUserDataThree['id'].toString();
                            childrenDataThreeModel.name =
                                childrenUserDataThree['name'].toString();
                            childrenDataThreeModel.image =
                                childrenUserDataThree['image'].toString();

                            childrenModelThree.userProfile =
                                childrenDataThreeModel;
                            print("id Three....." +
                                childDataThree[l]["id"].toString());

                            print("namechild  Three //: " +
                                childrenDataThreeModel.id.toString());

                            modelAgentSearch
                                .childrenList[j].childrenList[k].childrenList
                                .add(childrenModelThree);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          getReplyOnCommunityList.add(modelAgentSearch);

          setState(() {
            if (selectedIndex > -1) {
              getReplyOnCommunityList[selectedIndex].viewV = true;
            }
          });
        }

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

  getFileDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: SingleChildScrollView(
                child: SizedBox(
              height: 25.h,
              width: 95.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          image_video_status = "0";
                          file = null;
                          fileName = "";
                          currentPath = "";
                          fileList.clear();
                          images.clear();
                        },
                        child: SvgPicture.asset(
                          "assets/icons/cross.svg",
                          color: Colors.white,
                          width: 4.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "What do you want to upload?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        // fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"
                        //fontFamily: "Segoepr"
                        ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  DefaultButton(
                      width: 35.w,
                      height: 6.h,
                      text: "Image",
                      press: () {
                        if (image_video_status == "2") {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Either image or video can be post at a time'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                          );
                        } else {
                          pickImagess();
                          //getCheckInImage();

                        }
                      }),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  DefaultButton(
                      width: 35.w,
                      height: 6.h,
                      text: "Video",
                      press: () async {
                        if (image_video_status == "1") {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Either image or video can be post at a time'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                          );
                        } else {
                          File file1;

                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                          );
                          if (result != null) {
                            file1 = File(result.files.single.path!);
                           await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return TrimmerView(file1);
                              }),
                            );

                            Navigator.of(context, rootNavigator: true).pop();
                            if (currentPath != "") {
                              file = File(currentPath.toString());
                              fileName = path.basename(file!.path);
                              print("Filename " + fileName.toString());
                              image_video_status = "2";
                              if (fileName == "" || fileName == null) {
                                fileName = "File:- ";
                                viewVisible = true;
                              } else {
                                fileName = "File:- " + fileName;
                                viewVisible = true;
                              }
                              setState(() {});
                            } else {

                              file = null;
                              fileName = "";
                              image_video_status = "0";
                              if (fileName == "" || fileName == null) {
                                fileName = "File:- ";
                                viewVisible = true;
                              } else {
                                fileName = "File:- " + fileName;
                                viewVisible = true;
                              }
                              setState(() {});
                            }



                          }
                        }
                      })
                ],
              ),
            )));
      },
    );
  }

  ListView replyWidget(int i) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: getReplyOnCommunityList[i].childrenList.length,
      itemBuilder: (BuildContext context, int index) {
        return Visibility(
          visible: getReplyOnCommunityList[i].viewV,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.w)),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 2.w, top: 1.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h, left: 1.w),
                            child: CachedNetworkImage(
                              imageUrl: getReplyOnCommunityList[i]
                                  .childrenList[index]
                                  .userProfile!
                                  .image
                                  .toString(),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 6.w,
                                backgroundImage: NetworkImage(
                                    getReplyOnCommunityList[i]
                                        .childrenList[index]
                                        .userProfile!
                                        .image
                                        .toString()),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 6.w,
                                backgroundImage:
                                    AssetImage("assets/images/usericon.png"),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 6.w,
                                backgroundImage:
                                    AssetImage("assets/images/usericon.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 74.w,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 74.w,
                                        child: Text(
                                          // "Person Name",

                                          getReplyOnCommunityList[i]
                                              .childrenList[index]
                                              .userProfile!
                                              .name
                                              .toString(),

                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kCyanColor,
                                              fontFamily: "Segoepr"),
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
                                    //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                    getReplyOnCommunityList[i]
                                        .childrenList[index]
                                        .message
                                        .toString(),

                                    style: TextStyle(
                                        //overflow: TextOverflow.ellipsis,
                                        fontSize: 8.5.sp,
                                        color: Colors.black87,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      getReplyOnCommunityList[i]
                                  .childrenList[index]
                                  .video_image_status
                                  .toString() ==
                              "2"
                          ? SizedBox(
                              height: 200,
                              child: VideoItems(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        getReplyOnCommunityList[i]
                                            .childrenList[index]
                                            .image[0]),
                              )

                              //  VideoWidget(
                              //   url: getReplyOnHotspotList[i]
                              //       .childrenList[index]
                              //       .image,
                              //   play: true,
                              // ),
                              )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                      getReplyOnCommunityList[i]
                                  .childrenList[index]
                                  .video_image_status
                                  .toString() ==
                              "1"
                          ? SizedBox(
                              height: 200,
                              child: HotspotImageSlider(
                                items: getReplyOnCommunityList[i]
                                    .childrenList[index]
                                    .image,
                              ),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        width: 74.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // "2m ago",
                              getReplyOnCommunityList[i]
                                  .childrenList[index]
                                  .timedelay
                                  .toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: kPrimaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {

                                    viewVisible = true;
                                    selectedIndex = index;
                                    tabOne = getReplyOnCommunityList[i]
                                        .childrenList[index]
                                        .id
                                        .toString();

                                  });
                                },
                                child: Text(
                                  "Reply",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: kPrimaryColor,
                                      fontFamily: "Roboto"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: getReplyOnCommunityList[i]
                      .childrenList[index]
                      .childrenList
                      .length,
                  itemBuilder: (BuildContext context, int k) {
                    return Card(
                        elevation: 0,
                        margin: EdgeInsets.symmetric(horizontal: 0.w),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 8.w,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 6.h, left: 0.w),
                                        child: CircleAvatar(
                                          radius: 4.w,
                                          backgroundImage: NetworkImage(
                                              getReplyOnCommunityList[i]
                                                  .childrenList[index]
                                                  .childrenList[k]
                                                  .userProfile!
                                                  .image
                                                  .toString()),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 74.w,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    //"Person Name @ Bar Name",
                                                    getReplyOnCommunityList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .userProfile!
                                                        .name
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: kCyanColor,
                                                        fontFamily: "Segoepr"),
                                                  ),
                                                  SizedBox(
                                                    width: 12.w,
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
                                                //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.",
                                                getReplyOnCommunityList[i]
                                                    .childrenList[index]
                                                    .childrenList[k]
                                                    .message
                                                    .toString(),
                                                style: TextStyle(
                                                    //overflow: TextOverflow.ellipsis,
                                                    fontSize: 8.5.sp,
                                                    color: Colors.black87,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  getReplyOnCommunityList[i]
                                              .childrenList[index]
                                              .childrenList[k]
                                              .video_image_status
                                              .toString() ==
                                          "2"
                                      ? SizedBox(
                                          height: 200,
                                          width: 35.h,
                                          child: VideoItems(
                                            videoPlayerController:
                                                VideoPlayerController.network(
                                                    getReplyOnCommunityList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .image[0]),
                                          ))
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                  getReplyOnCommunityList[i]
                                              .childrenList[index]
                                              .childrenList[k]
                                              .video_image_status
                                              .toString() ==
                                          "1"
                                      ? SizedBox(
                                          height: 200,
                                          child: HotspotImageSlider(
                                              items: getReplyOnCommunityList[i]
                                                  .childrenList[index]
                                                  .childrenList[k]
                                                  .image),
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          //"2m ago",
                                          getReplyOnCommunityList[i]
                                              .childrenList[index]
                                              .childrenList[k]
                                              .timedelay
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                viewVisible = true;
                                                selectedIndex = index;
                                                tabOne =
                                                    getReplyOnCommunityList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .id
                                                        .toString();
                                              });
                                            },
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: kPrimaryColor,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              itemCount: getReplyOnCommunityList[i]
                                  .childrenList[index]
                                  .childrenList[k]
                                  .childrenList
                                  .length,
                              itemBuilder: (BuildContext context, int j) {
                                return Card(
                                    elevation: 0,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.w),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 6.h, left: 0.w),
                                                  child: CircleAvatar(
                                                    radius: 4.w,
                                                    backgroundImage:
                                                        // AssetImage("assets/images/loc.png"),
                                                        NetworkImage(
                                                      getReplyOnCommunityList[i]
                                                          .childrenList[index]
                                                          .childrenList[k]
                                                          .childrenList[j]
                                                          .userProfile!
                                                          .image
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Flexible(
                                                flex: 8,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 70.w,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              //"Person Name @ Bar Name",
                                                              getReplyOnCommunityList[i]
                                                                  .childrenList[
                                                                      index]
                                                                  .childrenList[
                                                                      k]
                                                                  .childrenList[
                                                                      j]
                                                                  .userProfile!
                                                                  .name
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color:
                                                                      kCyanColor,
                                                                  fontFamily:
                                                                      "Segoepr"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.1.h,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 0.w),
                                                        child: Container(
                                                          width: 70.w,
                                                          child: Text(
                                                            // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                                                            getReplyOnCommunityList[
                                                                    i]
                                                                .childrenList[
                                                                    index]
                                                                .childrenList[k]
                                                                .childrenList[j]
                                                                .message
                                                                .toString(),
                                                            style: TextStyle(
                                                                //overflow: TextOverflow.ellipsis,
                                                                fontSize:
                                                                    8.5.sp,
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    'Roboto'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          getReplyOnCommunityList[i]
                                                      .childrenList[index]
                                                      .childrenList[k]
                                                      .childrenList[j]
                                                      .video_image_status
                                                      .toString() ==
                                                  "2"
                                              ? SizedBox(
                                                  height: 200,
                                                  width: 35.h,
                                                  child: VideoItems(
                                                    videoPlayerController:
                                                        VideoPlayerController.network(
                                                            getReplyOnCommunityList[
                                                                    i]
                                                                .childrenList[
                                                                    index]
                                                                .childrenList[k]
                                                                .childrenList[j]
                                                                .image[0]),
                                                  ))
                                              : Container(),
                                          getReplyOnCommunityList[i]
                                                      .childrenList[index]
                                                      .childrenList[k]
                                                      .childrenList[j]
                                                      .video_image_status
                                                      .toString() ==
                                                  "1"
                                              ? SizedBox(
                                                  height: 200,
                                                  child: HotspotImageSlider(
                                                    items:
                                                        getReplyOnCommunityList[
                                                                i]
                                                            .childrenList[index]
                                                            .childrenList[k]
                                                            .childrenList[j]
                                                            .image,
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                            width: 74.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  //"2m ago",
                                                  getReplyOnCommunityList[i]
                                                      .childrenList[index]
                                                      .childrenList[k]
                                                      .childrenList[j]
                                                      .timedelay
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 6.w),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Text(
                                                        "Reply",
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color:
                                                                kPrimaryColor,
                                                            fontFamily:
                                                                "Roboto"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ));
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> replyOnHotspotReplyApi(
      String reply_id, String messageText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    print("id: " + id.toString());
    print("review_id: " + widget.review_id.toString());
    print("reply_id: " + reply_id.toString());
    print("type: " + "REVIEW");
    print("message: " + messageText.toString());

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.COMMUNITYREPLYONREVIEW_URL,
      ),
    );
    request.fields["user_id"] = id.toString();
    request.fields["review_id"] = widget.review_id.toString();
    request.fields["reply_id"] = reply_id;
    request.fields["type"] = "REVIEW";
    request.fields["message"] = messageText;
    request.fields["video_image_status"] = image_video_status;
    request.fields["business_id"] = widget.buisness_id;

    if (image_video_status == "2") {
      request.files
          .add(await http.MultipartFile.fromPath("image[]", file!.path));
    } else if (image_video_status == "1") {
      images.forEach((element) async {
        var path = await FlutterAbsolutePath.getAbsolutePath(
            element.identifier.toString());
        print("ImagePath " + path.toString());
        request.files.add(http.MultipartFile(
            'image[]',
            File(path.toString()).readAsBytes().asStream(),
            File(path.toString()).lengthSync(),
            filename: path.toString().split("/").last));
      });
    }
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      file = null;
      fileName = "";
      base64Image = "";
      image_video_status = "0";
      currentPath = "";
      fileList.clear();
      images.clear();
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);
      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });

        getReplyOnCommunityApi();

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

  Future<void> pickImagess() async {
    await pickImages().then((value) {
      images = value;
      print("lengthhhhhh " + images.length.toString() + "*");
    });
    if (images.length > 0) {
      image_video_status = "1";
      images.forEach((element) async {
        var path = await FlutterAbsolutePath.getAbsolutePath(
            element.identifier.toString());
        print("pathhh " + path.toString() + "*");

        file = File(path.toString());
        fileName = file!.path.split("/").last;
        fileList.add(file!);
        setState(() {

        });
      });
      Navigator.pop(context);

    } else {
      image_video_status = "0";
      images.clear();
    }

  }

  getFileDialogReply(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: SingleChildScrollView(
                child: SizedBox(
              height: 25.h,
              width: 95.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          file = null;
                          fileName = "";
                          currentPath = "";
                          images.clear();
                          fileList.clear();
                          file = null;
                          image_video_status = "0";
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: SvgPicture.asset(
                          "assets/icons/cross.svg",
                          color: Colors.white,
                          width: 4.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "What do you want to upload?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        // fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"
                        //fontFamily: "Segoepr"
                        ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  DefaultButton(
                      width: 35.w,
                      height: 6.h,
                      text: "Image",
                      press: () {
                        if (image_video_status == "2") {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Either image or video can be post at a time'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                          );
                        } else {
                          //getCheckInImage();

                          pickImagess();
                        }
                      }),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  DefaultButton(
                      width: 35.w,
                      height: 6.h,
                      text: "Video",
                      press: () async {
                        if (image_video_status == "1") {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Either image or video can be post at a time'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                          );
                        } else {
                          File file1;
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                          );
                          if (result != null) {
                            file1 = File(result.files.single.path!);


                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return TrimmerView(file!);
                              }),
                            );
                            Navigator.of(context, rootNavigator: true).pop();
                            if (currentPath != "") {
                              file = File(currentPath.toString());
                              fileName = path.basename(file!.path);
                              print("Filename " + fileName.toString());
                              image_video_status = "2";

                              if (fileName == "" || fileName == null) {
                                fileName = "File:- ";
                              } else {
                                fileName = "File:- " + fileName;
                              }
                              setState(() {});
                            } else {
                              file = null;
                              fileName = "";
                              image_video_status = "0";

                              if (fileName == "" || fileName == null) {
                                fileName = "File:- ";
                              } else {
                                fileName = "File:- " + fileName;
                              }
                              setState(() {});
                            }
                          }
                        }
                      })
                ],
              ),
            )));
      },
    );
  }
}

class GETREPLYONCOMMUNITY {
  UserData? userProfile;
  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";
  var hour;
  List<dynamic> image = [];
  var video_image_status = "";
  var timedelay = "Secconds";
  bool viewV = false;
  List<GETREPLYONCOMMUNITY> childrenList = [];

  var replyimage_video_status = "0";
  File? replyfile;

  var replyfileName = "";
  List<Asset> replyimages = [];
  List<File> replyfileList = [];
}

class UserData {
  var id = "";
  var name = "";
  var image = "";
}
