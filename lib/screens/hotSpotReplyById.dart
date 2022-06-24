import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/components/slider_image.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/communityRepliesById.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:wemarkthespot/screens/testingsheet.dart';
import 'package:wemarkthespot/screens/video_player_widget.dart';
import 'package:wemarkthespot/screens/video_player_widget3.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:wemarkthespot/services/modelProvider.dart';

import '../main.dart';
import '../models/body.dart';
import 'detailBusinessdynamic.dart';
import 'hotspot.dart';

class HotSpotReplyById extends StatefulWidget {


  @override
  _HotSpotReplyByIdState createState() => _HotSpotReplyByIdState();
}

class _HotSpotReplyByIdState extends State<HotSpotReplyById> {
  TextEditingController messageController = new TextEditingController();
  var replyId = "";
  var reviewId = "";
  bool viewVisible = false;
  final picker = ImagePicker();
  File? file;
  String base64Image = "";
  String fileName = "";

  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";
  List<GetAllBusiness> getAllBusinessList = [];
  List<String> coments = [];
  List<String> selectedList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool isRefresh = false;
  ReviewDetail detail = new ReviewDetail();

  List<GETREPLYONHOTSPOT> getReplyOnHotspotList = [];
  bool isloading = false;
  ScrollController _controller = new ScrollController();
  var image_video_status = "0";
  var tabOne = "";
  var selectedIndex = -1;
  var words = [];
  String str = '';
  String selectedName = "";
  String selectedvalue = "";
  var selectedId = "";
  List<Asset> images = [];
  List<File> fileList = [];
  String sendReply = "";
  @override
  void initState() {


    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      getallBusinessDataApi();
    final args = ModalRoute.of(context)!.settings.arguments as NotificationModel;
    if(args!=null) {
      print("review_iddd " + args.review_id.toString());
      print("reply_id " + args.reply_id.toString());
      replyId = args.reply_id;
      review_id = args.review_id;
      if (review_id.toString() != "" && review_id.toString() != "null") {
        getDetailsofReview();
        getReplyOnHotspotApi();
      }
    }
  });
        }

  @override
  Widget build(BuildContext context) {

    var count = '${context.watch<Counter>().count}';
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
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        color: kBackgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.8.h, left: 2.w),
                              child: CachedNetworkImage(
                                imageUrl: detail.user_image.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage: NetworkImage(
                                    detail.user_image.toString(),
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
                            // SizedBox(
                            //   width: 0.w,
                            // ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 80.w,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        //"Person Name",
                                        detail.review_user_name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: kCyanColor,
                                            fontFamily: "Segoepr"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Text(
                                      // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",

                                      detail.review.toString() != "null"
                                          ? detail.review.toString()
                                          : "",
                                      style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                          fontSize: 10.2.sp,
                                          color: Colors.white,
                                          fontFamily: 'Roboto'),
                                    ),
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
                                        // getReplyOnHotspotList[index].viewV
                                        //     ?
                                        Text(
                                          //"2m ago",
                                          detail.timeDelay.toString(),
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(right: 9.w),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                viewVisible = true;
                                                tabOne ="0";
                                                selectedIndex = -1;
                                              });
                                            },
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 2.h,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: getReplyOnHotspotList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Card(
                                color: kBackgroundColor,
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.w)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.8.h, left: 2.w),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                getReplyOnHotspotList[index]
                                                    .userProfile!
                                                    .image
                                                    .toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 7.w,
                                              backgroundImage: NetworkImage(
                                                  getReplyOnHotspotList[index]
                                                      .userProfile!
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
                                                    Expanded(
                                                      child: RichText(
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  11.sp,
                                                                  color:
                                                                  kCyanColor,
                                                                  fontFamily:
                                                                  "Segoepr"),
                                                              children: [
                                                                TextSpan(
                                                                    text:  getReplyOnHotspotList[
                                                                    index]
                                                                        .userProfile!
                                                                        .name
                                                                        .toString() !=
                                                                        "null"
                                                                        ? getReplyOnHotspotList[
                                                                    index]
                                                                        .userProfile!
                                                                        .name
                                                                        .toString()
                                                                        : "User Name"),
                                                                getReplyOnHotspotList[
                                                                index]
                                                                    .business!=null?TextSpan(
                                                                    text: getReplyOnHotspotList[
                                                                    index]
                                                                        .business!.name
                                                                        .toString(),
                                                                    recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                            NotificationModel model = NotificationModel();
                                                                            model.review_id = getReplyOnHotspotList[index].business!.id;
                                                                            model.reply_id = "";
                                                                            model.type = "business";

                                                                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                      }):TextSpan(text: ""),
                                                                getReplyOnHotspotList[
                                                                index]
                                                                    .business2!=null?TextSpan(
                                                                    text: getReplyOnHotspotList[
                                                                    index]
                                                                        .business2!.name
                                                                        .toString(),
                                                                    recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                            NotificationModel model = NotificationModel();
                                                                            model.review_id = getReplyOnHotspotList[index].business2!.id;
                                                                            model.reply_id = "";
                                                                            model.type = "business";

                                                                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                      }):TextSpan(text: ""),
                                                                getReplyOnHotspotList[
                                                                index]
                                                                    .business3!=null?TextSpan(
                                                                    text: getReplyOnHotspotList[
                                                                    index]
                                                                        .business3!.name
                                                                        .toString(),
                                                                    recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                            NotificationModel model = NotificationModel();
                                                                            model.review_id = getReplyOnHotspotList[index].business3!.id;
                                                                            model.reply_id = "";
                                                                            model.type = "business";

                                                                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);
                                                                      }):TextSpan(text: ""),
                                                                getReplyOnHotspotList[
                                                                index]
                                                                    .business4!=null?TextSpan(
                                                                    text: getReplyOnHotspotList[
                                                                    index]
                                                                        .business4!.name
                                                                        .toString(),
                                                                    recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                            NotificationModel model = NotificationModel();
                                                                            model.review_id = getReplyOnHotspotList[index].business4!.id;
                                                                            model.reply_id = "";
                                                                            model.type = "business";

                                                                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                      }):TextSpan(text: ""),
                                                                getReplyOnHotspotList[
                                                                index]
                                                                    .business5!=null?TextSpan(
                                                                    text: getReplyOnHotspotList[
                                                                    index]
                                                                        .business5!.name
                                                                        .toString(),
                                                                    recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                            NotificationModel model = NotificationModel();
                                                                            model.review_id = getReplyOnHotspotList[index].business5!.id;
                                                                            model.reply_id = "";
                                                                            model.type = "business";

                                                                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                      }):TextSpan(text: "")
                                                              ])),
                                                    ),
                                                    /*Text(
                                                      //"Person Name",
                                                      getReplyOnHotspotList[
                                                                      index]
                                                                  .userProfile!
                                                                  .name
                                                                  .toString() !=
                                                              "null"
                                                          ? getReplyOnHotspotList[
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
                                                    ),*/
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.w),
                                                      child: Text(
                                                        //"2m ago",
                                                        getReplyOnHotspotList[
                                                                index]
                                                            .timedelay
                                                            .toString(),
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
                                                width: 72.w,
                                                child: Text(
                                                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",

                                                  getReplyOnHotspotList[index]
                                                              .message
                                                              .toString() !=
                                                          "null"
                                                      ? getReplyOnHotspotList[
                                                              index]
                                                          .message
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                      //overflow: TextOverflow.ellipsis,
                                                      fontSize: 10.2.sp,
                                                      color: Colors.white,
                                                      fontFamily: 'Roboto'),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    getReplyOnHotspotList[index]
                                        .video_image_status
                                        .toString() ==
                                        "2"? Visibility(
                                        visible: getReplyOnHotspotList[index]
                                            .video_image_status
                                            .toString() ==
                                            "2"
                                            ? true
                                            : false,
                                        child: SizedBox(
                                            height: 200,
                                            child: VideoItems(
                                              videoPlayerController: VideoPlayerController.network(getReplyOnHotspotList[index]
                                                  .image[0]),

                                            ))):Container(width: 0,height: 0,),
                                    getReplyOnHotspotList[index]
                                        .video_image_status
                                        .toString() ==
                                        "1"?Visibility(
                                      visible: getReplyOnHotspotList[index]
                                          .video_image_status
                                          .toString() ==
                                          "1"
                                          ? true
                                          : false,
                                      child:  HotspotImageSlider(
                                          items:getReplyOnHotspotList[index]
                                              .image


                                        )



                                    ):Container(width: 0,height: 0,),
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
                                          getReplyOnHotspotList[index]
                                              .viewV == true
                                              ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                getReplyOnHotspotList[
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
                                                  color:
                                                  kPrimaryColor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontFamily:
                                                  "Roboto"),
                                            ),
                                          )
                                              : InkWell(
                                            onTap: () {
                                              setState(() {
                                                if(getReplyOnHotspotList[index].childrenList!=null){
                                                  if(getReplyOnHotspotList[index].childrenList.length>0){
                                                    getReplyOnHotspotList[
                                                    index]
                                                        .viewV = true;
                                                  }
                                                }

                                              });
                                            },
                                            child: Text(
                                              "View Replies",
                                              style: TextStyle(
                                                  fontSize:
                                                  11.sp,
                                                  color:
                                                  kPrimaryColor,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontFamily:
                                                  "Roboto"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 3.w),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  viewVisible = true;
                                                  selectedIndex = index;
                                                  tabOne =
                                                      getReplyOnHotspotList[
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
                                                    Colors.white,
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
                                    replyCard(index),
                                  ],
                                )),

                            // SizedBox(
                            //   height: 0.2.h,
                            // ),
                            //replyWidget(controller: _controller),

                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Visibility(
          visible: viewVisible,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                str.length > 1
                    ? ListView(
                    shrinkWrap: true,
                    children: getAllBusinessList.map((s) {
                      if (('@' + s.business_name.toString().toLowerCase())
                          .contains(str.toString().toLowerCase())) {
                        print("running");
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                              title: Text(
                                s.business_name,
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                              onTap: () {
                                String tmp = str.substring(
                                    1, str.length);
                                print(
                                    "tmp " + tmp.toString() + "^");
                                selectedId = s.business_id;
                                selectedList.add(s.business_id);

                                setState(() {
                                  messageController.text =
                                      messageController
                                          .text
                                          .toString()
                                          .substring(
                                          0,
                                          messageController.text
                                              .toString()
                                              .length -
                                              tmp.length);
                                  messageController.text +=s.business_name +
                                      "@@" +
                                      s.business_id +
                                      "##";
                                  //reviewController.text += s.business_name.substring(s.business_name.indexOf(tmp)+tmp.length,s.business_name.length).replaceAll(' ','_');
                                  sendReply =
                                      messageController.text.toString();
                                  if (messageController.text
                                      .contains("@@")) {
                                    splitString();
                                  }
                                  messageController.selection =
                                      TextSelection.fromPosition(
                                          TextPosition(
                                              offset:
                                              messageController.text
                                                  .length));
                                  str = '';
                                });
                              }),
                        );
                      }
                      else {
                        return SizedBox();
                      }
                    }).toList())
                    : Visibility(visible: false, child: SizedBox()),
                SizedBox(height: 25),
                coments.length > 0
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: coments.length,
                  itemBuilder: (con, ind) {
                    return Text.rich(
                      TextSpan(
                          text: '',
                          children: coments[ind].split(' ').map((w) {
                            return w.startsWith('@') && w.length > 1
                                ? TextSpan(
                              text: ' ' + w,
                              style: TextStyle(color: Colors.blue),
                            )
                                : TextSpan(
                                text: ' ' + w,
                                style: TextStyle(color: Colors.black));
                          }).toList()),
                    );
                  },
                )
                    : Visibility(visible: false, child: SizedBox()),
                Visibility(
                    visible: file==null?false:true,
                    child:  file!=null? image_video_status == "1"?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(10), topRight:Radius.circular(10)),
                          color: kBackgroundColor
                        ),

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
                                                      left: 11.w, bottom: 5.h),
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      fileList.removeAt(i);
                                                      images.removeAt(i);

                                                      if (fileList.length == 0) {

                                                        file = null;
                                                        fileName = "";
                                                        fileList.clear();
                                                        images.clear();
                                                        image_video_status = "0";
                                                      }
                                                      setState(() {

                                                      });
                                                    },
                                                    child: Container(
                                                      height:4.h,
                                                      width:4.h,
                                                      color:Colors.transparent,
                                                      child: Center(
                                                        child: Container(
                                                          height: 2.h,
                                                          width: 2.h,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                              "assets/icons/cross.svg",
                                                              width: 8,
                                                              color: Colors.black,
                                                            ),
                                                          ),
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
                            //   flex:9,
                            //   child: Center(
                            //     child: Container(

                            //         height: 150,
                            //         child: Image.file(file!, height: 80,)),
                            //   ),
                            // ),

                            Flexible(
                              flex: 1,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex:8,
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
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            "assets/icons/cross.svg",
                                            color: Colors.white,
                                            width: 4.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: Container())
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(10), topRight:Radius.circular(10)),
                            color: kBackgroundColor
                        ),
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
                                      padding: const EdgeInsets.only(right: 5.0),
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
                              width: MediaQuery.of(context).size.width ,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  fileName,
                                  maxLines: 3,
                                  style: TextStyle(
                                  color: Colors.white
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):Container(color: Colors.white,height: 100,) ),

                Container(
                  width: double.infinity,
                  height: 8.h,
                  color: Colors.black,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          image_video_status = "0";
                          file = null;
                          fileName = "";
                          currentPath = "";
                          fileList.clear();
                          images.clear();
                          setState(() {

                          });
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
                          onChanged: (val) {
                            setState(() {
                              if(selectedList.length<5) {
                                words = val.split(' ');
                                str = words.length > 0 &&
                                    words[words.length - 1].startsWith('@')
                                    ? words[words.length - 1]
                                    : '';


                              }
                              if (messageController.text.contains("@@")) {
                                sendReply = messageController.text;
                                splitString();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
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

                            //  var mesage = getHostSpotList[
                            //                                             index]
                            //                                         .messageController
                            //                                         .text
                            //                                         .toString();

                            //                                     if (mesage ==
                            //                                             "" ||
                            //                                         mesage ==
                            //                                             "null") {
                            //                                       ScaffoldMessenger.of(
                            //                                               context)
                            //                                           .showSnackBar(SnackBar(
                            //                                               content:
                            //                                                   Text("Please enter reply")));
                            //                                     } else {
                            //                                       FocusScope.of(
                            //                                               context)
                            //                                           .unfocus();
                            //                                       replyOnHotspotReviewApi(
                            //                                           getHostSpotList[
                            //                                                   index]
                            //                                               .id
                            //                                               .toString(),
                            //                                           mesage,
                            //                                           index);
                            //                                     }

                            //                                     getHostSpotList[
                            //                                             index]
                            //                                         .messageController
                            //                                         .clear();





                            var messge = messageController.text.toString().trim();

                            if (messge == "" || messge == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please enter reply")));
                            } else {

                              FocusScope.of(context).unfocus();
                              replyOnHotspotReplyApi(tabOne.toString(),
                                  messageController.text.toString(), selectedId);

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
        ),
      ),
    );
  }

  void _onRefresh() async {
    isRefresh = true;
    getReplyOnHotspotApi();
  }

  String splitString() {
    var abcList = "";
    abcList = sendReply.replaceRange(
        sendReply.indexOf("@@"), sendReply.indexOf("#") + 2, "");
    if (abcList.contains("@@")) {
      splitString();
    } else {
      messageController.text = abcList;
      return abcList;
    }
    return "";
  }

  Future<dynamic> replyOnHotspotReplyApi(
      String reply_id, String messageText, [String? sec = '312']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    print("id: " + id.toString());
    print("review_id: " + review_id.toString());
    print("reply_id: " + reply_id.toString());
    print("type: " + "HOTSPOT");
    print("message: " + messageText.toString());

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.COMMUNITYREPLYONREVIEW_URL,
      ),
    );
    request.fields["user_id"] = id.toString();
    request.fields["review_id"] = review_id.toString();
    request.fields["reply_id"] = reply_id;
    request.fields["type"] = "HOTSPOT";
    request.fields["message"] = messageText;
    request.fields["video_image_status"] = image_video_status;

    if(selectedList.length>0) {
      if(selectedList.length==1){
        request.fields["business_id"] = selectedList[0];

      }else if(selectedList.length==2){
        request.fields["business_id"] = selectedList[0];
        request.fields["business_id2"] = selectedList[1];
      }else if(selectedList.length==3){
        request.fields["business_id"] = selectedList[0];
        request.fields["business_id2"] = selectedList[1];
        request.fields["business_id3"] = selectedList[2];
      }else if(selectedList.length==4){
        request.fields["business_id"] = selectedList[0];
        request.fields["business_id2"] = selectedList[1];
        request.fields["business_id3"] = selectedList[2];
        request.fields["business_id4"] = selectedList[3];
      }else if(selectedList.length==5){
        request.fields["business_id"] = selectedList[0];
        request.fields["business_id2"] = selectedList[1];
        request.fields["business_id3"] = selectedList[2];
        request.fields["business_id4"] = selectedList[3];
        request.fields["business_id5"] = selectedList[4];
      }

    }

   // request.fields["business_id"] = sec != "" ? sec.toString() : "312";

     if(image_video_status=="2"){
      request.files.add(await http.MultipartFile.fromPath("image[]", file!.path));

    }else if(image_video_status=="1"){
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
    print("input "+request.fields.toString());
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res = await request.send();



    if (res.statusCode == 200) {
      file = null;
      fileName = "";
      base64Image = "";
      image_video_status = "0";
      fileList.clear();
      images.clear();
      currentPath = "";
      selectedList.clear();
      selectedId = "";
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          viewVisible = false;
          isloading = false;
          messageController.text = "";
        });

        getReplyOnHotspotApi();

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
          messageController.text = "";
          viewVisible = false;
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        messageController.text = "";
        viewVisible = false;
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> getReplyOnHotspotApi() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = false;
    });

    var request = http.get(
      Uri.parse(RestDatasource.GETREPLYONCOMMUNITYREVIEW_URL +
          //"3"
          review_id.toString() +
          "&type=" +
          "HOTSPOT"),
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
      getReplyOnHotspotList.clear();
      _refreshController.refreshCompleted(resetFooterState: false);
      final date2 = DateTime.now();
      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          GETREPLYONHOTSPOT modelAgentSearch = new GETREPLYONHOTSPOT();

          // NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
          modelAgentSearch.review_id = jsonArray[i]["review_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.video_image_status = jsonArray[i]["video_image_status"].toString();
          modelAgentSearch.image = jsonArray[i]["image"];


          if(jsonArray[i]["business"].toString()!="[]"){
            BuisnessData buisnessData = new BuisnessData();
            buisnessData.id = jsonArray[i]["business"]["id"].toString();
            buisnessData.name =" @ "+ jsonArray[i]["business"]["business_name"].toString();
            buisnessData.image = jsonArray[i]["business"]["image"].toString();
            print("Businessname "+jsonArray[i]["business"]["business_name"].toString());
            modelAgentSearch.business = buisnessData;
          }
          if(jsonArray[i]["business2"].toString()!="[]"){
            BuisnessData buisnessData2 = new BuisnessData();
            buisnessData2.id = jsonArray[i]["business2"]["id"].toString();
            buisnessData2.name =" @ "+ jsonArray[i]["business2"]["business_name"].toString();
            buisnessData2.image = jsonArray[i]["business2"]["image"].toString();
            modelAgentSearch.business2 = buisnessData2;
          }
          if(jsonArray[i]["business3"].toString()!="[]"){
            BuisnessData buisnessData3 = new BuisnessData();
            buisnessData3.id = jsonArray[i]["business3"]["id"].toString();
            buisnessData3.name =" @ "+ jsonArray[i]["business3"]["business_name"].toString();
            buisnessData3.image = jsonArray[i]["business3"]["image"].toString();
            modelAgentSearch.business3 = buisnessData3;
          }
          if(jsonArray[i]["business4"].toString()!="[]"){
            BuisnessData buisnessData4 = new BuisnessData();
            buisnessData4.id = jsonArray[i]["business4"]["id"].toString();
            buisnessData4.name =" @ "+ jsonArray[i]["business4"]["business_name"].toString();
            buisnessData4.image = jsonArray[i]["business4"]["image"].toString();
            modelAgentSearch.business4 = buisnessData4;
          }
          if(jsonArray[i]["business5"].toString()!="[]"){
            BuisnessData buisnessData5 = new BuisnessData();
            buisnessData5.id = jsonArray[i]["business5"]["id"].toString();
            buisnessData5.name =" @ "+ jsonArray[i]["business5"]["business_name"].toString();
            buisnessData5.image = jsonArray[i]["business5"]["image"].toString();
            modelAgentSearch.business5 = buisnessData5;
          }
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
                GETREPLYONHOTSPOT childModelOne = GETREPLYONHOTSPOT();

                childModelOne.id = childDataOne[j]["id"].toString();
                childModelOne.created_at =
                    childDataOne[j]["created_at"].toString();
                childModelOne.review_id =
                    childDataOne[j]["review_id"].toString();
                childModelOne.message = childDataOne[j]["message"].toString();
                childModelOne.video_image_status = childDataOne[j]["video_image_status"].toString();
                childModelOne.image = childDataOne[j]["image"];
                if(childModelOne.id==replyId){
                  modelAgentSearch.viewV = true;
                }else{
                  modelAgentSearch.viewV = true;
                }
                if(childDataOne[j]["business"].toString()!="[]"){
                  BuisnessData buisnessData = new BuisnessData();
                  buisnessData.id = childDataOne[j]["business"]["id"].toString();
                  buisnessData.name =" @ "+ childDataOne[j]["business"]["business_name"].toString();
                  buisnessData.image = childDataOne[j]["business"]["image"].toString();
                  print("Businessname "+childDataOne[j]["business"]["business_name"].toString());
                  childModelOne.business = buisnessData;
                }
                if(childDataOne[j]["business2"].toString()!="[]"){
                  BuisnessData buisnessData2 = new BuisnessData();
                  buisnessData2.id = childDataOne[j]["business2"]["id"].toString();
                  buisnessData2.name =" @ "+ childDataOne[j]["business2"]["business_name"].toString();
                  buisnessData2.image = childDataOne[j]["business2"]["image"].toString();
                  childModelOne.business2 = buisnessData2;
                }
                if(childDataOne[j]["business3"].toString()!="[]"){
                  BuisnessData buisnessData3 = new BuisnessData();
                  buisnessData3.id = childDataOne[j]["business3"]["id"].toString();
                  buisnessData3.name =" @ "+ childDataOne[j]["business3"]["business_name"].toString();
                  buisnessData3.image = childDataOne[j]["business3"]["image"].toString();
                  childModelOne.business3 = buisnessData3;
                }
                if(childDataOne[j]["business4"].toString()!="[]"){
                  BuisnessData buisnessData4 = new BuisnessData();
                  buisnessData4.id = childDataOne[j]["business4"]["id"].toString();
                  buisnessData4.name =" @ "+ childDataOne[j]["business4"]["business_name"].toString();
                  buisnessData4.image = childDataOne[j]["business4"]["image"].toString();
                  childModelOne.business4 = buisnessData4;
                }
                if(childDataOne[j]["business5"].toString()!="[]"){
                  BuisnessData buisnessData5 = new BuisnessData();
                  buisnessData5.id = childDataOne[j]["business5"]["id"].toString();
                  buisnessData5.name =" @ "+ childDataOne[j]["business5"]["business_name"].toString();
                  buisnessData5.image = childDataOne[j]["business5"]["image"].toString();
                  childModelOne.business5 = buisnessData5;
                }
                var difference = date2
                    .difference(DateTime.parse(childModelOne.created_at))
                    .inSeconds;
                childModelOne.timedelay =
                    difference.toString() + " seconds ago";
                if (difference > 60) {
                  var difference = date2
                      .difference(DateTime.parse(childModelOne.created_at))
                      .inMinutes;
                  childModelOne.timedelay =
                      difference.toString() + " minutes ago";

                  if (difference > 60) {
                    var difference = date2
                        .difference(DateTime.parse(childModelOne.created_at))
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
                      GETREPLYONHOTSPOT childrenModelTwo = GETREPLYONHOTSPOT();
                      childrenModelTwo.id = childDataTwo[k]["id"].toString();
                      childrenModelTwo.created_at =
                          childDataTwo[k]["created_at"].toString();
                      childrenModelTwo.review_id =
                          childDataTwo[k]["review_id"].toString();
                      childrenModelTwo.message =
                          childDataTwo[k]["message"].toString();
                      childrenModelTwo.video_image_status = childDataTwo[k]["video_image_status"].toString();
                      childrenModelTwo.image = childDataTwo[k]["image"];
                      childrenUserDataTwo = childDataTwo[k]['user'];
                      if(childrenModelTwo.id==replyId){
                        childModelOne.viewV = true;
                      }else{
                        childModelOne.viewV = true;
                      }
                      if(childDataTwo[k]["business"].toString()!="[]"){
                        BuisnessData buisnessData = new BuisnessData();
                        buisnessData.id = childDataTwo[k]["business"]["id"].toString();
                        buisnessData.name =" @ "+ childDataTwo[k]["business"]["business_name"].toString();
                        buisnessData.image = childDataTwo[k]["business"]["image"].toString();
                        print("Businessname "+childDataTwo[k]["business"]["business_name"].toString());
                        childrenModelTwo.business = buisnessData;
                      }
                      if(childDataTwo[k]["business2"].toString()!="[]"){
                        BuisnessData buisnessData2 = new BuisnessData();
                        buisnessData2.id = childDataTwo[k]["business2"]["id"].toString();
                        buisnessData2.name =" @ "+ childDataTwo[k]["business2"]["business_name"].toString();
                        buisnessData2.image = childDataTwo[k]["business2"]["image"].toString();
                        childrenModelTwo.business2 = buisnessData2;
                      }
                      if(childDataTwo[k]["business3"].toString()!="[]"){
                        BuisnessData buisnessData3 = new BuisnessData();
                        buisnessData3.id = childDataTwo[k]["business3"]["id"].toString();
                        buisnessData3.name =" @ "+ childDataTwo[k]["business3"]["business_name"].toString();
                        buisnessData3.image = childDataTwo[k]["business3"]["image"].toString();
                        childrenModelTwo.business3 = buisnessData3;
                      }
                      if(childDataTwo[k]["business4"].toString()!="[]"){
                        BuisnessData buisnessData4 = new BuisnessData();
                        buisnessData4.id = childDataTwo[k]["business4"]["id"].toString();
                        buisnessData4.name =" @ "+ childDataTwo[k]["business4"]["business_name"].toString();
                        buisnessData4.image = childDataTwo[k]["business4"]["image"].toString();
                        childrenModelTwo.business4 = buisnessData4;
                      }
                      if(childDataTwo[k]["business5"].toString()!="[]"){
                        BuisnessData buisnessData5 = new BuisnessData();
                        buisnessData5.id = childDataTwo[k]["business5"]["id"].toString();
                        buisnessData5.name =" @ "+ childDataTwo[k]["business5"]["business_name"].toString();
                        buisnessData5.image = childDataTwo[k]["business5"]["image"].toString();
                        childrenModelTwo.business5 = buisnessData5;
                      }
                      var difference = date2
                          .difference(
                              DateTime.parse(childrenModelTwo.created_at))
                          .inSeconds;
                      childrenModelTwo.timedelay =
                          difference.toString() + " seconds ago";
                      if (difference > 60) {
                        var difference = date2
                            .difference(
                                DateTime.parse(childrenModelTwo.created_at))
                            .inMinutes;
                        childrenModelTwo.timedelay =
                            difference.toString() + " minutes ago";

                        if (difference > 60) {
                          var difference = date2
                              .difference(
                                  DateTime.parse(childrenModelTwo.created_at))
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
                            GETREPLYONHOTSPOT childrenModelThree =
                                GETREPLYONHOTSPOT();

                            childrenModelThree.id =
                                childDataThree[l]["id"].toString();
                            childrenModelThree.created_at =
                                childDataThree[l]["created_at"].toString();
                            childrenModelThree.review_id =
                                childDataThree[l]["review_id"].toString();
                            childrenModelThree.message =
                                childDataThree[l]["message"].toString();
                            childrenModelThree.video_image_status = childDataThree[l]["video_image_status"].toString();
                            childrenModelThree.image = childDataThree[l]["image"];
                            if(childrenModelThree.id==replyId){
                              childrenModelTwo.viewV = true;
                            }else{
                              childrenModelTwo.viewV = true;
                            }

                            if(childDataThree[l]["business"].toString()!="[]"){
                              BuisnessData buisnessData = new BuisnessData();
                              buisnessData.id = childDataThree[l]["business"]["id"].toString();
                              buisnessData.name =" @ "+ childDataThree[l]["business"]["business_name"].toString();
                              buisnessData.image = childDataThree[l]["business"]["image"].toString();
                              print("Businessname "+childDataThree[l]["business"]["business_name"].toString());
                              childrenModelThree.business = buisnessData;
                            }
                            if(childDataThree[l]["business2"].toString()!="[]"){
                              BuisnessData buisnessData2 = new BuisnessData();
                              buisnessData2.id = childDataThree[l]["business2"]["id"].toString();
                              buisnessData2.name =" @ "+ childDataThree[l]["business2"]["business_name"].toString();
                              buisnessData2.image = childDataThree[l]["business2"]["image"].toString();
                              childrenModelThree.business2 = buisnessData2;
                            }
                            if(childDataThree[l]["business3"].toString()!="[]"){
                              BuisnessData buisnessData3 = new BuisnessData();
                              buisnessData3.id = childDataThree[l]["business3"]["id"].toString();
                              buisnessData3.name =" @ "+ childDataThree[l]["business3"]["business_name"].toString();
                              buisnessData3.image = childDataThree[l]["business3"]["image"].toString();
                              childrenModelThree.business3 = buisnessData3;
                            }
                            if(childDataThree[l]["business4"].toString()!="[]"){
                              BuisnessData buisnessData4 = new BuisnessData();
                              buisnessData4.id = childDataThree[l]["business4"]["id"].toString();
                              buisnessData4.name =" @ "+ childDataThree[l]["business4"]["business_name"].toString();
                              buisnessData4.image = childDataThree[l]["business4"]["image"].toString();
                              childrenModelThree.business4 = buisnessData4;
                            }
                            if(childDataThree[l]["business5"].toString()!="[]"){
                              BuisnessData buisnessData5 = new BuisnessData();
                              buisnessData5.id = childDataThree[l]["business5"]["id"].toString();
                              buisnessData5.name =" @ "+ childDataThree[l]["business5"]["business_name"].toString();
                              buisnessData5.image = childDataThree[l]["business5"]["image"].toString();
                              childrenModelThree.business5 = buisnessData5;
                            }

                            var difference = date2
                                .difference(DateTime.parse(
                                    childrenModelThree.created_at))
                                .inSeconds;
                            childrenModelThree.timedelay =
                                difference.toString() + " seconds ago";
                            if (difference > 60) {
                              var difference = date2
                                  .difference(DateTime.parse(
                                      childrenModelThree.created_at))
                                  .inMinutes;
                              childrenModelThree.timedelay =
                                  difference.toString() + " minutes ago";

                              if (difference > 60) {
                                var difference = date2
                                    .difference(DateTime.parse(
                                        childrenModelThree.created_at))
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

          getReplyOnHotspotList.add(modelAgentSearch);

          // setState(() {});
        }

        setState(() {
          isloading = false;
          if(selectedIndex>-1){
            getReplyOnHotspotList[selectedIndex].viewV = true;

          }

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
        _refreshController.refreshCompleted(resetFooterState: false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  ListView replyCard(int i) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: getReplyOnHotspotList[i].childrenList.length,
      itemBuilder: (BuildContext context, int index) {
        return Visibility(
          visible: getReplyOnHotspotList[i].viewV,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            color: kBackgroundColor,
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
                            padding: EdgeInsets.only(bottom: 2.h, left: 1.w),
                            child: CircleAvatar(
                              radius: 6.w,
                              backgroundImage: NetworkImage(getReplyOnHotspotList[i]
                                  .childrenList[index]
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 74.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    fontSize:
                                                    11.sp,
                                                    color:
                                                    kCyanColor,
                                                    fontFamily:
                                                    "Segoepr"),
                                                children: [
                                                  TextSpan(
                                                      text:  getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .userProfile!
                                                          .name
                                                          .toString() !=
                                                          "null"
                                                          ?getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .userProfile!
                                                          .name
                                                          .toString()
                                                          : "User Name"),
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[index]
                                                      .business!=null?TextSpan(
                                                      text: getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .business!.name
                                                          .toString(),
                                                      recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap =
                                                            () {
                                                          NotificationModel model = NotificationModel();
                                                          model.review_id = getReplyOnHotspotList[i]
                                                              .childrenList[index].business!.id;
                                                          model.reply_id = "";
                                                          model.type = "business";

                                                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);


                                                        }):TextSpan(text: ""),
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[index]
                                                      .business2!=null?TextSpan(
                                                      text: getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .business2!.name
                                                          .toString(),
                                                      recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap =
                                                            () {
                                                          NotificationModel model = NotificationModel();
                                                          model.review_id = getReplyOnHotspotList[i]
                                                              .childrenList[index].business2!.id;
                                                          model.reply_id = "";
                                                          model.type = "business";

                                                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                        }):TextSpan(text: ""),
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[index]
                                                      .business3!=null?TextSpan(
                                                      text: getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .business3!.name
                                                          .toString(),
                                                      recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap =
                                                            () {
                                                          NotificationModel model = NotificationModel();
                                                          model.review_id = getReplyOnHotspotList[i]
                                                              .childrenList[index].business3!.id;
                                                          model.reply_id = "";
                                                          model.type = "business";

                                                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                        }):TextSpan(text: ""),
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[index]
                                                      .business4!=null?TextSpan(
                                                      text: getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .business4!.name
                                                          .toString(),
                                                      recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap =
                                                            () {
                                                          NotificationModel model = NotificationModel();
                                                          model.review_id = getReplyOnHotspotList[i]
                                                              .childrenList[index].business4!.id;
                                                          model.reply_id = "";
                                                          model.type = "business";

                                                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                        }):TextSpan(text: ""),
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[index]
                                                      .business5!=null?TextSpan(
                                                      text: getReplyOnHotspotList[i]
                                                          .childrenList[index]
                                                          .business5!.name
                                                          .toString(),
                                                      recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap =
                                                            () {
                                                          NotificationModel model = NotificationModel();
                                                          model.review_id =  getReplyOnHotspotList[i]
                                                              .childrenList[index].business5!.id;
                                                          model.reply_id = "";
                                                          model.type = "business";

                                                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);


                                                        }):TextSpan(text: "")
                                                ])),
                                      ),
                                      /*   Text(
                                        //"Person Name @ Bar Name",
                                        getReplyOnHotspotList[i]
                                            .childrenList[index]
                                            .userProfile!
                                            .name
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: kCyanColor,
                                            fontFamily: "Segoepr"),
                                      ),*/
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
                                    //  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                    getReplyOnHotspotList[i]
                                        .childrenList[index]
                                        .message
                                        .toString(),
                                    style: TextStyle(
                                      //overflow: TextOverflow.ellipsis,
                                        fontSize: 8.5.sp,
                                        color: Colors.white,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),

                                // SizedBox(
                                //   height: 1.h,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      getReplyOnHotspotList[i]
                          .childrenList[index]
                          .video_image_status
                          .toString() ==
                          "2"? SizedBox(
                          height: 200,
                          child: VideoItems(
                            videoPlayerController: VideoPlayerController.network(getReplyOnHotspotList[i]
                                .childrenList[index]
                                .image[0]),

                          )


                        //  VideoWidget(
                        //   url: getReplyOnHotspotList[i]
                        //       .childrenList[index]
                        //       .image,
                        //   play: true,
                        // ),
                      ):Container(),
                      getReplyOnHotspotList[i]
                          .childrenList[index]
                          .video_image_status
                          .toString() ==
                          "1"?HotspotImageSlider(
                        items: getReplyOnHotspotList[i]
                            .childrenList[index]
                            .image,


                      ):Container(),
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
                              // "2m ago",

                              getReplyOnHotspotList[i]
                                  .childrenList[index]
                                  .timedelay
                                  .toString(),
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: kPrimaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    viewVisible = true;
                                    tabOne = getReplyOnHotspotList[i]
                                        .childrenList[index]
                                        .id
                                        .toString();
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  "Reply",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,
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
                  itemCount: getReplyOnHotspotList[i]
                      .childrenList[index]
                      .childrenList
                      .length,
                  itemBuilder: (BuildContext context, int k) {
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.w)),
                        elevation: 0,
                        color: kBackgroundColor,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(bottom: 2.h, left: 0.w),
                                        child: CircleAvatar(
                                          radius: 4.w,
                                          backgroundImage: NetworkImage(
                                              getReplyOnHotspotList[i]
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
                                                  Expanded(
                                                    child: RichText(
                                                        text: TextSpan(
                                                            style: TextStyle(
                                                                fontSize:
                                                                11.sp,
                                                                color:
                                                                kCyanColor,
                                                                fontFamily:
                                                                "Segoepr"),
                                                            children: [
                                                              TextSpan(
                                                                  text:   getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .userProfile!
                                                                      .name
                                                                      .toString() !=
                                                                      "null"
                                                                      ?getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .userProfile!
                                                                      .name
                                                                      .toString()
                                                                      : "User Name"),
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[index]
                                                                  .childrenList[k]
                                                                  .business!=null?TextSpan(
                                                                  text: getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .business!.name
                                                                      .toString(),
                                                                  recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      NotificationModel model = NotificationModel();
                                                                      model.review_id =  getReplyOnHotspotList[i]
                                                                          .childrenList[index].childrenList[k].business!.id;
                                                                      model.reply_id = "";
                                                                      model.type = "business";

                                                                      Navigator.pushNamed(context, "/detailedbusiness", arguments: model);


                                                                    }):TextSpan(text: ""),
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[index]
                                                                  .childrenList[k]
                                                                  .business2!=null?TextSpan(
                                                                  text: getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .business2!.name
                                                                      .toString(),
                                                                  recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      NotificationModel model = NotificationModel();
                                                                      model.review_id = getReplyOnHotspotList[i]
                                                                          .childrenList[index].childrenList[k].business2!.id;
                                                                      model.reply_id = "";
                                                                      model.type = "business";

                                                                      Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                    }):TextSpan(text: ""),
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[index]
                                                                  .childrenList[k]
                                                                  .business3!=null?TextSpan(
                                                                  text: getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .business3!.name
                                                                      .toString(),
                                                                  recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      NotificationModel model = NotificationModel();
                                                                      model.review_id = getReplyOnHotspotList[i]
                                                                          .childrenList[index].childrenList[k].business3!.id;
                                                                      model.reply_id = "";
                                                                      model.type = "business";

                                                                      Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                    }):TextSpan(text: ""),
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[index]
                                                                  .childrenList[k]
                                                                  .business4!=null?TextSpan(
                                                                  text: getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .business4!.name
                                                                      .toString(),
                                                                  recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      NotificationModel model = NotificationModel();
                                                                      model.review_id = getReplyOnHotspotList[i]
                                                                          .childrenList[index].childrenList[k].business4!.id;
                                                                      model.reply_id = "";
                                                                      model.type = "business";

                                                                      Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                    }):TextSpan(text: ""),
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[index]
                                                                  .childrenList[k]
                                                                  .business5!=null?TextSpan(
                                                                  text: getReplyOnHotspotList[i]
                                                                      .childrenList[index]
                                                                      .childrenList[k]
                                                                      .business5!.name
                                                                      .toString(),
                                                                  recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      NotificationModel model = NotificationModel();
                                                                      model.review_id =   getReplyOnHotspotList[i]
                                                                          .childrenList[index].childrenList[k].business5!.id;
                                                                      model.reply_id = "";
                                                                      model.type = "business";

                                                                      Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                    }):TextSpan(text: "")
                                                            ])),
                                                  ),
                                                  /*     Text(
                                                    //  "Person Name @ Bar Name",
                                                    getReplyOnHotspotList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .userProfile!
                                                        .name
                                                        .toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: kCyanColor,
                                                        fontFamily: "Segoepr"),
                                                  ),*/
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
                                                getReplyOnHotspotList[i]
                                                    .childrenList[index]
                                                    .childrenList[k]
                                                    .message
                                                    .toString(),
                                                style: TextStyle(
                                                  //overflow: TextOverflow.ellipsis,
                                                    fontSize: 8.5.sp,
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  getReplyOnHotspotList[i]
                                      .childrenList[index]
                                      .childrenList[k]
                                      .video_image_status
                                      .toString() ==
                                      "2"?SizedBox(
                                      height: 200,
                                      width: 35.h,
                                      child:VideoItems(
                                        videoPlayerController: VideoPlayerController.network(getReplyOnHotspotList[i]
                                            .childrenList[index]
                                            .childrenList[k]
                                            .image[0]),

                                      )




                                  ):Container(width: 0, height: 0,),
                                  getReplyOnHotspotList[i]
                                      .childrenList[index]
                                      .childrenList[k]
                                      .video_image_status
                                      .toString() ==
                                      "1"?SizedBox(
                                    height: 200,
                                    child: HotspotImageSlider(
                                        items: getReplyOnHotspotList[i]
                                            .childrenList[index]
                                            .childrenList[k]
                                            .image


                                    ),
                                  ):Container(width: 0, height: 0,),
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
                                          // "2m ago",
                                          getReplyOnHotspotList[i]
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
                                          padding:
                                          EdgeInsets.only(right: 5.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                viewVisible = true;
                                                selectedIndex = index;
                                                tabOne =
                                                    getReplyOnHotspotList[i]
                                                        .childrenList[
                                                    index]
                                                        .childrenList[k]
                                                        .id
                                                        .toString();
                                              });
                                            },
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            ),


                            ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              itemCount: getReplyOnHotspotList[i]
                                  .childrenList[index]
                                  .childrenList[k]
                                  .childrenList
                                  .length,
                              itemBuilder: (BuildContext context, int j) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(0.w)),
                                    elevation: 0,
                                    color: kBackgroundColor,
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
                                                child: CircleAvatar(
                                                  radius: 4.w,
                                                  backgroundImage: NetworkImage(
                                                    getReplyOnHotspotList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .childrenList[j]
                                                        .userProfile!
                                                        .image
                                                        .toString(),
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
                                                            /*  Text(
                                                              // "Person Name @ Bar Name",
                                                              getReplyOnHotspotList[i]
                                                                  .childrenList[
                                                                      index]
                                                                  .childrenList[k]
                                                                  .childrenList[j]
                                                                  .userProfile!
                                                                  .name
                                                                  .toString(),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 10.sp,
                                                                  color: kCyanColor,
                                                                  fontFamily:
                                                                      "Segoepr"),
                                                            ),*/

                                                            Expanded(
                                                              child: RichText(
                                                                  text: TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          11.sp,
                                                                          color:
                                                                          kCyanColor,
                                                                          fontFamily:
                                                                          "Segoepr"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:   getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .userProfile!
                                                                                .name
                                                                                .toString() !=
                                                                                "null"
                                                                                ?getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .userProfile!
                                                                                .name
                                                                                .toString()
                                                                                : "User Name"),
                                                                        getReplyOnHotspotList[i]
                                                                            .childrenList[index]
                                                                            .childrenList[k]
                                                                            .childrenList[j]
                                                                            .business!=null?TextSpan(
                                                                            text: getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .business!.name
                                                                                .toString(),
                                                                            recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap =
                                                                                  () {
                                                                                NotificationModel model = NotificationModel();
                                                                                model.review_id =  getReplyOnHotspotList[i]
                                                                                    .childrenList[index].childrenList[k].childrenList[j].business!.id;
                                                                                model.reply_id = "";
                                                                                model.type = "business";

                                                                                Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                              }):TextSpan(text: ""),
                                                                        getReplyOnHotspotList[i]
                                                                            .childrenList[index]
                                                                            .childrenList[k]
                                                                            .childrenList[j]
                                                                            .business2!=null?TextSpan(
                                                                            text: getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .business2!.name
                                                                                .toString(),
                                                                            recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap =
                                                                                  () {
                                                                                NotificationModel model = NotificationModel();
                                                                                model.review_id =   getReplyOnHotspotList[i]
                                                                                    .childrenList[index].childrenList[k].childrenList[j].business2!.id;
                                                                                model.reply_id = "";
                                                                                model.type = "business";

                                                                                Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                              }):TextSpan(text: ""),
                                                                        getReplyOnHotspotList[i]
                                                                            .childrenList[index]
                                                                            .childrenList[k]
                                                                            .childrenList[j]
                                                                            .business3!=null?TextSpan(
                                                                            text: getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .business3!.name
                                                                                .toString(),
                                                                            recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap =
                                                                                  () {
                                                                                NotificationModel model = NotificationModel();
                                                                                model.review_id = getReplyOnHotspotList[i]
                                                                                    .childrenList[index].childrenList[k].childrenList[j].business3!.id;
                                                                                model.reply_id = "";
                                                                                model.type = "business";

                                                                                Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                              }):TextSpan(text: ""),
                                                                        getReplyOnHotspotList[i]
                                                                            .childrenList[index]
                                                                            .childrenList[k]
                                                                            .childrenList[j]
                                                                            .business4!=null?TextSpan(
                                                                            text: getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .business4!.name
                                                                                .toString(),
                                                                            recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap =
                                                                                  () {
                                                                                NotificationModel model = NotificationModel();
                                                                                model.review_id =  getReplyOnHotspotList[i]
                                                                                    .childrenList[index].childrenList[k].childrenList[j].business4!.id;
                                                                                model.reply_id = "";
                                                                                model.type = "business";

                                                                                Navigator.pushNamed(context, "/detailedbusiness", arguments: model);


                                                                              }):TextSpan(text: ""),
                                                                        getReplyOnHotspotList[i]
                                                                            .childrenList[index]
                                                                            .childrenList[k]
                                                                            .childrenList[j]
                                                                            .business5!=null?TextSpan(
                                                                            text: getReplyOnHotspotList[i]
                                                                                .childrenList[index]
                                                                                .childrenList[k]
                                                                                .childrenList[j]
                                                                                .business5!.name
                                                                                .toString(),
                                                                            recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap =
                                                                                  () {
                                                                                NotificationModel model = NotificationModel();
                                                                                model.review_id =   getReplyOnHotspotList[i]
                                                                                    .childrenList[index].childrenList[k].childrenList[j].business5!.id;
                                                                                model.reply_id = "";
                                                                                model.type = "business";

                                                                                Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                                                                              }):TextSpan(text: "")
                                                                      ])),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.1.h,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            right: 0.w),
                                                        child: Container(
                                                          width: 70.w,
                                                          child: Text(
                                                            // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                                                            getReplyOnHotspotList[i]
                                                                .childrenList[index]
                                                                .childrenList[k]
                                                                .childrenList[j]
                                                                .message
                                                                .toString(),
                                                            style: TextStyle(
                                                              //overflow: TextOverflow.ellipsis,
                                                                fontSize: 8.5.sp,
                                                                color: Colors.white,
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
                                          getReplyOnHotspotList[i]
                                              .childrenList[index]
                                              .childrenList[k]
                                              .childrenList[j]
                                              .video_image_status
                                              .toString() ==
                                              "2"? SizedBox(
                                              height: 200,
                                              width: 35.h,
                                              child: VideoItems(
                                                videoPlayerController: VideoPlayerController.network(getReplyOnHotspotList[i]
                                                    .childrenList[index]
                                                    .childrenList[k]
                                                    .childrenList[j]
                                                    .image[0]
                                                ),

                                              )



                                          ):Container(),
                                          getReplyOnHotspotList[i]
                                              .childrenList[index]
                                              .childrenList[k]
                                              .childrenList[j]
                                              .video_image_status
                                              .toString() ==
                                              "1"?HotspotImageSlider(
                                            items:getReplyOnHotspotList[i]
                                                .childrenList[index]
                                                .childrenList[k]
                                                .childrenList[j]
                                                .image
                                            ,


                                          ):Container(),
                                          SizedBox(
                                            height: 1.h,
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
                                                  getReplyOnHotspotList[i]
                                                      .childrenList[
                                                  index]
                                                      .childrenList[k]
                                                      .childrenList[j]
                                                      .timedelay
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                    color:
                                                    kPrimaryColor,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        right: 6.w),
                                                    child:
                                                    GestureDetector(
                                                      onTap: () {
                                                        /*   setState(() {
                                                    viewVisible = true;
                                                    tabOne = getReplyOnHotspotList[i]
                                                        .childrenList[index].childrenList[k].childrenList[j].id
                                                        .toString();
                                                  });
        */
                                                      },
                                                      child: Text(
                                                        "Reply",
                                                        style: TextStyle(
                                                            fontSize:
                                                            10.sp,
                                                            color: Colors
                                                                .white,
                                                            fontFamily:
                                                            "Roboto"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 2.h,)
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
            title:SingleChildScrollView(
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
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                             file = null;
      fileName = "";
      base64Image = "";
      image_video_status = "0";
      fileList.clear();
      images.clear();
      currentPath = "";

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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                snackBar,
                              );
                            } else {
                              File file1;
                              FilePickerResult? result =
                                  await FilePicker.platform
                                  .pickFiles(
                                type: FileType.video,
                                allowCompression: false,
                              );
                              if (result != null) {

                                file1 = File(
                                    result.files.single.path!);



                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return TrimmerView(file1);
                                      }),
                                );
                                Navigator.of(context,
                                    rootNavigator: true)
                                    .pop();
                                if (currentPath != "") {

                                  file = File(currentPath.toString());
                                  fileName = path.basename(file!.path);
                                  print("Filename " + fileName.toString());
                                  image_video_status = "2";
                                  if (fileName == "" ||
                                      fileName == null) {
                                    fileName = "File:- ";
                                    viewVisible = true;
                                  } else {
                                    fileName = "File:- " + fileName;
                                    viewVisible = true;
                                  }
                                  setState(() {

                                  });
                                }else{
                                  file = null;
                                  fileName = "";
                                  image_video_status = "0";
                                  setState(() {

                                  });
                                }
                              }
                            }
                          })
                    ],
                  ),
                ))


          );
      },
    );
  }

  Future<void> pickImagess() async {
    await pickImages().then((value) {
        images = value;
        print("lengthhhhhh "+images.length.toString()+"*");

    });
      if(images.length>0){
        image_video_status = "1";
        images.forEach((element) async{

          var path =  await FlutterAbsolutePath.getAbsolutePath(element.identifier.toString());
          print("pathhh "+path.toString()+"*");

          file = File(path.toString());
          fileName = file!.path.split("/").last;
          fileList.add(file!);
          setState(() {


          });
        });
        Navigator.pop(context);

      }else{
        image_video_status = "0";
        images.clear();
      }




  }
  Future<dynamic> getallBusinessDataApi() async {
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

  Future getCheckInImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        image_video_status = "1";
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
      image_video_status = "0";
    }

    fileName = file!.path.split("/").last;
    print("ImageName: " + fileName.toString() + "_");
    print("Image: " + base64Image.toString() + "_");
    Navigator.pop(context);

  }

  Future getImagePath() async {
    if(currentPath==""){
      getImagePath();
    }else{
      return currentPath;
    }
  }

  Future<dynamic> getDetailsofReview() async {
    print("Widget Id " + review_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(
      Uri.parse(RestDatasource.GETHOTSPOTDETAILBYID +
          // "3"
          review_id.toString() ),
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
      final date2 = DateTime.now();
      print(jsonRes["status"]);
      if (jsonRes["status"].toString() == "true") {

        detail.reviewId = jsonRes["data"]["id"].toString();
        detail.buisness_id = jsonRes["data"]["business_id"].toString();
        detail.business_id2 = jsonRes["data"]["business_id2"].toString();
        detail.business_id3 = jsonRes["data"]["business_id3"].toString();
        detail.business_id4 = jsonRes["data"]["business_id4"].toString();
        detail.business_id5 = jsonRes["data"]["business_id5"].toString();
        detail.business_name1 = jsonRes["data"]["business_name1"].toString();
        detail.business_name2 = jsonRes["data"]["business_name2"].toString();
        detail.business_name3 = jsonRes["data"]["business_name3"].toString();
        detail.business_name4 = jsonRes["data"]["business_name4"].toString();
        detail.business_name5 = jsonRes["data"]["business_name5"].toString();
        detail.review = jsonRes["data"]["message"].toString();
        detail.review_user_name = jsonRes["data"]["name"].toString();
        detail.image = jsonRes["data"]["image"];
        detail.user_image = jsonRes["data"]["user_image"].toString();
        detail.image_video_status = jsonRes["data"]["image_video_status"].toString();


        var difference = date2
            .difference(DateTime.parse(jsonRes["data"]["created_at"].toString()))
            .inSeconds;
        detail.timeDelay = difference.toString() + " seconds ago";
        if (difference > 60) {
          var difference = date2
              .difference(DateTime.parse(jsonRes["data"]["created_at"].toString()))
              .inMinutes;
          detail.timeDelay = difference.toString() + " minutes ago";

          if (difference > 60) {
            var difference = date2
                .difference(DateTime.parse(jsonRes["data"]["created_at"].toString()))
                .inHours;
            detail.timeDelay = difference.toString() + " hours ago";
            if (difference > 24) {
              detail.timeDelay =
                  jsonRes["data"]["created_at"].toString().toString().substring(0, 10);
            }
          }
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
}
class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = '${context.watch<Counter>().count}';

    return Visibility(
      visible: count.toString() == "0" ? false : true,
      child: Positioned(
        top: -3,
        right: 0,
        child: Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: Color(0xFFFF4848),
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: Colors.white),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                height: 1,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class GETREPLYONHOTSPOT {
  UserData? userProfile;
  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";
  List<dynamic>image = [];
  var video_image_status = "";
  bool viewV = false;
  var timedelay = "Secconds";
  List<GETREPLYONHOTSPOT> childrenList = [];
  List<GETREPLYONHOTSPOT> childrenSubList = [];

  BuisnessData? business ;
  BuisnessData? business2 ;
  BuisnessData? business3 ;
  BuisnessData? business4 ;
  BuisnessData? business5 ;


}

class UserData {
  var id = "";
  var name = "";
  var image = "";
}

class BuisnessData {
  var id = "";
  var name = "";
  var image = "";
}
