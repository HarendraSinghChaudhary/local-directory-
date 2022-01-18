// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/components/slider_image.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/main.dart';
import 'package:wemarkthespot/models/community_review_api_model.dart';
import 'package:wemarkthespot/screens/communityReplies.dart';
import 'package:path/path.dart' as path;

import 'package:wemarkthespot/screens/explore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:wemarkthespot/screens/testingsheet.dart';
import 'package:wemarkthespot/screens/video_player_widget.dart';
import 'package:wemarkthespot/services/api_client.dart';

class DetailBussiness extends StatefulWidget {
  NearBy nearBy;

  DetailBussiness({required this.nearBy});

  @override
  _DetailBussinessState createState() => _DetailBussinessState();
}

class _DetailBussinessState extends State<DetailBussiness> {
  var ivStatus = "";

  // String fire = "Fire";
  // String okOk = "OkOk";
  // String notCool = "Not Cool";

  var communityId = "";

  //var ratting = "";
  var name = "";
  var check = "";
  bool likeEnable = true;
  bool unlikeEnable = true;
  bool reportEnable = true;

  //var image = "";
  var review = "";
  var business_review_image = "";
  var business_review_image_status = "";
  var total_like = "";
  var total_dislike = "";
  var business_reviews_id = "";
  var replies_count = "";
  var clearFile = "";
  var videoLink = "";

  List<CommunityReviewAPI> communityReviewList = [];

  late VideoPlayerController _controllerr;

