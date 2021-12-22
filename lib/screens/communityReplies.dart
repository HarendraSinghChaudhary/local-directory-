import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotspot.dart';
import 'package:wemarkthespot/services/api_client.dart';

class CommunityReplies extends StatefulWidget {
  String review_id;

  CommunityReplies({required this.review_id});

  @override
  _CommunityRepliesState createState() => _CommunityRepliesState();
}

class _CommunityRepliesState extends State<CommunityReplies> {
  var id = "";
  var created_at = "";
  var review_id = "";
  var message = "";

  List<GETREPLYONCOMMUNITY> getReplyOnCommunityList = [];
  bool isloading = false;
  ScrollController _controller = new ScrollController();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w)),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
                              child: CircleAvatar(
                                radius: 7.w,
                                backgroundImage: NetworkImage(
                                    getReplyOnCommunityList[index]
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          //"Person Name",
                                          getReplyOnCommunityList[index]
                                                      .userProfile!
                                                      .name
                                                      .toString() !=
                                                  "null"
                                              ? getReplyOnCommunityList[index]
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
                                          padding: EdgeInsets.only(right: 3.w),
                                          child: Text(
                                            //"2m ago",
                                            getReplyOnCommunityList[index]
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
                                      //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",

                                      getReplyOnCommunityList[index]
                                                  .message
                                                  .toString() !=
                                              "null"
                                          ? getReplyOnCommunityList[index]
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
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "View Replies",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w500,
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
                            )
                          ],
                        )),
                    SizedBox(
                      height: 2.h,
                    ),
                    //replyWidget(controller: _controller),

                    replyWidget(index),

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
      floatingActionButton: Container(
        width: double.infinity,
        height: 8.h,
        color: Colors.white,
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

                  // border: InputBorder.none,
                  //focusedBorder: InputBorder.none,
                  //  enabledBorder: InputBorder.none,
                  //  errorBorder: InputBorder.none,
                  //  disabledBorder: InputBorder.none,
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
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/icons/send1.svg",
                  width: 8.w,
                  color: kPrimaryColor,
                )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getReplyOnCommunityApi() async {
    print("Widget Id "+widget.review_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(
      Uri.parse(RestDatasource.GETREPLYONCOMMUNITYREVIEW_URL +
          // "3"
          widget.review_id.toString()
          +
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

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
          GETREPLYONCOMMUNITY modelAgentSearch = new GETREPLYONCOMMUNITY();

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

          if(jsonRes['data'][i]['children'] != null) {
            if(childDataOne.length > 0) {

               for (var i = 0; i < childDataOne.length; i++) {
            GETREPLYONCOMMUNITY childModelOne = GETREPLYONCOMMUNITY();

            childModelOne.id = childDataOne[i]["id"].toString();
            childModelOne.created_at = childDataOne[i]["created_at"].toString();
            childModelOne.review_id = childDataOne[i]["review_id"].toString();
            childModelOne.message = childDataOne[i]["message"].toString();

            childrenOne = childDataOne[i]['user'];
            UserData childrenDataOneModel = UserData();
            childrenDataOneModel.id = childrenOne['id'].toString();
            childrenDataOneModel.name = childrenOne['name'].toString();
            childrenDataOneModel.image = childrenOne['image'].toString();

            childModelOne.userProfile = childrenDataOneModel;
            print("namechild: "+childrenDataOneModel.name.toString());

            modelAgentSearch.childrenList.add(childModelOne);
















            childDataTwo = childDataOne[i]['children'];

            if (childDataOne[i]['children'] != null) {
              if (childDataTwo.length > 0) {

                for (var k = 0; k < childDataTwo.length; k++) {
                  GETREPLYONCOMMUNITY childrenModelTwo = GETREPLYONCOMMUNITY();
                  childrenModelTwo.id = childDataTwo[k]["id"].toString();
                  childrenModelTwo.created_at = childDataTwo[k]["created_at"].toString();
                  childrenModelTwo.review_id = childDataTwo[k]["review_id"].toString();
                  childrenModelTwo.message = childDataTwo[k]["message"].toString();


                  childrenUserDataTwo = childDataTwo[k]['user'];

                  UserData childrenDataTwoModel = UserData();
                  childrenDataTwoModel.id = childrenUserDataTwo['id'].toString();
                  childrenDataTwoModel.name = childrenUserDataTwo['name'].toString();
                  childrenDataTwoModel.image = childrenUserDataTwo['image'].toString();



                  childrenModelTwo.userProfile = childrenDataTwoModel;
                  print("id....."+childDataTwo[k]["id"].toString());

                  print("namechild  //: "+childrenDataTwoModel.id.toString());

            modelAgentSearch.childrenList[i].childrenList.add(childrenModelTwo);









              childDataThree = childDataTwo[i]['children'];

              if (childDataTwo[i]['children'] != null) {

                if (childDataThree.length > 0) {

                  for (var  j = 0; j < childDataThree.length; j++) {

                    GETREPLYONCOMMUNITY childrenModelThree = GETREPLYONCOMMUNITY();

                  childrenModelThree.id = childDataThree[j]["id"].toString();
                  childrenModelThree.created_at = childDataThree[j]["created_at"].toString();
                  childrenModelThree.review_id = childDataThree[j]["review_id"].toString();
                  childrenModelThree.message = childDataThree[j]["message"].toString();

                  childrenUserDataThree = childDataThree[j]['user'];


                  UserData childrenDataThreeModel = UserData();
                  childrenDataThreeModel.id = childrenUserDataThree['id'].toString();
                  childrenDataThreeModel.name = childrenUserDataThree['name'].toString();
                  childrenDataThreeModel.image = childrenUserDataThree['image'].toString();


                   childrenModelThree.userProfile = childrenDataThreeModel;
                  print("id Three....."+childDataThree[j]["id"].toString());

                  print("namechild  Three //: "+childrenDataThreeModel.id.toString());

                  modelAgentSearch.childrenList[i].childrenList[i].childrenList.add(childrenModelThree);

                  




                








                    
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

  ListView replyWidget(int i) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: getReplyOnCommunityList[i].childrenList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 2.w, top: 1.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h, left: 1.w),
                      child: CircleAvatar(
                        radius: 6.w,
                           backgroundImage: NetworkImage(
                                    getReplyOnCommunityList[i].childrenList[index].userProfile!.image.toString()
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

                                   getReplyOnCommunityList[i].childrenList[index].userProfile!.name.toString(),
                                    
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
                              getReplyOnCommunityList[i].childrenList[index].message.toString(),
                             
                              style: TextStyle(
                                  //overflow: TextOverflow.ellipsis,
                                  fontSize: 8.5.sp,
                                  color: Colors.black87,
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

                                 getReplyOnCommunityList[i].created_at.toString().substring(0,10),
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: InkWell(
                                    onTap: () {},
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
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 
                getReplyOnCommunityList[i].childrenList[index].childrenList.length,
                itemBuilder: (BuildContext context, int k) {
                  return Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 8.w,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h, left: 0.w),
                              child: CircleAvatar(
                                radius: 4.w,
                                backgroundImage: NetworkImage(
                                    getReplyOnCommunityList[i].childrenList[index].childrenList[index].userProfile!.image.toString()
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
                                        Text(
                                          //"Person Name @ Bar Name",
                                          getReplyOnCommunityList[i].childrenList[index].childrenList[index].userProfile!.name.toString(),
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
                                      getReplyOnCommunityList[i].childrenList[index].childrenList[index].message.toString(),
                                      style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                          fontSize: 8.5.sp,
                                          color: Colors.black87,
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
                                          //"2m ago",
                                          getReplyOnCommunityList[i].childrenList[index].childrenList[index].created_at.toString().substring(0,10),
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: InkWell(
                                            onTap: () {},
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
                            )
                          ],
                        ),
                      ));
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: getReplyOnCommunityList[i].childrenList[index].childrenList[index].childrenList.length,
                itemBuilder: (BuildContext context, int j) {
                  return Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16.w,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 6.h, left: 0.w),
                                child: CircleAvatar(
                                  radius: 4.w,
                                  backgroundImage:
                                     // AssetImage("assets/images/loc.png"),
                                     NetworkImage(
                                  getReplyOnCommunityList[i].childrenList[index].childrenList[index].childrenList[index].userProfile!.image.toString(),),
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
                                             getReplyOnCommunityList[i].childrenList[index].childrenList[index].childrenList[index].userProfile!.name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kCyanColor,
                                                fontFamily: "Segoepr"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.1.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 0.w),
                                      child: Container(
                                        width: 70.w,
                                        child: Text(
                                         // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                                         getReplyOnCommunityList[i].childrenList[index].childrenList[index].childrenList[index].message.toString(),
                                          style: TextStyle(
                                              //overflow: TextOverflow.ellipsis,
                                              fontSize: 8.5.sp,
                                              color: Colors.black87,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            //"2m ago",
                                             getReplyOnCommunityList[i].childrenList[index].childrenList[index].childrenList[index].created_at.toString().substring(0,10),
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: InkWell(
                                              onTap: () {},
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
                            )
                          ],
                        ),
                      ));
                },
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        );
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

  List<GETREPLYONCOMMUNITY> childrenList = [];
  List<GETREPLYONCOMMUNITY> childrenSubList = [];
}

class UserData {
  var id = "";
  var name = "";
  var image = "";
}
