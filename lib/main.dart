import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wemarkthespot/models/body.dart';
import 'package:wemarkthespot/screens/communityRepliesById.dart';
import 'package:wemarkthespot/screens/detailBusinessdynamic.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/hotSpotReplyById.dart';
import 'package:wemarkthespot/screens/notifications.dart';
import 'package:wemarkthespot/screens/splash.dart';
import 'package:wemarkthespot/services/modelProvider.dart';
import 'package:wemarkthespot/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'models/receivedNotification.dart';

String? selectedNotificationPayload;

String currentPath = "";
bool isPlaying1 = false;
bool isPlaying2 = false;
var fcm_token = "";
var lat = "";
var long = "";
int notificationCount = 0;
var notification_status = "1";
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "user_channel",
  "user_channel",
  description: "This is description ",
  importance: Importance.max,
  playSound: true,
  enableLights: true,
  enableVibration: true,

);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
= FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

final BehaviorSubject<String?> selectNotificationSubject =
BehaviorSubject<String?>();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
          ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      });
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
         // navigatorKey.currentState!.pushNamed("/notification");

        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);

      });


  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = Splash.routeName;
  String? asas  = notificationAppLaunchDetails?.didNotificationLaunchApp.toString();
  print("assa "+asas.toString());
  print("Payload "+notificationAppLaunchDetails!.payload.toString()+"^^");


  if(notificationAppLaunchDetails.payload.toString()!="null") {
    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      selectedNotificationPayload = notificationAppLaunchDetails.payload;
   /*   String a = notificationAppLaunchDetails.payload.toString().replaceAll("{", "");
      String b = a.replaceAll("}", "");

      List<String> listdata = b.split(",");
      print(listdata.length);
      print(listdata.toString());
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
          initialRoute = "/communityreply";
          break;
        case "hotspot":
          initialRoute = "/splash";

          break;
        case "addhotspot":
          initialRoute = "/addhotspot";
          break;
        case "giveaway":
          initialRoute = "/home";

          break;
        case "sendmail":
          initialRoute = "/home";

          break;
        case "business":
          initialRoute = "/detailedbusiness";
          break;

        case "businesslist":
          initialRoute = "/explore";

          break;

        default:   initialRoute = "/notification";
      }*/
      initialRoute = "/notification";

    }
  }else{
    initialRoute = Splash.routeName;
  }
  print(initialRoute);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false
  );

 // FirebaseMessaging.onBackgroundMessage(backgroundMessagehandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) =>

      runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Counter()),
          ],
          child: WeMarkTheSpot(notificationAppLaunchDetails:notificationAppLaunchDetails, route: initialRoute,),

      ),));



}


/*
Future<void> backgroundMessagehandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("background");

  if(message!=null) { //_showNotification(message);
  if(message.notification!=null){

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
      12,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      platformChannelSpecifics,
      payload: map.toString(),
    );
  }
  }

}
*/

Future<void> createListMap(Map<String, dynamic> map) async {

  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String>? titleList = preferences.getStringList('titleList');
  List<String>? bodyList = preferences.getStringList('bodyList');
  List<String>? isReadList = preferences.getStringList('isRead');
  List<String>? typeList = preferences.getStringList('typeList');
  List<String>? reviewIdList = preferences.getStringList('reviewIdList');
  List<String>? replyIdList = preferences.getStringList('replyIdList');


  // List<String> timeList = preferences.getStringList('timeList');
  if(titleList!=null && bodyList!=null && isReadList!=null && typeList!=null && reviewIdList!=null && replyIdList!=null
  ){
    titleList.add(map["title"].toString());
    bodyList.add(map["body"].toString());
    typeList.add(map["type"].toString());
    reviewIdList.add(map["businessreview_id"].toString());
    replyIdList.add(map["replyIdList"].toString());

    isReadList.add("false");
    preferences.setStringList("titleList", titleList);
    preferences.setStringList("bodyList", bodyList);
    preferences.setStringList("isRead", isReadList);
    preferences.setStringList("typeList", typeList);
    preferences.setStringList("reviewIdList", reviewIdList);
    preferences.setStringList("replyIdList", replyIdList);
    //  preferences.setStringList("timeList", timeList);
    preferences.commit();
  }else{
    List<String> titleListNew = [];
    List<String> bodyListNew = [];
    List<String> isReadListNew = [];
    List<String> typeList = [];
    List<String> reviewIdList = [];
    List<String> replyIdList = [];


    titleListNew.add(map["title"].toString());
    bodyListNew.add(map["body"].toString());
    typeList.add(map["type"].toString());
    reviewIdList.add(map["businessreview_id"].toString());
    replyIdList.add(map["replyIdList"].toString());



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

    if(map.containsKey("reply_id")) {
      replyIdList.add(map["reply_id"].toString());
    }else{
      replyIdList.add("");

    }

    isReadListNew.add("false");

    preferences.setStringList("titleList", titleListNew);
    preferences.setStringList("bodyList", bodyListNew);
    preferences.setStringList("isRead", isReadListNew);
    preferences.setStringList("typeList", typeList);
    preferences.setStringList("reviewIdList", reviewIdList);
    preferences.setStringList("replyIdList", replyIdList);
    preferences.commit();
  }

}


Future<List<String>> breakPayload(String? _payload) async {

  String a = _payload!.replaceAll("{", "");
  String b = a.replaceAll("}", "");
  print("B is"+b.toString());
  List<String> listdata = b.split(",");
  print(listdata.length);
  print(listdata.toString());

return listdata;
}

class WeMarkTheSpot extends StatefulWidget {


  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final String? route;
  WeMarkTheSpot({
        Key? key,
    this.notificationAppLaunchDetails, this.route
  }) : super(key: key);
  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  State<WeMarkTheSpot> createState() => _WeMarkTheSpotState();
}