  @override
  void initState() {
    communityReviewApi();
    print("vi: " + videoLink.toString());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  double ratting = 0.0;
  double rattingcheckin = 0.0;

  TextEditingController reviewController = new TextEditingController();
  TextEditingController reviewController2 = new TextEditingController();
  TextEditingController rattingController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  String image = "";
  String base64Image = "";
  String fileName = "";
  String trimFileName = "";
  File? file;
  File? trimFile;
  bool isLoading = false;
  final picker = ImagePicker();
  bool isVisible = false;
  List<Asset> images = [];
  List<File> fileList = [];

  //get kPrimaryColor => null;

  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  ScrollController _controller = new ScrollController();
  var image_video_status = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
              child: SafeArea(
                  child: ListView(
            shrinkWrap: true,
            controller: _controller,
            children: [
              Column(
                children: [
                  Container(
                    height: 33.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 33.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      widget.nearBy.business_images.toString()),
                                  fit: BoxFit.fill)),
                        ),
                        Positioned(
                          left: 2.w,
                          top: 1.h,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              )),
                        ),
                        Positioned(
                          top: 2.h,
                          left: 85.w,
                          child: InkWell(
                            onTap: () {
                              var favv = widget.nearBy.fav.toString() == "1"
                                  ? "0"
                                  : "1";
                              setState(() {
                                widget.nearBy.fav = favv;
                              });

                              businessFavApi(widget.nearBy.id.toString(), favv);
                            },
                            child: widget.nearBy.fav.toString() == "1"
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //"Bar Name",
                              widget.nearBy.business_name.toString() != "null"
                                  ? widget.nearBy.business_name.toString()
                                  : "Business Name",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kCyanColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoepr"),
                            ),
                            Row(
                              children: [
                                Text(
                                  // "3.5",
                                  widget.nearBy.avgratting.toString() != "null"
                                      ? widget.nearBy.avgratting.toString()
                                      : "0",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500
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
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //"Bar",
                              widget.nearBy.category_name.toString() != "null"
                                  ? widget.nearBy.category_name.toString()
                                  : "",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kPrimaryColor,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"),
                            ),
                            Row(
                              children: [
                                Text(
                                  communityReviewList != null &&
                                          communityReviewList.length > 0
                                      ? communityReviewList.length.toString() +
                                          " Reviews "
                                      : "0 Reviews",
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
                                  widget.nearBy.user_count.toString() +
                                      " People",
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
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/location-.svg",
                                  color: kCyanColor,
                                  width: 4.w,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0.1.h),
                                  child: Container(
                                    width: 55.w,
                                    child: Text(
                                      //"1230 Roosvelt Road, Wichita",
                                      widget.nearBy.location.toString() !=
                                              "null"
                                          ? widget.nearBy.location.toString()
                                          : "",

                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              //Distance
                              "Distance: " +
                                  widget.nearBy.distance.toString() +
                                  " mi",
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"
                                  //fontFamily: "Segoepr"
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0XFF7A7A7A),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Center(
                          child: Text(
                            "Friday Night",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Segoepr"),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Happy Hours",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: kCyanColor,
                              fontFamily: "Roboto"),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Start Date: 12/08/2021",
                              style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"),
                            ),
                            Text(
                              "End Date: 14/08/2021",
                              style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"
                                  //fontFamily: "Segoepr"
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut placerat orci nulla. Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Tempor id eu nisl nunc mi ipsum faucibus. Fusce id velit ut tortor pretium. Massa ultricies mi quis hendrerit dolor magna eget. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed nisi. Sagittis eu volutpat odio facilisis mauris sit amet massa. Erat velit",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Color(0XFFCECECE),
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          ivStatus = "";
                          fileName = "";
                          file = null;

                          customDialog();
                        },
                        child: Container(
                          height: 7.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                              //color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12.w),
                              border: Border.all(color: kPrimaryColor)),
                          child: Center(
                            child: Text(
                              "Leave a Review",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: kPrimaryColor,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"
                                  //fontFamily: "Segoepr"
                                  ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ivStatus = "";
                          fileName = "";
                          file = null;

                          if (widget.nearBy.checkIn_status == "1") {
                            checkInDialog();
                          } else {
                            checkInApi();
                          }
                        },
                        child: Container(
                          height: 7.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12.w)),
                          child: Center(
                            child: Text(
                              widget.nearBy.checkIn_status == "1"
                                  ? "Check Out"
                                  : "Check In",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"
                                  //fontFamily: "Segoepr"
                                  ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              )
            ],
          ))),
          _buildDraggableScrollableSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet _buildDraggableScrollableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: kCyanColor,
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 1.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.w)),
                  ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  Text(
                    "COMMUNITY REVIEWS",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Segoepr"),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ),
              communityReviewList.length.toString() == "0" ||
                      communityReviewList.length.toString() == "null"
                  ? Padding(
                      padding: EdgeInsets.only(top: 13.h),
                      child: Center(
                          child: Image.asset("assets/images/nodata.jpg")),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: communityReviewList.length,
                      itemBuilder: (BuildContext context, int index) {
                        TextEditingController messageTextController =
                            new TextEditingController();
                        return
                            // communityReviewList.length == "0" ? Center(child: Text("Please type a message", style: TextStyle(color: Colors.white, fontSize: 20), ))
                            // :
                            Column(
                          children: [
                            Card(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.w)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 1.5.h, left: 5.w),
                                          child: Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    communityReviewList[index]
                                                        .image
                                                        .toString(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        CircleAvatar(
                                                  radius: 7.w,
                                                  backgroundImage: NetworkImage(
                                                      //user image
                                                      communityReviewList[index]
                                                          .image
                                                          .toString()),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  radius: 7.w,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/usericon.png"),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  radius: 7.w,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/usericon.png"),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    //"3.5",
                                                    communityReviewList[index]
                                                        .ratting
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w500
                                                        //fontFamily: "Segoepr"
                                                        ),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/star.svg",
                                                    color: kPrimaryColor,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // "Restaurant Name",

                                                communityReviewList[index]
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: kCyanColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Segoepr"),
                                              ),
                                              Container(
                                                  height: 6.h,
                                                  width: 65.w,
                                                  child: Text(
                                                    // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                                    communityReviewList[index]
                                                        .review
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.w500,
                                                        fontFamily: "Roboto"
                                                        //fontFamily: "Segoepr"
                                                        ),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    communityReviewList[index]
                                                .image_video_status
                                                .toString() ==
                                            "2"
                                        ? SizedBox(
                                            height: 200,
                                            child: VideoItems(
                                              videoPlayerController:
                                                  VideoPlayerController.network(
                                                      communityReviewList[index]
                                                          .business_review_image
                                                          .first),
                                            ))
                                        : communityReviewList[index]
                                                    .image_video_status
                                                    .toString() ==
                                                "1"
                                            ? Container(
                                                // height: 48.h,
                                                // width: double.infinity,
                                                child: HotspotImageSlider(
                                                items:
                                                    communityReviewList[index]
                                                        .business_review_image,
                                              ))
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return Container(
                                              child: InkWell(
                                                onTap: () {
                                                  if (likeEnable == true) {
                                                    if (communityReviewList[
                                                                index]
                                                            .like_status
                                                            .toString() ==
                                                        "1") {
                                                    } else {
                                                      likeApi(
                                                          communityReviewList[
                                                                  index]
                                                              .business_reviews_id
                                                              .toString(),
                                                          "1");
                                                    }
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/up.svg",
                                                      color: communityReviewList[
                                                                      index]
                                                                  .like_status
                                                                  .toString() ==
                                                              "1"
                                                          ? kPrimaryColor
                                                          : Colors.black,
                                                      width: 4.5.w,
                                                    ),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Text(
                                                      "Like(" +
                                                          communityReviewList[
                                                                  index]
                                                              .total_like
                                                              .toString() +
                                                          ")",
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: communityReviewList[
                                                                          index]
                                                                      .like_status
                                                                      .toString() ==
                                                                  "1"
                                                              ? kPrimaryColor
                                                              : Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                          Container(
                                            child: StatefulBuilder(
                                                builder: (context, setState) {
                                              return InkWell(
                                                onTap: () {
                                                  if (likeEnable == true) {
                                                    if (communityReviewList[
                                                                index]
                                                            .like_status
                                                            .toString() ==
                                                        "2") {
                                                    } else {
                                                      likeApi(
                                                          communityReviewList[
                                                                  index]
                                                              .business_reviews_id
                                                              .toString(),
                                                          "2");
                                                    }
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/down.svg",
                                                      color: communityReviewList[
                                                                      index]
                                                                  .like_status
                                                                  .toString() ==
                                                              "2"
                                                          ? kPrimaryColor
                                                          : Colors.black,
                                                      width: 4.5.w,
                                                    ),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Text(
                                                      "Dislike(" +
                                                          communityReviewList[
                                                                  index]
                                                              .total_dislike
                                                              .toString() +
                                                          ")",
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: communityReviewList[
                                                                          index]
                                                                      .like_status
                                                                      .toString() ==
                                                                  "2"
                                                              ? kPrimaryColor
                                                              : Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (reportEnable == true) {
                                                if (communityReviewList[index]
                                                        .report_status
                                                        .toString() !=
                                                    "1") {
                                                  setState(() {
                                                    communityReviewList[index]
                                                        .report_status = "1";
                                                  });
                                                  addReportApi(
                                                      communityReviewList[index]
                                                          .business_reviews_id
                                                          .toString(),
                                                      index);
                                                }
                                              }
                                            },
                                            child: Text(
                                              communityReviewList[index]
                                                          .report_status ==
                                                      "1"
                                                  ? "Reported"
                                                  : "Report",
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: communityReviewList[
                                                                index]
                                                            .report_status ==
                                                        "1"
                                                    ? kPrimaryColor
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print(unlikeEnable);
                                              if (unlikeEnable == true) {
                                                unlikeEnable = false;
                                                Share.share(
                                                        'check out my website https://example.com',
                                                        subject:
                                                            'Look what I made!')
                                                    .then((value) {
                                                  Future.delayed(
                                                      Duration(seconds: 2), () {
                                                    unlikeEnable = true;
                                                  });
                                                });
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              "assets/icons/share.svg",
                                              width: 4.5.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.w),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (communityReviewList[index]
                                                      .replies_count
                                                      .toString() ==
                                                  "0") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "No reply available")));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommunityReplies(
                                                              review_id:
                                                                  communityReviewList[
                                                                          index]
                                                                      .business_reviews_id
                                                                      .toString(),
                                                              username:
                                                                  communityReviewList[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              message:
                                                                  communityReviewList[
                                                                          index]
                                                                      .review
                                                                      .toString(),
                                                              image:
                                                                  communityReviewList[
                                                                          index]
                                                                      .image
                                                                      .toString(),
                                                            ))).then((value) {
                                                  communityReviewApi();
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Replies (" +
                                                  communityReviewList[index]
                                                      .replies_count
                                                      .toString() +
                                                  ")",
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.h,
                                          ),
                                          // isloading
                                          //     ? Align(
                                          //         alignment: Alignment.center,
                                          //         child: Platform.isAndroid
                                          //             ? CircularProgressIndicator()
                                          //             : CupertinoActivityIndicator())
                                          //     :
                                          SizedBox(
                                            width: 65.w,
                                            child: TextField(
                                              controller: messageTextController,
                                              onChanged: (val) {
                                                if (val.toString() == " ") {
                                                  messageTextController.text =
                                                      "";
                                                }
                                                print(val);

                                                communityReviewList[index]
                                                        .messageText =
                                                    val.toString().trim();
                                              },
                                              minLines: 1,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                              ),
                                              maxLines: 50,
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .deny(RegExp('[  ]'))
                                              // ],
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.h,
                                                          horizontal: 4.w),
                                                  fillColor: Colors.black,
                                                  filled: true,
                                                  //suffixIconConstraints: BoxConstraints(minWidth: 5),

                                                  hintText: "Reply",
                                                  suffixIcon: InkWell(
                                                      onTap: () {
                                                        var mesage =
                                                            messageTextController
                                                                .text
                                                                .toString();

                                                        if (mesage == "" ||
                                                            mesage == "null") {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "Please enter message")));
                                                        } else {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          communityReplyOnReviewApi(
                                                              communityReviewList[
                                                                      index]
                                                                  .business_reviews_id
                                                                  .toString(),
                                                              communityReviewList[
                                                                      index]
                                                                  .messageText
                                                                  .toString());
                                                        }
                                                      },
                                                      child: Icon(Icons.send,
                                                          color:
                                                              kPrimaryColor)),
                                                  hintStyle: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.white)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  reportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: isloading == true
                ? Column(
                    children: [
                      Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator()),
                      Text(
                        "Please wait....",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                    height: 18.h,
                    width: 95.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                          height: 1.h,
                        ),
                        Center(
                            child: Text(
                          "Your report has been submitted",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )),
                        SizedBox(
                          height: 1.7.h,
                        ),
                        isloading
                            ? Align(
                                alignment: Alignment.center,
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator())
                            : DefaultButton(
                                width: 35.w,
                                height: 6.h,
                                text: "Thank you",
                                press: () {
                                  Navigator.pop(context);
                                })
                      ],
                    ),
                  )),
          );
        });
      },
    );
  }

  Future<dynamic> addReportApi(String comId, int index) async {
    reportEnable = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id community sdfdfsd id: " + comId.toString());
    print("business community id: " + widget.nearBy.id.toString());
    setState(() {
      // isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.ADDREPORT_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": widget.nearBy.id.toString(),
          "review_id": comId
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      reportEnable = true;
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
        communityReviewList[index].report_status = "1";
        setState(() {
          isloading = false;
        });

        communityReviewApi();
        reportDialog();
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

  Future<dynamic> businessFavApi(
    String business_id,
    String fav,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
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
          widget.nearBy.fav = "0";
        } else {
          widget.nearBy.fav = "1";
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

  Future<dynamic> likeApi(String comId, String likeStatus) async {
    likeEnable = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id community id: " + comId.toString());
    print("business community id: " + widget.nearBy.id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.LIKECOMMUNITYREVIEW_URL,
        ),
        body: {
          "user_id": id.toString(),
          "likedislike": likeStatus.toString(),
          "business_id": widget.nearBy.id.toString(),
          "businessreview_id": comId
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      likeEnable = true;
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

        communityReviewApi();
      } else {
        setState(() {
          isloading = false;
          /*        ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));*/
        });
      }
    } else {
      setState(() {
        isloading = false;
        /*     ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));*/
      });
    }
  }

  Future<void> pickImagess(String type) async {
    await pickImages().then((value) {
      images = value;
      print("lengthhhhhh " + images.length.toString() + "*");
    });
    if (images.length > 0) {
      image_video_status = "1";
      ivStatus = "1";
      images.forEach((element) async {
        var path = await FlutterAbsolutePath.getAbsolutePath(
            element.identifier.toString());
        print("pathhh " + path.toString() + "*");

        file = File(path.toString());
        fileName = file!.path.split("/").last;
        fileList.add(file!);
      });

      setState(() {
        print("pathhh " + fileName.toString() + "*");
      });
    } else {
      image_video_status = "0";
      ivStatus = "0";
      images.clear();
    }
    Navigator.pop(context);

    if (type == "checkin") {
      checkInDialog();
    } else {
      customDialog();
    }
  }

  Future<dynamic> communityReplyOnReviewApi(
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
          "type": "REVIEW",
          "message": messageText,
          "video_image_status": "0"
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

        communityReviewApi();
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

  Future<dynamic> communityReviewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("buisness Id: " + widget.nearBy.id.toString());
    setState(() {
      isloading = false;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.COMMUNITYREVIEW_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": widget.nearBy.id.toString()
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
      communityReviewList.clear();

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          CommunityReviewAPI modelAgentSearch = new CommunityReviewAPI();

          modelAgentSearch.like_status = jsonArray[i]["like_status"].toString();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.name = jsonArray[i]["name"].toString();
          modelAgentSearch.image = jsonArray[i]["image"].toString();
          modelAgentSearch.review = jsonArray[i]["review"].toString();
          modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
          modelAgentSearch.business_review_image =
              jsonArray[i]["business_review_image"];
          modelAgentSearch.business_review_image_status =
              jsonArray[i]["business_review_image_status"].toString();
          modelAgentSearch.total_like = jsonArray[i]["total_like"].toString();
          modelAgentSearch.total_dislike =
              jsonArray[i]["total_dislike"].toString();
          modelAgentSearch.business_reviews_id =
              jsonArray[i]["business_reviews_id"].toString();
          modelAgentSearch.replies_count =
              jsonArray[i]["replies_count"].toString();
          modelAgentSearch.image_video_status =
              jsonArray[i]["image_video_status"].toString();
          modelAgentSearch.report_status =
              jsonArray[i]["report_status"].toString();
          print(": " + modelAgentSearch.image_video_status.toString());
          print("b id: " + modelAgentSearch.id.toString());

          videoLink = jsonArray[i]["business_review_image"].toString();

          print(
              "video id: " + jsonArray[i]["business_review_image"].toString());

          communityReviewList.add(modelAgentSearch);

          setState(() {});
        }
      } else {
        setState(() {
          // isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        // isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> businessReviewApi(
    String rattingg,
    String review,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
      customDialog();
      isloading = true;
    });

    print("id " + id.toString() + "");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.BUSINESSREVIEW_URL,
      ),
    );
    if (rattingg.toString() != "null" || rattingg.toString() != "") {
      request.fields["ratting"] = rattingg;
      print("ratting1: " + rattingg.toString());
    }

    if (review.toString() != "null" || review.toString() != "") {
      request.fields["review"] = review;
      print("review1: " + review.toString());
    }

    // if (ivStatus.toString() != "null" || ivStatus.toString() != "") {
    //   request.fields["image_video_status"] = ivStatus.toString();

    // } else {
    //   request.fields["image_video_status"] = "0";
    // }

    request.fields["business_id"] = widget.nearBy.id.toString();
    request.fields["user_id"] = id.toString();
    request.fields["type"] = "REVIEW";
    request.fields["image_video_status"] =
        ivStatus.toString() != "" ? ivStatus.toString() : "0";
    print("ivStatus: " + ivStatus.toString());
    if (ivStatus.toString() == "1") {
      if (fileList != null) {
        fileList.forEach((element) async {
          request.files
              .add(await http.MultipartFile.fromPath("image[]", file!.path));
        });
      }
    } else if (ivStatus.toString() == "2") {
      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath("image[]", file!.path));
      }
    }

    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      currentPath = "";
      ivStatus = "";
      fileName = "";
      ratting = 0.0;
      image_video_status = "0";
      images.clear();
      fileList.clear();
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (builder) => DetailBussiness(nearBy: widget.nearBy)));

