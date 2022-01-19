import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/components/slider_image.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/screens/hotSpotReply.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/screens/testing.dart';
import 'package:wemarkthespot/screens/testing_overlay.dart';
import 'package:wemarkthespot/screens/testingsheet.dart';
import 'package:wemarkthespot/screens/video_player_widget.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:multi_image_picker/multi_image_picker.dart';

import '../main.dart';
import 'detailBusinessdynamic.dart';

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
  bool reviewEnable = true;
  ScrollController _controller = new ScrollController();
  TextEditingController mesageTextController = new TextEditingController();
  TextEditingController businessNameController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();
  List<Asset> images = [];
  List<File> fileList = [];




  List<GetHotSpotClass> getHostSpotList = [];
  List<GetHotSpotClass> getHostSpotList2 = [];
  List<GetHotSpotClass> searchList = [];
  var image_video_status = "0";
  var reply_image_video_status = "0";
  final picker = ImagePicker();
  File? file;
  File? replyfile;
  String base64Image = "";
  String fileName = "";
  String replyfileName = "";

  List<GetAllBusiness> getAllBusinessList = [];
  List<String> coments = [];
  var words = [];
  String str = '';
  String selectedName = "";
  String selectedvalue = "";
  @override
  void initState() {
    getId();
    getHotspotApi();
    getallBusinessDataApi();
    super.initState();
  }

  late var size;

  late var _height;

  void _scrollToIndex(index) {
    _controller.animateTo(_height * index,
        duration: Duration(seconds: 2), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    _height = size.height;

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
      body: isloading
          ? Align(
              alignment: Alignment.center,
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator())
          : Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  controller: _controller,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      height: 7.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.w),
                          color: Colors.white),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                          controller: mesageTextController,
                          onChanged: (value) {
                            if (value.length > 0) {
                              getHostSpotList.clear();
                              searchData(value.toString());
                            } else {
                              getHostSpotList.clear();
                              getHotspotApi();
                            }
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
                            contentPadding: EdgeInsets.all(0.h),
                            hintText: "Search",
                            hintStyle: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                            suffixIcon: InkWell(
                                onTap: () {
                                  mesageTextController.clear();
                                  getHostSpotList.clear();
                                  print("Clicked");
                                  getHotspotApi();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/cross.svg",
                                  width: 4.w,
                                  color: kPrimaryColor,
                                )),
                            prefixIcon: SvgPicture.asset(
                              "assets/icons/-search.svg",
                              width: 24,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: CachedNetworkImage(
                                            imageUrl: getHostSpotList[index]
                                                .user_image
                                                .toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
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
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
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
                                                                text: getHostSpotList[
                                                                        index]
                                                                    .person_name
                                                                    .toString()),
                                                            TextSpan(
                                                                text: getHostSpotList[
                                                                        index]
                                                                    .business_user_name
                                                                    .toString(),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                        Navigator.of(context).push(new MaterialPageRoute(
                                                                            builder: (builder) =>
                                                                                DetailBussinessDynamic(id: getHostSpotList[index].business_id)));
                                                                      }),
                                                          ])),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 2.w),
                                                      child: Text(
                                                        //  "2m ago",

                                                        getHostSpotList[index]
                                                            .timedelay
                                                            .toString(),

                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    getHostSpotList[index]
                                        .video_image_status
                                        .toString() ==
                                        "2"?SizedBox(
                                        height: 200,
                                        child: VideoItems(
                                          videoPlayerController: VideoPlayerController.network(getHostSpotList[index].image[0]),

                                        )):getHostSpotList[index]
                                        .video_image_status
                                        .toString() ==
                                        "1"?
                                    HotspotImageSlider(
                                      items:getHostSpotList[index]
                                                .image
                                    ,
                                    ):Container(width: 0, height: 0,),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 9.w),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HotSpotReply(
                                                      id: getHostSpotList[index]
                                                          .id
                                                          .toString(),
                                                      username:
                                                          getHostSpotList[index]
                                                              .person_name
                                                              .toString(),
                                                      businessname:
                                                          getHostSpotList[index]
                                                              .business_user_name
                                                              .toString()
                                                              .replaceAll(
                                                                  "@", "")
                                                              .trim(),
                                                      image:
                                                          getHostSpotList[index]
                                                              .user_image
                                                              .toString(),
                                                      message:
                                                          getHostSpotList[index]
                                                              .message
                                                              .toString(),
                                                      time:
                                                          getHostSpotList[index]
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: SizedBox(
                                            width: 60.w,
                                            child: TextField(
                                              controller: messageController,
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
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.h,
                                                          horizontal: 4.w),
                                                  fillColor: Colors.black,
                                                  filled: true,
                                                  hintText: "Reply",
                                                  suffixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              getHostSpotList[index].reply_image_video_status =
                                                                  "0";
                                                              getHostSpotList[index].replyfile = null;
                                                              getHostSpotList[index].replyfileName = "";
                                                              currentPath = "";
                                                              setState(() {});
                                                              getFileDialogReply(index);
                                                            },
                                                            child: Icon(
                                                                Icons
                                                                    .add_circle_outline,
                                                                color:
                                                                    kPrimaryColor)),

                                                        SizedBox(width: 2.w),

                                                        InkWell(
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
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                replyOnHotspotReviewApi(
                                                                    getHostSpotList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    getHostSpotList[
                                                                            index]
                                                                        .messageText
                                                                        .toString(),
                                                                    index);
                                                              }

                                                              messageController
                                                                  .clear();
                                                            },
                                                            child: Icon(
                                                                Icons.send,
                                                                color:
                                                                    kPrimaryColor)),
                                                        //  SizedBox(width: 1.h,),
                                                      ],
                                                    ),
                                                  ),
                                                  hintStyle: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    getHostSpotList[index].reply_image_video_status=="1"?Visibility(
                                      visible: getHostSpotList[index].replyfileList!=null?getHostSpotList[index].replyfileList.length>0?true:false:false,
                                      child: Container(
                                        height: 8.h,
                                        width: 80.w,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          controller: _controller,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: getHostSpotList[index].replyfileList.length==0?0:getHostSpotList[index].replyfileList.length,
                                          itemBuilder: (BuildContext context,
                                              int i) {
                                            return Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 7.h,
                                                      width: 9.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.w),
                                                          image: DecorationImage(
                                                              image: FileImage(getHostSpotList[index].replyfileList[i]),
                                                              fit:
                                                                  BoxFit.fill)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2.0, left: 14.w),
                                                      child: Container(
                                                        height: 2.h,
                                                        width: 2.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white),
                                                        child: Center(
                                                          child: InkWell(
                                                            onTap: () {
                                                              getHostSpotList[index].replyfileList.removeAt(i);
                                                              getHostSpotList[index].replyimages.removeAt(i);
                                                              setState(() {

                                                              });
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/icons/cross.svg",
                                                              width: 8,
                                                              color:
                                                                  Colors.black,
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
                                    ):Container(width: 0,height: 0,),
                                    getHostSpotList[index].reply_image_video_status=="2"? Visibility(
                                      visible: true,
                                      child: Container(
                                        height: 8.h,
                                        width: 80.w,
                                        child: Center(child: Text(getHostSpotList[index].replyfile!.path.toString(), style: TextStyle(color: Colors.white),)),
                                      ),
                                    ):Container(width: 0,height: 0,),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              str.length > 1
                  ? ListView(
                      shrinkWrap: true,
                      children: getAllBusinessList.map((s) {
                        if (('@' + s.business_name.toString().toLowerCase())
                            .contains(str.toString().toLowerCase()))
                          return Container(
                            color: Colors.white,
                            child: ListTile(
                                title: Text(
                                  s.business_name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  String tmp = str.substring(1, str.length);
                                  print("tmp " + tmp.toString() + "^");
                                  selectedId = s.business_id;
                                  setState(() {
                                    reviewController.text = reviewController
                                        .text
                                        .toString()
                                        .substring(
                                            0,
                                            reviewController.text
                                                    .toString()
                                                    .length -
                                                tmp.length);
                                    reviewController.text += s.business_name;
                                    //reviewController.text += s.business_name.substring(s.business_name.indexOf(tmp)+tmp.length,s.business_name.length).replaceAll(' ','_');

                                    reviewController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                reviewController.text.length));
                                    str = '';
                                  });
                                }),
                          );
                        else
                          return SizedBox();
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
                  visible: file == null ? false : true,
                  child: file != null
                      ? image_video_status == "1"
                          ? Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Colors.black),
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
                                                            
                                                          }
                                                          setState(() {

                                                          });
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
                                  //   flex: 8,
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
                                    flex: 2,
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
                            )
                          : Container(
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
                            )
                      : Container(
                          color: Colors.white,
                          height: 100,
                        )),
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
                      width: 80.w,
                      height: 6.h,
                      child: TextField(
                        controller: reviewController,
                        onChanged: (val) {
                          setState(() {
                            words = val.split(' ');
                            str = words.length > 0 &&
                                    words[words.length - 1].startsWith('@')
                                ? words[words.length - 1]
                                : '';
                          });
                        },
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 0.h),
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          fillColor: kPrimaryColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: kPrimaryColor)),
                          hintText: "Leave a message...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                          suffixIcon: Visibility(
                            visible: reviewController.text.toString() == "" ||
                                    reviewController.text.toString() == "null"
                                ? false
                                : true,
                            child: InkWell(
                                onTap: () {
                                  var mesage = reviewController.text.toString();

                                  if (reviewEnable == true) {
                                    if (mesage == "" || mesage == "null") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Please write message")));
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      print(image_video_status);
                                      addHotspotReviewApi(
                                          reviewController.text.toString(),
                                          selectedId.toString());
                                    }
                                  }

                                  reviewController.text.toString() == "";
                                },
                                child: Icon(Icons.send,
                                    size: 9.w, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(left: 6.w),
      //   child: buildMessageFormField(),
      // ),
    );
  }

  Column buildMessageFormField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visibility(
        //     visible: file == null ? false : true,
        //     child: file != null
        //         ? image_video_status == "1"
        //             ? Container(
        //                 height: 150,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.only(
        //                         topLeft: Radius.circular(10),
        //                         topRight: Radius.circular(10)),
        //                     color: kBackgroundColor),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.end,
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     SizedBox(
        //                       width: 5.h,
        //                     ),
        //                     Flexible(
        //                       flex: 8,
        //                       child: Center(
        //                         child: Container(
        //                             height: 150,
        //                             child: Image.file(
        //                               file!,
        //                               height: 80,
        //                             )),
        //                       ),
        //                     ),
        //                     Flexible(
        //                       flex: 2,
        //                       child: Column(
        //                         children: [
        //                           Flexible(
        //                             flex: 8,
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(8.0),
        //                               child: InkWell(
        //                                 onTap: () {
        //                                   setState(() {
        //                                     file = null;
        //                                     fileName = "";
        //                                     base64Image = "";
        //                                     image_video_status = "0";
        //                                     currentPath = "";
        //                                   });
        //                                 },
        //                                 child: Padding(
        //                                   padding:
        //                                       const EdgeInsets.only(right: 5.0),
        //                                   child: SvgPicture.asset(
        //                                     "assets/icons/cross.svg",
        //                                     color: Colors.white,
        //                                     width: 4.w,
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                           Flexible(flex: 2, child: Container())
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               )
        //             : Container(
        //                 height: 100,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.only(
        //                         topLeft: Radius.circular(10),
        //                         topRight: Radius.circular(10)),
        //                     color: kBackgroundColor),
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.all(8.0),
        //                           child: InkWell(
        //                             onTap: () {
        //                               setState(() {
        //                                 file = null;
        //                                 fileName = "";
        //                                 base64Image = "";
        //                                 image_video_status = "0";
        //                                 currentPath = "";
        //                               });
        //                             },
        //                             child: Padding(
        //                               padding:
        //                                   const EdgeInsets.only(right: 5.0),
        //                               child: SvgPicture.asset(
        //                                 "assets/icons/cross.svg",
        //                                 color: Colors.white,
        //                                 width: 4.w,
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(
        //                       height: 1.5.h,
        //                     ),
        //                     Container(
        //                       width: MediaQuery.of(context).size.width,
        //                       height: 50,
        //                       child: Padding(
        //                         padding: const EdgeInsets.only(left: 8.0),
        //                         child: Text(
        //                           fileName,
        //                           maxLines: 3,
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               )
        //         : Container(
        //             color: Colors.white,
        //             height: 100,
        //           )),
        str.length > 1
            ? ListView(
                shrinkWrap: true,
                children: getAllBusinessList.map((s) {
                  if (('@' + s.business_name.toString().toLowerCase())
                      .contains(str.toString().toLowerCase()))
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                          title: Text(
                            s.business_name,
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            String tmp = str.substring(1, str.length);
                            print("tmp " + tmp.toString() + "^");
                            selectedId = s.business_id;
                            setState(() {
                              reviewController.text = reviewController.text
                                  .toString()
                                  .substring(
                                      0,
                                      reviewController.text.toString().length -
                                          tmp.length);
                              reviewController.text += s.business_name;
                              //reviewController.text += s.business_name.substring(s.business_name.indexOf(tmp)+tmp.length,s.business_name.length).replaceAll(' ','_');

                              reviewController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: reviewController.text.length));
                              str = '';
                            });
                          }),
                    );
                  else
                    return SizedBox();
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
        TextField(
          controller: reviewController,
          onChanged: (val) {
            setState(() {
              words = val.split(' ');
              str = words.length > 0 && words[words.length - 1].startsWith('@')
                  ? words[words.length - 1]
                  : '';
            });
          },
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      image_video_status = "0";
                      file = null;
                      fileName = "";
                      currentPath = "";
                      getFileDialog();
                    },
                    child: SvgPicture.asset(
                      "assets/icons/attach.svg",
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 2.h,
                ),
                Visibility(
                  visible: reviewController.text.toString() == "" ||
                          reviewController.text.toString() == "null"
                      ? false
                      : true,
                  child: InkWell(
                      onTap: () {
                        var mesage = reviewController.text.toString();

                        if (reviewEnable == true) {
                          if (mesage == "" || mesage == "null") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please write message")));
                          } else {
                            FocusScope.of(context).unfocus();
                            print(image_video_status);
                            addHotspotReviewApi(
                                reviewController.text.toString(),
                                selectedId.toString());
                          }
                        }

                        reviewController.text.toString() == "";
                      },
                      child: Icon(Icons.send, size: 9.w, color: Colors.white)),
                ),
              ],
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
        ),
      ],
    );
    /* return TextFormField(
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
            searchBoxMaxLines: 1,
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
    );*/
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
    print("id Print: " + id.toString());
    print("key Print: " + key.toString());

    getHostSpotList2.forEach((element) {
      print("element data " +
          element.business_user_name.replaceAll("@", "").trim().toLowerCase());
      if (element.business_user_name
          .replaceAll("@", "")
          .trim()
          .toLowerCase()
          .contains(key.toLowerCase())) {
        getHostSpotList.add(element);
      }
    });
    print(getHostSpotList.length);
    setState(() {});

