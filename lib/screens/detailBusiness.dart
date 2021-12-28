// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/models/community_review_api_model.dart';
import 'package:wemarkthespot/screens/communityReplies.dart';
import 'package:path/path.dart' as path;

import 'package:wemarkthespot/screens/explore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wemarkthespot/screens/testing.dart';
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
     print("vi: "+videoLink.toString());



    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String ratting = "";
  String rattingcheckin = "";

  TextEditingController reviewController = new TextEditingController();
  TextEditingController reviewController2 = new TextEditingController();
  TextEditingController rattingController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  String image = "";
  String base64Image = "";
  String fileName = "";
  File? file;
  bool isLoading = false;
  final picker = ImagePicker();
  bool isVisible = false;
  //get kPrimaryColor => null;

  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    print("business id: " + widget.nearBy.id.toString());
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
                                  widget.nearBy.review_count.toString() +
                                      " Reviews ",
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
                          checkInDialog();
                        },
                        child: Container(
                          height: 7.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12.w)),
                          child: Center(
                            child: Text(
                              "Check In",
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
                    height: 12.h,
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
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: kCyanColor,
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 1.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.w)),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "COMMUNITY REVIEWS",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Segoepr"),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: communityReviewList.length,
                  itemBuilder: (BuildContext context, int index) {
                   // 'https://builtenance.com/development/wemarkthespot/public/images/a6c4435d106e22b3e28bffb426d3814b.mp4'
                /*    if(communityReviewList[index]
                        .image_video_status
                        .toString() ==
                        "2") {
                      print("image At List "+communityReviewList[index]
                          .business_review_image
                          .toString());
                      _controllerr = VideoPlayerController.network(
                        //videoLink.toString()
                          communityReviewList[index].business_review_image.toString()


                      )
                        ..initialize().then((_) {
                          setState(() {

                          });
                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

                        });
                    }*/
                    TextEditingController messageTextController =
                        new TextEditingController();
                    return Column(
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
                                            imageUrl: communityReviewList[index]
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
                                                    fontWeight: FontWeight.w500
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

                                Visibility(
                                   visible: communityReviewList[index]
                                              .image_video_status
                                              .toString() ==
                                          "2"
                                      ? true
                                      : false,
                                  child: SizedBox(
                                      height:200,
                                      child: VideoWidget(url: communityReviewList[index].business_review_image, play: true,))
                                ),

                                Visibility(
                                  visible: communityReviewList[index]
                                              .image_video_status
                                              .toString() ==
                                          "1"
                                      ? true
                                      : false,
                                  child: Container(
                                    height: 48.h,
                                    width: double.infinity,
                                    child: Image.network(
                                      //  "assets/images/lighting.jpeg",
                                      communityReviewList[index]
                                          .business_review_image
                                          .toString(),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                // Container(
                                //     padding: EdgeInsets.only(left: 17.w),
                                //     width: double.infinity,
                                //     //color: Colors.red,
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceEvenly,
                                //       children: [
                                //         Container(
                                //           height: 3.h,
                                //           width: 30.w,
                                //           decoration: BoxDecoration(
                                //             color: Color(0XFF7C7474),
                                //             borderRadius:
                                //                 BorderRadius.circular(3.w),
                                //           ),
                                //           child: Center(
                                //             child: Text(
                                //               "Staff wear mask",
                                //               style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontSize: 9.sp),
                                //             ),
                                //           ),
                                //         ),
                                //         Container(
                                //           height: 3.h,
                                //           width: 30.w,
                                //           decoration: BoxDecoration(
                                //             color: Color(0XFF7C7474),
                                //             borderRadius:
                                //                 BorderRadius.circular(3.w),
                                //           ),
                                //           child: Center(
                                //             child: Text(
                                //               "Mask Mandtory",
                                //               style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontSize: 9.sp),
                                //             ),
                                //           ),
                                //         )
                                //       ],
                                //     )),
                                SizedBox(
                                  height: 2.5.h,
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
                                              if (communityReviewList[index]
                                                      .like_status
                                                      .toString() ==
                                                  "1") {
                                              } else {
                                                likeApi(
                                                    communityReviewList[index]
                                                        .business_reviews_id
                                                        .toString(),
                                                    "1");
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/up.svg",
                                                  color:
                                                      communityReviewList[index]
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
                                                      communityReviewList[index]
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
                                              if (communityReviewList[index]
                                                      .like_status
                                                      .toString() ==
                                                  "2") {
                                              } else {
                                                likeApi(
                                                    communityReviewList[index]
                                                        .business_reviews_id
                                                        .toString(),
                                                    "2");
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/down.svg",
                                                  color:
                                                      communityReviewList[index]
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
                                                      communityReviewList[index]
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
                                          addReportApi(
                                              communityReviewList[index]
                                                  .business_reviews_id
                                                  .toString());
                                        },
                                        child: Text(
                                          "Report",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
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
                                                      )));
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
                                      isloading
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Platform.isAndroid
                                                  ? CircularProgressIndicator()
                                                  : CupertinoActivityIndicator())
                                          : SizedBox(
                                              width: 65.w,
                                              child: TextField(
                                                controller:
                                                    messageTextController,
                                                onChanged: (val) {
                                                  print(val);

                                                  communityReviewList[index]
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
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.h,
                                                            horizontal: 4.w),
                                                    fillColor: Colors.black,
                                                    filled: true,
                                                    //suffixIconConstraints: BoxConstraints(minWidth: 5),

                                                    hintText: "Reply",
                                                    suffixIcon: InkWell(
                                                        onTap: () {
                                                          communityReplyOnReviewApi(
                                                              communityReviewList[
                                                                      index]
                                                                  .business_reviews_id
                                                                  .toString(),
                                                              communityReviewList[
                                                                      index]
                                                                  .messageText
                                                                  .toString());
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
          ),
        );
      },
    );
  }



  Future<dynamic> addReportApi(
    String comId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id community sdfdfsd id: " + comId.toString());
    print("business community id: " + widget.nearBy.id.toString());
    setState(() {
      isloading = true;
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

        communityReviewApi();
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
              jsonArray[i]["business_review_image"].toString();
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

          print(": " + modelAgentSearch.image_video_status.toString());
          print("b id: " + modelAgentSearch.id.toString());

          videoLink = jsonArray[i]["business_review_image"].toString();

          print("video id: " + jsonArray[i]["business_review_image"].toString());

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
    String ratting,
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
    if (ratting.toString() != "null" || ratting.toString() != "") {
      request.fields["ratting"] = ratting;
      print("ratting1: " + ratting.toString());
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
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath("image", file!.path));

      clearFile = file.toString();
    }

    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        Navigator.of(context, rootNavigator: true).pop();

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
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
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
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
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
                    child: SizedBox(
                    height: 55.h,
                    width: 95.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
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
                                  initialRating: 0,
                                  minRating: 0,
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
                                    rattingcheckin = rating.toString();
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
                                        getCheckInImage();
                                      },
                                      child: file == null
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
                                                      image: FileImage(
                                                          File(file!.path)))),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.video,
                                            allowCompression: false,
                                          );
                                          if (result != null) {
                                            file =
                                                File(result.files.single.path!);
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
                                                checkInDialog();
                                              });
                                            });
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
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Visibility(
                              visible: isVisible,
                              child: Text(
                                fileName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
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
                              } else if (rattingcheckin.toString() == "" ||
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
                                checkInApi(
                                    rattingcheckin.toString(),
                                    reviewController2.text.toString(),
                                    check.toString());
                              }
                              reviewController2.clear();
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
                    child: SizedBox(
                    height: 35.h,
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
                                  initialRating: 0,
                                  minRating: 0,
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
                                    ratting = rating.toString();
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
                                        getImage();

                                        setState(() {
                                          ivStatus = "1";
                                        });
                                      },
                                      child: file == null
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
                                                      image: FileImage(
                                                          File(file!.path)))),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            ivStatus = "2";
                                          });

                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.video,
                                            allowCompression: false,
                                          );
                                          if (result != null) {
                                            file =
                                                File(result.files.single.path!);
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
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              customDialog();
                                            });
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
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Visibility(
                              visible: isVisible,
                              child: Text(
                                fileName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                  if (ratting.toString() == "" ||
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

  Future<dynamic> checkInApi(String ratting, String review, String tag) async {
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
    request.fields["check_status"] = "1";
    request.fields["type"] = "CHECK_IN";
    request.fields["business_id"] = widget.nearBy.id.toString();
    request.fields["user_id"] = id.toString();

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath("image", file!.path));

      clearFile = file.toString();
    }

    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        Navigator.of(context, rootNavigator: true).pop();
        communityReviewApi();
        reviewController.clear();
        file = null;

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