        reviewController.clear();
        file = null;

        communityReviewApi();

        // prefs.setString('phone', jsonRes["data"]["phone"].toString());
        prefs.commit();
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);

        ivStatus = "1";
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
      ivStatus = "";
    }

    fileName = file!.path.split("/").last;
    print("ImageName: " + fileName.toString() + "_");
    print("Image: " + base64Image.toString() + "_");
    Navigator.pop(context);
    customDialog();
  }

  Future getCheckInImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        ivStatus = "1";
        image_video_status = "1";
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
      ivStatus = "";
      image_video_status = "0";
    }

    fileName = file!.path.split("/").last;
    print("ImageName: " + fileName.toString() + "_");
    print("Image: " + base64Image.toString() + "_");
    Navigator.pop(context);
    checkInDialog();
  }

  checkInDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          print("check: " + check.toString());
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: isloading == true
                ? Column(
                    children: [
                      Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator()),
                      Text(
                        "Please wait....",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Card(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                reviewController2.clear();
                                file = null;
                                fileName = "";
                                image_video_status = "0";
                                ivStatus = "";
                                currentPath = "";
                                rattingcheckin = 0.0;
                                check = "";
                                fileList.clear();
                                images.clear();
                              },
                              child: Container(
                                height: 10.w,
                                width: 10.w,
                                color: Colors.transparent,
                                child: Center(
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
                          height: 0.2.h,
                        ),
                        Text(
                          "How do you like restaurant\n"
                          "after check in",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // StatefulBuilder(builder: (context, setState) {
                            //   return
                            // }),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  check = "fire";
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/file.svg",
                                      color: check == "fire"
                                          ? kPrimaryColor
                                          : kIconBackgroundColor,
                                    ),
                                    SizedBox(
                                      height: 1.2.h,
                                    ),
                                    Text(
                                      "Fire",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: check == "fire"
                                            ? kPrimaryColor
                                            : Colors.white,

                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // StatefulBuilder(builder: (context, setState) {
                            //   return
                            // }),

                            InkWell(
                              onTap: () {
                                print("tab");
                                setState(() {
                                  check = "OkOk";
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/bakance.svg",
                                      color: check == "OkOk"
                                          ? kPrimaryColor
                                          : kIconBackgroundColor,
                                    ),
                                    Text(
                                      "OkOk",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: check == "OkOk"
                                            ? kPrimaryColor
                                            : Colors.white,

                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                setState(() {
                                  check = "Not Cool";
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/snow.svg",
                                      color: check == "Not Cool"
                                          ? kPrimaryColor
                                          : kIconBackgroundColor,
                                    ),
                                    Text(
                                      "Not Cool",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: check == "Not Cool"
                                            ? kPrimaryColor
                                            : Colors.white,

                                        //fontFamily: "Roboto"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // StatefulBuilder(builder: (context, setState) {
                            //   return
                            // }),
                          ],
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Container(
                          height: 0.5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Overall Rating",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: kCyanColor,

                                    //fontFamily: "Roboto"
                                  ),
                                ),
                                SizedBox(
                                  height: 0.6.h,
                                ),
                                RatingBar.builder(
                                  itemSize: 24,
                                  unratedColor: Color(0XFFCECECE),
                                  initialRating: rattingcheckin,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 6.w,
                                    color: kPrimaryColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print("Ratting :" + rating.toString());
                                    rattingcheckin = rating;
                                    //rat = rattingController.text.toString();
                                    print("Rat: " + rattingcheckin.toString());
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Images/Video",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: kCyanColor,

                                    //fontFamily: "Roboto"
                                  ),
                                ),
                                SizedBox(
                                  height: 0.6.h,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (image_video_status == "2") {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Either image or video can be post at a time'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBar,
                                          );
                                        } else {
                                          pickImagess("checkin");
                                          //getCheckInImage();
                                        }
                                        //                              ScaffoldMessenger.of(context)
                                        // .showSnackBar(SnackBar(content: Text("You can select either images or video")));

                                        //                             if (fileName.toString() != "null" || fileName.toString() != "") {
                                        //                               ScaffoldMessenger.of(context)
                                        // .showSnackBar(SnackBar(content: Text("You can select either images or video")));

                                        //                             }
                                      },
                                      child: file == null
                                          ? Container(
                                              child: SvgPicture.asset(
                                                  "assets/icons/image.svg"))
                                          : file!.path
                                                  .toString()
                                                  .endsWith("mp4")
                                              ? Container(
                                                  child: SvgPicture.asset(
                                                      "assets/icons/image.svg"))
                                              : Container(
                                                  height: 3.h,
                                                  width: 3.h,
                                                  decoration: BoxDecoration(
                                                      // borderRadius:
                                                      //     BorderRadius.circular(3.w),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        //Color(0xffD5D5D5)
                                                      ),
                                                      image: DecorationImage(
                                                          image: FileImage(File(
                                                              file!.path)))),
                                                ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          if (image_video_status == "1") {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    'Either image or video can be post at a time'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBar,
                                            );
                                          } else {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.video,
                                              allowCompression: false,
                                            );
                                            if (result != null) {
                                              file = File(
                                                  result.files.single.path!);
                                              fileName =
                                                  path.basename(file!.path);
                                              print("Filename " +
                                                  fileName.toString() +
                                                  "^");

                                              if (fileName == "" ||
                                                  fileName == null) {
                                                fileName = "File:- ";
                                                isVisible = false;
                                              } else {
                                                fileName = "File:- " + fileName;
                                                isVisible = true;
                                              }
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return TrimmerView(file!);
                                                }),
                                              ).then((value) {
                                                setState(() {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  image_video_status = "2";
                                                  checkInDialog();
                                                });
                                              });
                                            }
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            "assets/icons/video.svg")),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 12.h,
                          width: 85.w,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(3.w)),
                          child: TextFormField(
                            controller: reviewController2,
                            style: TextStyle(color: Color(0XFFCECECE)),
                            maxLines: 5,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: .2.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Type a Review...",
                                hintStyle: TextStyle(
                                    fontSize: 12.sp, color: Color(0XFFCECECE))),
                          ),
                        ),
                        SizedBox(
                          height: 1.2.h,
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            height: 8.h,
                            width: 80.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  fileList.length == 0 ? 0 : fileList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 7.h,
                                          width: 9.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.w),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      fileList[index]),
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
                                                  //fileList.removeAt(index);
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Visibility(
                              visible: isVisible,
                              child: Text(
                                fileName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        DefaultButton(
                            width: 35.w,
                            height: 6.h,
                            text: "Submit",
                            press: () {
                              if (check.toString() == "" ||
                                  check.toString() == "null") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Please select tag")));
                              } else if (rattingcheckin.toString() == "0.0" ||
                                  rattingcheckin.toString() == "null") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Please select rating")));
                              } else if (reviewController2.text.toString() ==
                                      "" ||
                                  reviewController2.text.toString() == "null") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Please enter review")));
                              } else {
                                if (currentPath != "") {
                                  file = File(currentPath.toString());
                                  fileName = path.basename(file!.path);
                                  print("Filename " + fileName.toString());
                                }
                                checkoutApi(
                                    rattingcheckin.toString(),
                                    reviewController2.text.toString(),
                                    check.toString());
                              }
                            })
                      ],
                    ),
                  )),
          );
        });
      },
    );
  }

  customDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: isloading == true
                ? Column(
                    children: [
                      Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator()),
                      Text(
                        "Please wait....",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Card(
                    color: Colors.black,
                    // height: 49.h,
                    // width: 95.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);

                                reviewController.clear();
                                file = null;
                                fileName = "";
                                trimFile = null;
                                trimFileName = "";
                                ivStatus = "";
                                image_video_status = "";
                                ratting = 0.0;
                                currentPath = "";
                                fileList.clear();
                                images.clear();
                              },
                              child: Container(
                                height: 10.w,
                                width: 10.w,
                                color: Colors.transparent,
                                child: Center(
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
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Overall Rating",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: kCyanColor,

                                    //fontFamily: "Roboto"
                                  ),
                                ),
                                SizedBox(
                                  height: 0.6.h,
                                ),
                                RatingBar.builder(
                                  itemSize: 24,
                                  unratedColor: Color(0XFFCECECE),
                                  initialRating: ratting,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 6.w,
                                    color: kPrimaryColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print("Ratting :" + rating.toString());
                                    ratting = rating;
                                    //rat = rattingController.text.toString();
                                    print("Rat: " + ratting.toString());
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Images/Video",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: kCyanColor,

                                    //fontFamily: "Roboto"
                                  ),
                                ),
                                SizedBox(
                                  height: 0.6.h,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (ivStatus == "2") {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Either image or video can be post at a time'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBar,
                                          );
                                        } else {
                                          // getImage();
                                          pickImagess("review");
                                        }
                                      },
                                      child: /* file == null
                                          ? Container(
                                              child: SvgPicture.asset(
                                                  "assets/icons/image.svg"))
                                          : file!.path
                                                  .toString()
                                                  .endsWith("mp4")
                                              ? */
                                          Container(
                                              child: SvgPicture.asset(
                                                  "assets/icons/image.svg"))
                                      /* : Container(
                                                  height: 3.h,
                                                  width: 3.h,
                                                  decoration: BoxDecoration(
                                                      // borderRadius:
                                                      //     BorderRadius.circular(3.w),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        //Color(0xffD5D5D5)
                                                      ),
                                                      image: DecorationImage(
                                                          image: FileImage(File(
                                                              file!.path)))),
                                                )*/
                                      ,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          if (ivStatus == "1") {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    'Either image or video can be post at a time'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBar,
                                            );
                                          } else {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.video,
                                              allowCompression: false,
                                            );
                                            if (result != null) {
                                              ivStatus = "2";
                                              file = File(
                                                  result.files.single.path!);
                                              fileName =
                                                  path.basename(file!.path);
                                              print("Filename " +
                                                  fileName.toString() +
                                                  "^");
                                              if (fileName == "" ||
                                                  fileName == null) {
                                                fileName = "File:- ";
                                                isVisible = false;
                                              } else {
                                                fileName = "File:- " + fileName;
                                                isVisible = true;
                                              }

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return TrimmerView(file!);
                                                }),
                                              ).then((value) async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();

                                                if (currentPath.toString() !=
                                                    "") {
                                                  ivStatus = "2";
                                                }

                                                customDialog();
                                              });
                                            }
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            "assets/icons/video.svg")),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 12.h,
                          width: 85.w,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(3.w)),
                          child: TextFormField(
                            controller: reviewController,
                            style: TextStyle(color: Color(0XFFCECECE)),
                            maxLines: 5,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: .2.h),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Type a Review...",
                                hintStyle: TextStyle(
                                    fontSize: 12.sp, color: Color(0XFFCECECE))),
                          ),
                        ),
                        SizedBox(
                          height: 1.2.h,
                        ),
                        Visibility(
                          visible: image_video_status == "1" ? true : false,
                          child: Container(
                            height: 8.h,
                            width: 80.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: fileList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 7.h,
                                          width: 9.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.w),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      fileList[index]),
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
                                                onTap: () {},
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
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Visibility(
                              visible: isVisible,
                              child: Container(
                                height: 40,
                                width: 85.w,
                                child: Text(
                                  fileName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              )),
                        ),
                        isloading
                            ? Align(
                                alignment: Alignment.center,
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator())
                            : DefaultButton(
                                width: 35.w,
                                height: 6.h,
                                text: "Submit",
                                press: () {
                                  print("ratting " + ratting.toString());
                                  if (ratting.toString() == "0.0" ||
                                      ratting.toString() == "null") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please select rating")));
                                  } else if (reviewController.text.toString() ==
                                          "" ||
                                      reviewController.text.toString() ==
                                          "null") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please enter review")));
                                  } else {
                                    print("NowPath " + currentPath.toString());
                                    print("statussss " + ivStatus.toString());
                                    if (currentPath != "") {
                                      file = File(currentPath.toString());
                                      fileName = path.basename(file!.path);
                                    }

                                    businessReviewApi(ratting.toString(),
                                        reviewController.text.toString());
                                  }
                                })
                      ],
                    ),
                  )),
          );
        });
      },
    );
  }

  void setPath(String path) {
    print("tis Path " + path.toString() + "^");
    trimFile = File(path);
  }

  Future<dynamic> checkInApiii() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("user_id Prinnt: " + id.toString());
    print("id Prinnt: " + widget.nearBy.id.toString().toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.CHECKINAPI,
        ),
        body: {"id": widget.nearBy.id.toString(), "user_id": id.toString()});

    var res;
    var jsonRes;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      jsonRes["status"].toString();
    });

    if (res.statusCode == 200) {
      check = "";
      currentPath = "";
      ivStatus = "";
      reviewController2.clear();
      fileName = "";
      rattingcheckin = 0.0;
      image_video_status = "0";

      if (jsonRes["status"].toString() == "true") {
        widget.nearBy.checkIn_status = "1";
        reviewController.clear();
        file = null;
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

      } else {
        setState(() {
          isloading = false;
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> checkInApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("user_id Prinnt: " + id.toString());
    print("id Prinnt: " + widget.nearBy.id.toString().toString());
    setState(() {
      isloading = true;
    });

    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.CHECKINAPI,
        ),
        body: {"id": widget.nearBy.id.toString(), "user_id": id.toString()});

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
      check = "";
      currentPath = "";
      ivStatus = "";
      reviewController2.clear();
      fileName = "";
      rattingcheckin = 0.0;
      image_video_status = "0";

      if (jsonRes["status"].toString() == "true") {
        widget.nearBy.checkIn_status = "1";
        reviewController.clear();
        file = null;
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

      } else {
        setState(() {
          isloading = false;
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> checkoutApi(String ratting, String review, String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
      Navigator.of(context, rootNavigator: true).pop();
      checkInDialog();
    });

    print("id " + id.toString() + "");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.BUSINESSREVIEW_URL,
      ),
    );
    if (ratting.toString() != "null" || ratting.toString() != "") {
      request.fields["ratting"] = ratting;
      print("ratting1: " + ratting.toString());
    }

    if (review.toString() != "null" || review.toString() != "") {
      request.fields["review"] = review;
      print("review1: " + review.toString());
    }

    if (tag.toString() != "null" || tag.toString() != "") {
      request.fields["tag"] = tag;
      print("tag1: " + tag.toString());
    }
    request.fields["type"] = "CHECK_OUT";
    request.fields["business_id"] = widget.nearBy.id.toString();
    request.fields["user_id"] = id.toString();
    request.fields["image_video_status"] = image_video_status.toString();

    if (ivStatus.toString() == "1") {
      if (fileList != null) {
        fileList.forEach((element) async {
          request.files
              .add(await http.MultipartFile.fromPath("image[]", file!.path));
        });
      }
    } else if (ivStatus.toString() == "2") {
      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath("image[]", file!.path));
      }
    }

    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      check = "";
      currentPath = "";
      ivStatus = "";
      reviewController2.clear();
      fileName = "";
      rattingcheckin = 0.0;
      image_video_status = "0";
      images.clear();
      fileList.clear();
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        widget.nearBy.checkIn_status = "0";
        communityReviewApi();
        reviewController.clear();
        file = null;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (builder) => DetailBussiness(nearBy: widget.nearBy)));
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

      } else {
        setState(() {
          isloading = false;
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  TextFormField buildMessageFormField() {
    return TextFormField(
      // controller: emailController,
      enabled: false,

      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,

      //inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
        fillColor: kPrimaryColor,
        filled: true,
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
}
