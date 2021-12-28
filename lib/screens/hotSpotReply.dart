import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;

class HotSpotReply extends StatefulWidget {
  var id;

  HotSpotReply({required this.id});

  @override
  _HotSpotReplyState createState() => _HotSpotReplyState();
}

class _HotSpotReplyState extends State<HotSpotReply> {
  TextEditingController messageController = new TextEditingController();

  bool viewVisible = false;

  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";

  List<GETREPLYONHOTSPOT> getReplyOnHotspotList = [];
  bool isloading = false;
  ScrollController _controller = new ScrollController();

  var tabOne = "";

  @override
  void initState() {
    getReplyOnHotspotApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.8.h, left: 2.w),
                              child: CachedNetworkImage(
                                imageUrl: getReplyOnHotspotList[index]
                                    .userProfile!
                                    .image
                                    .toString(),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage: NetworkImage(
                                      getReplyOnHotspotList[index]
                                          .userProfile!
                                          .image
                                          .toString()),
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
                              width: 2.w,
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
                                          getReplyOnHotspotList[index]
                                                      .userProfile!
                                                      .name
                                                      .toString() !=
                                                  "null"
                                              ? getReplyOnHotspotList[index]
                                                  .userProfile!
                                                  .name
                                                  .toString()
                                              : "User Name",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: kCyanColor,
                                              fontFamily: "Segoepr"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: Text(
                                            //"2m ago",
                                            getReplyOnHotspotList[index]
                                                .created_at
                                                .toString()
                                                .substring(0, 10),
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

                                      getReplyOnHotspotList[index]
                                                  .message
                                                  .toString() !=
                                              "null"
                                          ? getReplyOnHotspotList[index]
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
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [


                                          getReplyOnHotspotList[index]
                                
                                    .viewV
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    getReplyOnHotspotList[index]
                                
                                    .viewV = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Hide Replies",
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Roboto"),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                   getReplyOnHotspotList[index]
                                
                                    .viewV = true;
                                                  });
                                                },
                                                child: Text(
                                                  "View Replies",
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Roboto"),
                                                ),
                                              ),





                                     
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                viewVisible = true;
                                                tabOne =
                                                    getReplyOnHotspotList[index]
                                                        .id
                                                        .toString();
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
                                    height: 3.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 0.2.h,
                    ),
                    //replyWidget(controller: _controller),

                    replyCard(index),

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: viewVisible,
        child: Container(
          width: double.infinity,
          height: 8.h,
          color: Colors.black,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
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
                    print("tab1");
                    replyOnHotspotReplyApi(
                        tabOne.toString(), messageController.text.toString());

                    setState(() {
                      messageController.text = "";
                      viewVisible = false;
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/icons/send1.svg",
                    width: 8.w,
                    color: kPrimaryColor,
                  )),
            ],
          ),
        ),
      ),
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
    print("review_id: " + widget.id.toString());
    print("reply_id: " + reply_id.toString());
    print("type: " + "HOTSPOT");
    print("message: " + messageText.toString());

    var request = http.post(
        Uri.parse(
          RestDatasource.COMMUNITYREPLYONREVIEW_URL,
        ),
        body: {
          "user_id": id.toString(),
          "review_id": widget.id.toString(),
          "reply_id": reply_id,
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
          viewVisible = false;
          isloading = false;
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

  Future<dynamic> getReplyOnHotspotApi() async {
    print("getreplyonhotspotapi " + "Running");
    print("widgetid " + widget.id.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
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

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          GETREPLYONHOTSPOT modelAgentSearch = new GETREPLYONHOTSPOT();

          // NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
          modelAgentSearch.review_id = jsonArray[i]["review_id"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();

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

          getReplyOnHotspotList.add(modelAgentSearch);

          setState(() {});
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

  ListView replyCard(int i) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: getReplyOnHotspotList[i].childrenList.length,
      itemBuilder: (BuildContext context, int index) {
        return Visibility(
          visible: getReplyOnHotspotList[i]
                                    .viewV ,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            color: kBackgroundColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 2.w, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h, left: 1.w),
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
                            Container(
                              width: 74.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // "2m ago",
        
                                    getReplyOnHotspotList[i]
                                        .childrenList[index]
                                        .created_at
                                        .toString()
                                        .substring(0, 10),
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
                        color: kBackgroundColor,
                        margin: EdgeInsets.symmetric(horizontal: 0.w),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 8.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 6.h, left: 0.w),
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
                                                    .created_at
                                                    .toString()
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 6.w),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      viewVisible = true;
                                                      tabOne =
                                                          getReplyOnHotspotList[i]
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
                                                        color: Colors.white,
                                                        fontFamily: "Roboto"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
                                    color: kBackgroundColor,
                                    margin: EdgeInsets.symmetric(horizontal: 0.w),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                      ),
                                      child: Row(
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
                                                              .childrenList[index]
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
                                                            fontFamily: 'Roboto'),
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
                                                              .childrenList[index]
                                                              .childrenList[k]
                                                              .childrenList[j]
                                                              .created_at
                                                              .toString()
                                                              .substring(0, 10),
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: kPrimaryColor,
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
                                                ],
                                              ),
                                            ),
                                          )
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
}

class GETREPLYONHOTSPOT {
  UserData? userProfile;
  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";
  bool viewV = false;

  List<GETREPLYONHOTSPOT> childrenList = [];
  List<GETREPLYONHOTSPOT> childrenSubList = [];
}

class UserData {
  var id = "";
  var name = "";
  var image = "";
}
