import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/communityRepliesById.dart';
import 'package:wemarkthespot/screens/detailBusinessdynamic.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/hotSpotReply.dart';
import 'package:wemarkthespot/services/modelProvider.dart';

import '../main.dart';
import '../models/body.dart';
import 'communityReplies.dart';
import 'hotSpotReplyById.dart';


class Notifications extends StatefulWidget {
  const Notifications({ Key? key }) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> titleList = [];
  List<String> bodyList = [];
  List<String> isread = [];
  List<String> reviewList = [];
  List<String> typeList = [];
  List<String> replyIdList = [];

  ScrollController _controller = new ScrollController();


  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Notifications",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),



      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3.h,),
             ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: titleList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = titleList[index];
                  return Dismissible(
                    key:UniqueKey(),
                    onDismissed: (direction) async {
                      titleList.removeAt(index);
                      bodyList.removeAt(index);
                      isread.removeAt(index);
                      typeList.removeAt(index);
                      reviewList.removeAt(index);
                      replyIdList.removeAt(index);
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.setStringList("titleList", titleList);
                      pref.setStringList("bodyList", bodyList);
                      pref.setStringList("isRead", isread);
                      pref.setStringList("typeList", typeList);
                      pref.setStringList("reviewIdList", reviewList);
                      pref.setStringList("replyIdList", reviewList);
                      setState(() {

                      });
                    },
                    child: GestureDetector(
                      onTap: (){
                        switch(typeList[index].toString().toLowerCase()){
                          case "review":
                            NotificationModel model = NotificationModel();
                            model.review_id = reviewList[index].toString();
                            model.type = typeList[index].toString();
                            model.reply_id = replyIdList[index].toString();
                            navigatorKey.currentState!.pushNamed("/communityReplyId", arguments: model);
                            break;
                          case "hotspot":
                            NotificationModel model = NotificationModel();
                            model.review_id = reviewList[index].toString();
                            model.type = typeList[index].toString();
                            model.reply_id = replyIdList[index].toString();
                            navigatorKey.currentState!.pushNamed("/hotspotreply", arguments: model);
                            break;
                          case "addhotspot":
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) =>
                                    HomeNav(index: 2,)));
                            break;
                          case "giveaway":
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) =>
                                    HomeNav(index: 0,)));
                            break;
                          case "sendmail":
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) =>
                                    HomeNav(index: 0,)));
                            break;
                          case "business":
                            NotificationModel model = NotificationModel();
                            model.review_id = reviewList[index].toString();
                            model.type = typeList[index].toString();
                            model.reply_id = replyIdList[index].toString();

                            Navigator.pushNamed(context, "/detailedbusiness", arguments: model);

                            break;

                          case "businesslist":
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) =>
                                    Explore()));
                            break;
                        }

                      },
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                  color: kBackgroundColor),
                              child: Column(
                                children: [
                                  Container(


                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                 // "One New Message",
                                                  titleList[index].toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kCyanColor,
                                                      fontFamily: "Segoepr"),
                                                ),
                                                Text(
                                                 //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                                  bodyList[index].toString(),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 10,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    //overflow: TextOverflow.ellipsis,
                                                      fontSize: 10.2.sp,
                                                      color: Color(0xFFCECECE),
                                                      fontFamily: 'Roboto'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: Column(
                                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //     children: [
                                          //       Padding(
                                          //         padding: EdgeInsets.only(right:2.w),
                                          //         child: Text(
                                          //           "2 hrs ago",
                                          //           style: TextStyle(
                                          //             fontSize: 8.sp,
                                          //             color: kPrimaryColor,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       SizedBox(height: 30,)
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.7.h,
                                  ),

                                  // SizedBox(
                                  //   height: 1.h,
                                  // ),

                                ],
                              )),
                          SizedBox(
                            height: 2.h,
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      
    );
  }

  Future<void> getData() async {

    List<String> isRead = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("titleList")) {
      titleList = preferences.getStringList("titleList")!;
      bodyList = preferences.getStringList("bodyList")!;
      isread = preferences.getStringList("isRead")!;
      typeList = preferences.getStringList("typeList")!;
      reviewList = preferences.getStringList("reviewIdList")!;
      replyIdList = preferences.getStringList("replyIdList")!;
      isread.forEach((element) {
        isRead.add("true");
      });
    }
    print("title list length "+titleList.length.toString()+"^^");
    preferences.setStringList("isRead", isRead);
    preferences.commit();
    notificationCount = 0;
    context.read<Counter>().getNotify();

    setState(() {
      titleList = titleList.reversed.toList();
      bodyList = bodyList.reversed.toList();
      typeList = typeList.reversed.toList();
      reviewList = reviewList.reversed.toList();
      replyIdList = replyIdList.reversed.toList();
    });
  }

}