class _WeMarkTheSpotState extends State<WeMarkTheSpot> {
  late SharedPreferences pref;
  var name, email, id, country_code, phone, dob, image;

  @override
  void initState() {
    super.initState();



    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    getUserList();
    //getDiff();
    FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);


    //fetchLocation();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Running onMessage'); //_showNotification(message);
      if(message!=null){
        if(message.data!=null){
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
            message.data["title"].toString(),
            message.data["body"].toString(),
            platformChannelSpecifics,
            payload: map.toString(),
          );
        }
      }


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
        message.data["title"].toString(),
        message.data["body"].toString(),
        platformChannelSpecifics,
        payload: map.toString(),
      );
    });
  }

  @override
  void dispose() {
    if (id.toString() == '72') {
      pref.remove('id');
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);

    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Now Route "+widget.route.toString()+"^^");
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
           // initialRoute: widget.route,
            debugShowCheckedModeBanner: false,
            title: 'We Mark The Spot',
            theme: theme(),
            navigatorKey: navigatorKey,
            home: Splash(),
            routes: <String, WidgetBuilder>{
            Splash.routeName: (_) => Splash(),
            "/notification": (_) => Notifications(),
            "/home": (_) => HomeNav(index: 0),
            "/hotspotreply": (_) => HotSpotReplyById(),
            "/communityReplyId": (_) => CommunityRepliesById(),
            "/addhotspot": (_) => HomeNav(index: 2),
            "/explore": (_) => HomeNav(index: 3),
            "/detailedbusiness": (_) => DetailBussinessDynamic(),
             "/latestbusiness": (_) => DetailBussinessDynamic(),
          },
        );
      },
    );
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
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        Notifications(),
                  ),
                );
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



      if(payload!=null){
        if(payload != ""){
          var listdata = await breakPayload(payload);
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
              navigatorKey.currentState!.pushNamed("/communityReplyId", arguments: model);

              break;
            case "hotspot":
              NotificationModel model = NotificationModel();
              model.review_id = review_id;
              model.type = type;
              model.reply_id = reply_id;
              navigatorKey.currentState!.pushNamed("/hotspotreply", arguments: model);
              break;
            case "addhotspot":
              navigatorKey.currentState!.pushNamed("/addhotspot");
              break;
            case "giveaway":
              navigatorKey.currentState!.pushNamed("/home");

              break;
            case "sendmail":
              navigatorKey.currentState!.pushNamed("/home");

              break;
            case "business":
              navigatorKey.currentState!.pushNamed("/detailedbusiness", arguments: {
                "type":type,
                "review_id":review_id,
                "reply_id":reply_id
              });
              break;
               case "latest":
              navigatorKey.currentState!.pushNamed("/latestbusiness");
              break;

            case "businesslist":
              navigatorKey.currentState!.pushNamed("/explore");

              break;

            default:navigatorKey.currentState!.pushNamed("/notification");
          }




        }else{
          navigatorKey.currentState!.pushNamed("/notification");
        }
      }else{
        navigatorKey.currentState!.pushNamed("/notification");
      }

    });
  }
  Future<void> createListMap(Map<String, dynamic> map) async {
    print("ListSaveMap");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? titleList = preferences.getStringList('titleList');
    List<String>? bodyList = preferences.getStringList('bodyList');
    List<String>? isReadList = preferences.getStringList('isRead');
    List<String>? typeList = preferences.getStringList('typeList');
    List<String>? reviewIdList = preferences.getStringList('reviewIdList');
    List<String>? replyIdList = preferences.getStringList('replyIdList');


    // List<String> timeList = preferences.getStringList('timeList');
    if(titleList!=null && bodyList!=null && isReadList!=null && typeList!=null && reviewIdList!=null && replyIdList!=null
    ){
      titleList.add(map["title"].toString());
      bodyList.add(map["body"].toString());
      typeList.add(map["type"].toString());
      reviewIdList.add(map["businessreview_id"].toString());
      replyIdList.add(map["replyIdList"].toString());

      isReadList.add("false");
      preferences.setStringList("titleList", titleList);
      preferences.setStringList("bodyList", bodyList);
      preferences.setStringList("isRead", isReadList);
      preferences.setStringList("typeList", typeList);
      preferences.setStringList("reviewIdList", reviewIdList);
      preferences.setStringList("replyIdList", replyIdList);
      //  preferences.setStringList("timeList", timeList);
      preferences.commit();
    }else{
      List<String> titleListNew = [];
      List<String> bodyListNew = [];
      List<String> isReadListNew = [];
      List<String> typeList = [];
      List<String> reviewIdList = [];
      List<String> replyIdList = [];


      titleListNew.add(map["title"].toString());
      bodyListNew.add(map["body"].toString());
      typeList.add(map["type"].toString());
      reviewIdList.add(map["businessreview_id"].toString());
      replyIdList.add(map["reply_id"].toString());



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

      if(map.containsKey("reply_id")) {
        replyIdList.add(map["reply_id"].toString());
      }else{
        replyIdList.add("");

      }

      isReadListNew.add("false");

      preferences.setStringList("titleList", titleListNew);
      preferences.setStringList("bodyList", bodyListNew);
      preferences.setStringList("isRead", isReadListNew);
      preferences.setStringList("typeList", typeList);
      preferences.setStringList("reviewIdList", reviewIdList);
      preferences.setStringList("replyIdList", replyIdList);
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
    id = pref.getString("id").toString();
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

  void getDiff() {
    final birthday = DateTime(2021, 12, 29);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inHours;
    print("time1 " + birthday.toString());
    print("time2 " + date2.toString());
    print("time3 " + difference.toString());
  }
}
