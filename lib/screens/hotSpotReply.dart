import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:wemarkthespot/screens/video_player_widget.dart';
import 'package:wemarkthespot/screens/video_player_widget3.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:wemarkthespot/services/modelProvider.dart';

import '../main.dart';

class HotSpotReply extends StatefulWidget {
  var id, image, username, businessname, time, message;

  HotSpotReply(
      {required this.id,
      required this.image,
      required this.username,
      required this.businessname,
      required this.time,
      required this.message});

  @override
  _HotSpotReplyState createState() => _HotSpotReplyState();
}

class _HotSpotReplyState extends State<HotSpotReply> {
  TextEditingController messageController = new TextEditingController();

  bool viewVisible = false;
  final picker = ImagePicker();
  File? file;
  String base64Image = "";
  String fileName = "";

  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool isRefresh = false;

  List<GETREPLYONHOTSPOT> getReplyOnHotspotList = [];
  bool isloading = false;
  ScrollController _controller = new ScrollController();
  var image_video_status = "0";
  var tabOne = "";
  var selectedIndex = -1;
  @override
  void initState() {
    getReplyOnHotspotApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var count = '${context.watch<Counter>().count}';
    print("CurrentPath "+count.toString()+"");
    print("id...." + widget.id.toString());
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
                                        widget.businessname.toString().trim()==""?widget.username.toString():widget.username.toString() +
                                            " @ " +
                                            widget.businessname.toString(),
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

                                      widget.message.toString() != "null"
                                          ? widget.message.toString()
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
                                          widget.time.toString(),
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(right: 2.w),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                viewVisible = true;
                                                tabOne ="0";
                                                selectedIndex = 0;
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
                                                    Text(
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
                                                    ),
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
                                    Visibility(
                                        visible: getReplyOnHotspotList[index]
                                            .video_image_status
                                            .toString() ==
                                            "2"
                                            ? true
                                            : false,
                                        child: SizedBox(
                                            height: 200,
                                            child: VideoWidget(
                                              url: getReplyOnHotspotList[index]
                                                  .image,
                                              play: true,
                                            ))),
                                    Visibility(
                                      visible: getReplyOnHotspotList[index]
                                          .video_image_status
                                          .toString() ==
                                          "1"
                                          ? true
                                          : false,
                                      child: Container(
                                        // height: 48.h,
                                        child: Image.network(
                                          //  "assets/images/lighting.jpeg",
                                          getReplyOnHotspotList[index]
                                              .image
                                              .toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
                                          getReplyOnHotspotList[index]
                                              .viewV
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
                                                getReplyOnHotspotList[
                                                index]
                                                    .viewV = true;
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
                Visibility(
                    visible: file==null?false:true,
                    child:  file!=null? image_video_status == "1"?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(10), topRight:Radius.circular(10)),
                          color: kBackgroundColor
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 5.h,
                            ),
                            Flexible(
                              flex:9,
                              child: Center(
                                child: Container(

                                    height: 150,
                                    child: Image.file(file!, height: 80,)),
                              ),
                            ),

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
                            var messge = messageController.text.toString();

                            if (messge == "" || messge == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please enter reply")));
                            } else {

                              FocusScope.of(context).unfocus();
                              replyOnHotspotReplyApi(tabOne.toString(),
                                  messageController.text.toString());

                            }
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

  Future<dynamic> replyOnHotspotReplyApi(
      String reply_id, String messageText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    print("id: " + id.toString());
    print("review_id: " + widget.id.toString());
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
    request.fields["review_id"] = widget.id.toString();
    request.fields["reply_id"] = reply_id;
    request.fields["type"] = "HOTSPOT";
    request.fields["message"] = messageText;
    request.fields["video_image_status"] = image_video_status;
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath("image", file!.path));
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
    print("getreplyonhotspotapi " + "Running");
    print("widgetid " + widget.id.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = false;
    });

    var request = http.get(
      Uri.parse(RestDatasource.GETREPLYONCOMMUNITYREVIEW_URL +
          //"3"
          widget.id.toString() +
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
          modelAgentSearch.image = jsonArray[i]["image"].toString();
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
                childModelOne.image = childDataOne[j]["image"].toString();
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
                      childrenModelTwo.image = childDataTwo[k]["image"].toString();
                      childrenUserDataTwo = childDataTwo[k]['user'];
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
                            childrenModelThree.image = childDataThree[l]["image"].toString();
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
                                      Text(
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
                      Visibility(
                          visible: getReplyOnHotspotList[i]
                              .childrenList[index]
                              .video_image_status
                              .toString() ==
                              "2"
                              ? true
                              : false,
                          child: SizedBox(
                            height: 200,
                            child: VideoWidget(
                              url: getReplyOnHotspotList[i]
                                  .childrenList[index]
                                  .image,
                              play: true,
                            ),
                          )),
                      Visibility(
                        visible: getReplyOnHotspotList[i]
                            .childrenList[index]
                            .video_image_status
                            .toString() ==
                            "1"
                            ? true
                            : false,
                        child: Container(
                          // height: 48.h,
                          child: Image.network(
                            //  "assets/images/lighting.jpeg",
                            getReplyOnHotspotList[i]
                                .childrenList[index]
                                .image
                                .toString(),
                            fit: BoxFit.fill,
                          ),
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
                                                  Text(
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
                                  Visibility(
                                      visible: getReplyOnHotspotList[i]
                                          .childrenList[index]
                                          .childrenList[k]
                                          .video_image_status
                                          .toString() ==
                                          "2"
                                          ? true
                                          : false,
                                      child: SizedBox(
                                          height: 200,
                                          width: 35.h,
                                          child: VideoWidget(
                                            url: getReplyOnHotspotList[i]
                                                .childrenList[index]
                                                .childrenList[k]
                                                .image,
                                            play: true,
                                          ))),
                                  Visibility(
                                    visible: getReplyOnHotspotList[i]
                                        .childrenList[index]
                                        .childrenList[k]
                                        .video_image_status
                                        .toString() ==
                                        "1"
                                        ? true
                                        : false,
                                    child: Container(
                                      // height: 48.h,
                                      child: Image.network(
                                        //  "assets/images/lighting.jpeg",
                                        getReplyOnHotspotList[i]
                                            .childrenList[index]
                                            .childrenList[k]
                                            .image
                                            .toString(),
                                        fit: BoxFit.fill,
                                      ),
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
                                                            Text(
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
                                          Visibility(
                                              visible:  getReplyOnHotspotList[i]
                                                  .childrenList[index]
                                                  .childrenList[k]
                                                  .childrenList[j]
                                                  .video_image_status
                                                  .toString() ==
                                                  "2"
                                                  ? true
                                                  : false,
                                              child: SizedBox(
                                                  height: 200,
                                                  width: 35.h,
                                                  child: VideoWidget(
                                                    url: getReplyOnHotspotList[i]
                                                        .childrenList[index]
                                                        .childrenList[k]
                                                        .childrenList[j]
                                                        .image,
                                                    play: true,
                                                  ))),
                                          Visibility(
                                            visible: getReplyOnHotspotList[i]
                                                .childrenList[index]
                                                .childrenList[k]
                                                .childrenList[j]
                                                .video_image_status
                                                .toString() ==
                                                "1"
                                                ? true
                                                : false,
                                            child: Container(
                                              // height: 48.h,
                                              child: Image.network(
                                                //  "assets/images/lighting.jpeg",
                                                getReplyOnHotspotList[i]
                                                    .childrenList[index]
                                                    .childrenList[k]
                                                    .childrenList[j]
                                                    .image
                                                    .toString(),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
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
                              image_video_status = "0";
                              file = null;
                              fileName = "";
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
                              getCheckInImage();

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
                                  viewVisible = true;
                                } else {
                                  fileName = "File:- " + fileName;
                                  viewVisible = true;
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
                                  setState(() {
                                    image_video_status = "2";
                                  });
                                  Future.delayed(Duration(seconds: 2), (){
                                    if (currentPath != "") {

                                      file = File(currentPath.toString());
                                      fileName = path.basename(file!.path);
                                      print("Filename " + fileName.toString());
                                      setState(() {

                                      });
                                    }else{
                                      file = null;
                                      fileName = "";
                                      image_video_status = "0";
                                      setState(() {

                                      });
                                    }
                                  });






                                });
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


  viewVideo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {

          return AlertDialog(
              scrollable: true,
              backgroundColor: Colors.black,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w)),
              title:SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 40.h,
                          child: VideoWidgettt(url: file,play: true,)),
                      SizedBox(
                        height: 3.h,
                      ),


                      DefaultButton(
                          width: 35.w,
                          height: 6.h,
                          text: "Ok",
                          press: () {
                          Navigator.of(context, rootNavigator: true).pop();

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
                              image_video_status = "2";
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
                                setState(() {
                                });
                                if (fileName == "" ||
                                    fileName == null) {
                                  fileName = "File:- ";
                                  viewVisible = true;
                                } else {
                                  fileName = "File:- " + fileName;
                                  viewVisible = true;
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


                                  if (currentPath != "") {

                                    file = File(currentPath.toString());
                                    fileName = path.basename(file!.path);
                                    print("Filename " + fileName.toString());
                                  }



                                });
                              }
                            }
                          })
                    ],
                  ))


          );
        });
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

  Future getImagePath() async {
    if(currentPath==""){
      getImagePath();
    }else{
      return currentPath;
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
  var image = "";
  var video_image_status = "";
  bool viewV = false;
  var timedelay = "Secconds";
  List<GETREPLYONHOTSPOT> childrenList = [];
  List<GETREPLYONHOTSPOT> childrenSubList = [];
}

class UserData {
  var id = "";
  var name = "";
  var image = "";
}