/*    var request = http.post(
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
      print("Res: " + res.toString() + "_");

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
          if(jsonArray[i]["business_id"].toString()=="312"){
            modelAgentSearch.business_user_name ="";
          }else{
            modelAgentSearch.business_user_name =
                " @ "+jsonArray[i]["business_user_name"].toString();
          }
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
        });
      }
    }*/
  }

  Future<dynamic> addHotspotReviewApi(String message,
      [String? sec = '312']) async {
    reviewEnable = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("business_idPrint: " + sec.toString());
    print("message Print: " + reviewController.text.toString());

    setState(() {
      isloading = true;
    });
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.ADDHOTSPOT_URL,
      ),
    );

    request.fields["user_id"] = id.toString();
    request.fields["business_id"] = sec != "" ? sec.toString() : "312";
    request.fields["message"] = reviewController.text;
    request.fields["video_image_status"] = image_video_status;

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

    String msg = "";
    var jsonArray;
    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      reviewEnable = true;
      file = null;
      fileName = "";
      base64Image = "";
      image_video_status = "0";
      selectedId = "";
      images.clear();
      fileList.clear();
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];

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
      String review_id, String messageText, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");

    print("id: " + id.toString());
    print("review_id: " + review_id.toString());
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
    request.fields["reply_id"] = "0";
    request.fields["type"] = "HOTSPOT";
    request.fields["message"] = messageText;
    request.fields["video_image_status"] = getHostSpotList[index].reply_image_video_status;


    if(getHostSpotList[index].reply_image_video_status=="2"){
      request.files.add(await http.MultipartFile.fromPath("image[]", getHostSpotList[index].replyfile!.path));

    }else if(getHostSpotList[index].reply_image_video_status=="1"){
      getHostSpotList[index].replyimages.forEach((element) async {
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
    var jsonRes;
    var jsonArray;
    var res = await request.send();

    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];

      if (jsonRes["status"].toString() == "true") {
        getHostSpotList[index].reply_image_video_status = "0";
        getHostSpotList[index].replyimages.clear();
        getHostSpotList[index].replyfile = null;
        getHostSpotList[index].replyfileName = "";
        getHostSpotList[index].replyfileList.clear();
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
      if(index>1){
        _scrollToIndex(index-1);
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
          if (jsonArray[i]["business_id"].toString() == "312") {
            modelAgentSearch.business_user_name = "";
          } else {
            modelAgentSearch.business_user_name =
                " @ " + jsonArray[i]["business_user_name"].toString();
          }
          modelAgentSearch.video_image_status =
              jsonArray[i]["video_image_status"].toString();
          modelAgentSearch.image = jsonArray[i]["image"] ;
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.user_id = jsonArray[i]["user_id"].toString();
          modelAgentSearch.business_id = jsonArray[i]["business_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();

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

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.person_name.toString());
          print("imageeee: " + modelAgentSearch.image.toString());

          getHostSpotList.add(modelAgentSearch);
          getHostSpotList2.add(modelAgentSearch);
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
                          image_video_status = "0";
                          file = null;
                          fileName = "";
                          currentPath = "";
                          images.clear();
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

                            pickImagesss();

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
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.video,
                            allowCompression: false,
                          );
                          if (result != null) {
                            file = File(result.files.single.path!);
                            fileName = path.basename(file!.path);
                            print("Filename " + fileName.toString() + "^");

                            if (fileName == "" || fileName == null) {
                              fileName = "File:- ";
                            } else {
                              fileName = "File:- " + fileName;
                            }

                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return TrimmerView(file!);
                              }),
                            ).then((value) {
                              Navigator.of(context, rootNavigator: true).pop();
                              setState(() {
                                image_video_status = "2";
                              });
                              Future.delayed(Duration(seconds: 2), () {
                                if (currentPath != "") {
                                  file = File(currentPath.toString());
                                  fileName = path.basename(file!.path);
                                  print("Filename " + fileName.toString());
                                  setState(() {});
                                } else {
                                  file = null;
                                  fileName = "";
                                  image_video_status = "0";
                                  setState(() {});
                                }
                              });
                            });
                          }
                        }
                      })
                ],
              ),
            )));
      },
    );
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
                              getHostSpotList[index].replyimages.clear();
                              getHostSpotList[index].replyfileList.clear();
                              getHostSpotList[index].replyfile = null;
                              getHostSpotList[index].reply_image_video_status = "0";
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
                            if (getHostSpotList[index].reply_image_video_status == "2") {
                              final snackBar = SnackBar(
                                  content: Text(
                                      'Either image or video can be post at a time'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBar,
                              );
                            } else {
                              //getCheckInImage();

                                pickImagess(index);


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
                            if (getHostSpotList[index].reply_image_video_status == "1") {
                              final snackBar = SnackBar(
                                  content: Text(
                                      'Either image or video can be post at a time'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBar,
                              );
                            } else {
                              FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.video,
                                allowCompression: false,
                              );
                              if (result != null) {
                                getHostSpotList[index].replyfile = File(result.files.single.path!);
                                getHostSpotList[index].replyfileName = path.basename(getHostSpotList[index].replyfile!.path);
                                print("Filename " + getHostSpotList[index].replyfileName.toString() + "^");

                                if (getHostSpotList[index].replyfileName == "" || getHostSpotList[index].replyfileName == null) {
                                  getHostSpotList[index].replyfileName = "File:- ";
                                } else {
                                  getHostSpotList[index].replyfileName = "File:- " + getHostSpotList[index].replyfileName;
                                }

                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return TrimmerView(getHostSpotList[index].replyfile!);
                                  }),
                                ).then((value) {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  setState(() {
                                    getHostSpotList[index].reply_image_video_status = "2";
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    if (currentPath != "") {
                                      getHostSpotList[index].replyfile = File(currentPath.toString());
                                      fileName = path.basename(getHostSpotList[index].replyfile!.path);
                                      print("Filename " + getHostSpotList[index].replyfileName.toString());
                                      setState(() {});
                                    } else {
                                      getHostSpotList[index].replyfile = null;
                                      getHostSpotList[index].replyfileName = "";
                                      getHostSpotList[index].reply_image_video_status = "0";
                                      setState(() {});
                                    }
                                  });
                                });
                              }
                            }
                          })
                    ],
                  ),
                )));
      },
    );
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

  void getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id").toString();
  }

  Future<void> pickImagesss() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: false,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Select upto 3 Images",
        ),
      );
      images = resultList;
      if (images.length > 0) {
        image_video_status = "1";
        images.forEach((element) async {
          var path = await FlutterAbsolutePath.getAbsolutePath(
              element.identifier.toString());

          file = File(path.toString());
          fileName = file!.path.split("/").last;
          fileList.add(file!);
        });
      }
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
      image_video_status = "0";
    }

    setState(() {
      print("length " + images.length.toString() + "*");
    });
    print("pathhh " + fileName.toString() + "*");
  }

  Future<void> pickImagess(int index) async {
    await pickImages().then((value) {
      getHostSpotList[index].replyimages = value;
      print("lengthhhhhh "+getHostSpotList[index].replyimages.length.toString()+"*");

    });
    if(getHostSpotList[index].replyimages.length>0){
      getHostSpotList[index].reply_image_video_status = "1";
      getHostSpotList[index].replyimages.forEach((element) async{

        var path =  await FlutterAbsolutePath.getAbsolutePath(element.identifier.toString());
        print("pathhh "+path.toString()+"*");

        getHostSpotList[index].replyfile = File(path.toString());
        getHostSpotList[index].replyfileName = getHostSpotList[index].replyfile!.path.split("/").last;
        getHostSpotList[index].replyfileList.add(getHostSpotList[index].replyfile!);
      });

      setState(() {
        print("lengthhhhhhnewImages "+getHostSpotList[index].replyimages.length.toString()+"*");
        print("lengthhhhhhnew "+getHostSpotList[index].replyfileList.length.toString()+"*");

      });
    }else{
      getHostSpotList[index].reply_image_video_status = "0";
      getHostSpotList[index].replyimages.clear();
    }
    Navigator.pop(context);



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
  List<dynamic> image = [];
  var video_image_status = "";
  var timedelay = "Secconds";
 var reply_image_video_status = "0";
  File? replyfile ;
  var replyfileName = "";
  List<Asset> replyimages = [];
  List<File> replyfileList = [];
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
