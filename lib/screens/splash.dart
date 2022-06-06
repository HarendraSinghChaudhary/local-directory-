import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemarkthespot/main.dart';
import 'package:wemarkthespot/models/receivedNotification.dart';
import 'package:wemarkthespot/screens/homenave.dart';

import 'package:wemarkthespot/screens/introduction_Screen.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/login_screen.dart';
import 'package:wemarkthespot/screens/notifications.dart';
import 'package:wemarkthespot/services/modelProvider.dart';

import '../models/body.dart';

class Splash extends StatefulWidget {
   static const String routeName = '/splash';



  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String id = "";
   late SharedPreferences pref;
   var name, email, ids, country_code, phone, dob, image;

  @override
  void initState() {
    super.initState();
    getLoginStatus();
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print('Running Get Initial Message');

      if(message!=null) {
        print('Running Get Initial Message is '+message.data.toString()+"^^");
        if (message.data != null) {

          var listdata = await breakPayload(message.data.toString());
          var type = "";
          var review_id = "";
          var reply_id = "";
          listdata.forEach((element) {

            if(element.contains("type")){
              int i = element.indexOf(":")+2;
              print("Type "+element.substring(i)+"^^");
              type = element.substring(i).toString();
            }

            if(element.contains("businessreview_id")){
              int i = element.indexOf(":")+2;
              print("businessreview_id "+element.substring(i)+"^^");
              review_id = element.substring(i).toString();
            }

            if(element.contains("reply_id")){
              int i = element.indexOf(":")+2;
              print("reply_id "+element.substring(i)+"^^");
              reply_id = element.substring(i).toString();
            }
          });

          switch(type.toLowerCase()){
            case "review":
              NotificationModel model = NotificationModel();
              model.review_id = review_id;
              model.type = type;
              model.reply_id = reply_id;
              Navigator.pushNamed(context,"/communityReplyId", arguments: model);
              flutterLocalNotificationsPlugin.cancelAll();
              break;
            case "hotspot":
              NotificationModel model = NotificationModel();
              model.review_id = review_id;
              model.type = type;
              model.reply_id = reply_id;
              Navigator.pushNamed(context,"/hotspotreply", arguments: model);
              flutterLocalNotificationsPlugin.cancelAll();
              break;
            case "addhotspot":
              await flutterLocalNotificationsPlugin.cancelAll();
              Navigator.pushNamedAndRemoveUntil(context,"/addhotspot", (r)=>false);

              break;
            case "giveaway":

              flutterLocalNotificationsPlugin.cancelAll();

              break;
            case "sendmail":

              flutterLocalNotificationsPlugin.cancelAll();

              break;
            case "business":
              NotificationModel model = NotificationModel();
              model.review_id = review_id.toString();
              model.reply_id = "";
              model.type = "business";

              Navigator.pushNamed(context, "/detailedbusiness", arguments: model);
              flutterLocalNotificationsPlugin.cancelAll();
              break;

            case "businesslist":
              Navigator.pushReplacementNamed(context,"/explore");
              flutterLocalNotificationsPlugin.cancelAll();

              break;

            default:Navigator.pushNamed(context,"/notification");
          }
          Map<String, dynamic> map = message.data;
          print(map.toString());
          createListMap(map);
          /*     const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'user_channel',
            'user_channel',
            channelDescription: 'User channel',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            enableLights: true,
            enableVibration: true,
            playSound: true,
          );
          const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
            10,
            message.data["title"].toString(),
            message.data["body"].toString(),
            platformChannelSpecifics,
            payload: map.toString(),
          );*/
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.fill
                )
              ) ,
            ),
            Center(child: SvgPicture.asset("assets/icons/logo-2.svg")),
            Positioned(
                bottom: 5.h,
                left: 30.w,
                child: Image.asset("assets/images/where.png"))
          ],
        ),
      ),
    );
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id").toString();
    var firstTime = true;
    firstTime = prefs.getBool("isFirstTimeLaunch")?? true;
    print("id :" + id.toString() + "^");

    Future.delayed(Duration(seconds: 3), () {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => IntdroductionScreen()));

      id.toString() == "" || id.toString() == "null" || id == ''
          ? firstTime!=null?firstTime?
      Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => IntdroductionScreen())):
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen())):
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()))
          : id.toString() == '72' ? Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()))
          :
           Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeNav(index: 0,)));
    });
  }






}
