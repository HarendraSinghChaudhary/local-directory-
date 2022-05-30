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
import 'package:wemarkthespot/services/modelProvider.dart';

class Splash extends StatefulWidget {
   static const String routeName = '/';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  Splash(
      this.notificationAppLaunchDetails, {
        Key? key,
      }) : super(key: key);
  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String id = "";
   late SharedPreferences pref;
   var name, email, ids, country_code, phone, dob, image;

  @override
  void initState() {
    getLoginStatus();

    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    getUserList();
    //getDiff();
    FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);


    //fetchLocation();
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print('Running Get Initial Message');
      if(message!=null) { //_showNotification(message);
        Map<String, dynamic> map = message.data;
        print(map.toString());
        createListMap(map);
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
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
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: map.toString(),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Running Get Initial Message'); //_showNotification(message);
      Map<String, dynamic> map = message.data;
      print(map.toString());
      createListMap(map);
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
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
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: map.toString(),
      );
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Running Get Initial Message'); //_showNotification(message);
      Map<String, dynamic> map = message.data;
      print(map.toString());
      createListMap(map);
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
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
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: map.toString(),
      );
    });



    
    super.initState();
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



  Future<void> _requestPermissions() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification
    ].request();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print("listion ios state");
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                print("Clicked true ios");
                /* Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        Notifications(),
                  ),
                );*/
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() async{

    selectNotificationSubject.stream.listen((String? payload) async {
      print("Payload "+payload.toString()+"");


      if(payload!=null){
        if(payload != ""){


            await Navigator.pushNamed(context, '/notification');



        }
      }else{
        await Navigator.pushNamed(context, '/notification');
      }

    });
  }
  Future<void> createListMap(Map<String, dynamic> map) async {
    print("ListSaveMap");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? titleList = preferences.getStringList('titleList');
    List<String>? bodyList = preferences.getStringList('bodyList');
    List<String>? isReadList = preferences.getStringList('isRead');
    List<String>? idList = preferences.getStringList('idList');
    List<String>? typeList = preferences.getStringList('typeList');
    List<String>? reviewIdList = preferences.getStringList('reviewIdList');


    // List<String> timeList = preferences.getStringList('timeList');
    if(titleList!=null && bodyList!=null && isReadList!=null && idList!=null && typeList!=null && reviewIdList!=null
    ){
      titleList.add(map["title"].toString());
      bodyList.add(map["body"].toString());
      typeList.add(map["type"].toString());
      reviewIdList.add(map["businessreview_id"].toString());

      isReadList.add("false");
      preferences.setStringList("titleList", titleList);
      preferences.setStringList("bodyList", bodyList);
      preferences.setStringList("isRead", isReadList);
      preferences.setStringList("idList", idList);
      preferences.setStringList("typeList", typeList);
      preferences.setStringList("reviewIdList", reviewIdList);
     //  preferences.setStringList("timeList", timeList);
      preferences.commit();
    }else{
      List<String> titleListNew = [];
      List<String> bodyListNew = [];
      List<String> isReadListNew = [];
      List<String> idList = [];
      List<String> typeList = [];
      List<String> reviewIdList = [];


      titleListNew.add(map["title"].toString());
      bodyListNew.add(map["body"].toString());
      typeList.add(map["type"].toString());
      reviewIdList.add(map["businessreview_id"].toString());

      if(map.containsKey("id")) {
        idList.add(map["id"].toString());
      }else{
        idList.add("");

      }

      if(map.containsKey("type")) {
        typeList.add(map["type"].toString());
      }else{
        typeList.add("");

      }

      if(map.containsKey("businessreview_id")) {
        reviewIdList.add(map["businessreview_id"].toString());
      }else{
        reviewIdList.add("");

      }

      isReadListNew.add("false");

      preferences.setStringList("titleList", titleListNew);
      preferences.setStringList("bodyList", bodyListNew);
      preferences.setStringList("isRead", isReadListNew);
      preferences.setStringList("idList", idList);
      preferences.setStringList("typeList", typeList);
      preferences.setStringList("reviewIdList", reviewIdList);
    preferences.commit();
    }


    getNotify();
  }


  void getNotify() async{
    notificationCount = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isRead = preferences.getStringList("isRead");
    print("IsRead " + isRead.toString());
    if (isRead != null) {
      if (isRead.isNotEmpty) {
        for (var k = 0; k < isRead.length; k++) {
          print("element " + isRead[k].toString());
          if (isRead[k] == "false") {
            notificationCount++;
          }
        }
      }
    }
    context.read<Counter>().getNotify();
    print("countsplash " + notificationCount.toString());
    preferences.setString("notify",notificationCount.toString());
    preferences.commit();

    //   navigatorKey.currentState!.pushReplacementNamed('/home');
  }


  Future<dynamic> getUserList() async {
    pref = await SharedPreferences.getInstance();
    ids = pref.getString("id").toString();
    print("id1: " + id.toString());
    email = pref.getString("email").toString();
    print("email: " + email.toString());
    name = pref.getString("name").toString();
    print("name: " + name.toString());
    country_code = pref.getString("country_code").toString();
    print("country_code: " + country_code.toString());
    phone = pref.getString("phone").toString();
    print("phone: " + phone.toString());
    dob = pref.getString("dob").toString();
    print("dob: " + dob.toString());
    image = pref.getString("image").toString();
    print("image: " + image.toString());

    setState(() {});
  }





}
