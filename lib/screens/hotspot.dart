import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotSpotReply.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';

class Hotspot extends StatefulWidget {
  const Hotspot({Key? key}) : super(key: key);

  @override
  _HotspotState createState() => _HotspotState();
}

class _HotspotState extends State<Hotspot> {
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

  List<GetHotSpotClass> getHostSpotList = [];

  

  @override
  void initState() {
    getHotspotApi();
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/icons/message.svg")),
          )
        ],
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
                  onChanged: (val) {},
                  decoration: InputDecoration(
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
                      suffixIcon:
                          SearchPrefixIcon(svgIcon: "assets/icons/cross.svg"),
                      prefixIcon: Image.asset("assets/images/search.png")),
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
                   TextEditingController messageController = new TextEditingController();
                  return Column(
                    children: [
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          color: kBackgroundColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: getHostSpotList[index]
                                        .user_image
                                        .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 6.h, left: 2.w),
                                      child: CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: NetworkImage(
                                          getHostSpotList[index]
                                              .user_image
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 6.h, left: 2.w),
                                      child: CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: AssetImage(
                                            "assets/images/usericon.png"),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 6.h, left: 2.w),
                                      child: CircleAvatar(
                                        radius: 7.w,
                                        backgroundImage: AssetImage(
                                            "assets/images/usericon.png"),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsets.only(bottom: 6.h, left: 2.w),
                                  //   child: CircleAvatar(
                                  //     radius: 7.w,
                                  //     backgroundImage: AssetImage(
                                  //         "assets/images/usericon.png"),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 1.h,),
                                        Container(
                                          width: 74.w,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    // "Person Name @ Bar Name",

                                                    getHostSpotList[index]
                                                                .person_name
                                                                .toString() !=
                                                            "null"
                                                        ? getHostSpotList[index]
                                                            .person_name
                                                            .toString()
                                                        : "User Name",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        color: kCyanColor,
                                                        fontFamily: "Segoepr"),
                                                  ),
                                                  Text(
                                                   " @ ",

                                                   
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        color: kCyanColor,
                                                        fontFamily: "Segoepr"),
                                                  ),

                                                  Text(
                                                    // "Person Name @ Bar Name",

                                                    getHostSpotList[index]
                                                                .business_user_name
                                                                .toString() !=
                                                            "null"
                                                        ? getHostSpotList[index]
                                                            .business_user_name
                                                            .toString()
                                                        : "User Name",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        color: kCyanColor,
                                                        fontFamily: "Segoepr"),
                                                  ),
                                                ],
                                              ),
                                             
                                              Padding(
                                                padding: EdgeInsets.only(right: 3.w),
                                                child: Text(
                                                //  "2m ago",

                                                getHostSpotList[index].created_at.toString().substring(0,10),
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
                                           getHostSpotList[index].message.toString()!= "null" ? getHostSpotList[index].message.toString() : "",
                                            style: TextStyle(
                                                //overflow: TextOverflow.ellipsis,
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
                                                                id : getHostSpotList[index]
                                                            .id
                                                            .toString()
                                                              )));
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
                                                                    onChanged:
                                                                        (val) {
                                                                      print(
                                                                          val);

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
                                                              replyOnHotspotReviewApi(getHostSpotList[index].id.toString(), getHostSpotList[index].messageText.toString());
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

          //  buildInput()

          // Padding(
          //   padding: EdgeInsets.only(top: 75.h),
          //   child: buildMessageFormField(),
          // ),

          // buildMessageFormField()
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
          //  suffixIcon: Padding(
          //    padding: const EdgeInsets.only(right: 20),
          //    child: InkWell(
          //      onTap: () {},
          //      child: SvgPicture.asset(
          //                "assets/attachment.svg",
          //                width: 5,
          //                color: Colors.grey,

          //              ),
          //    ),
          //  ),
        ),
        // focusNode: focusNode,
      ),
    );
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

         ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Your reply added successfully")));

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
      // controller: emailController,

      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,

      //inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
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

class SearchPrefixIcon extends StatelessWidget {
  const SearchPrefixIcon({
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
        color: kPrimaryColor,
        width: 20,
      ),
    );
  }
}
