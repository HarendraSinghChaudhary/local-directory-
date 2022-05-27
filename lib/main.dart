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

final BehaviorSubject<String?> selectNotificationSubject =
BehaviorSubject<String?>();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = WeMarkTheSpot.routeName;
  String? asas  = notificationAppLaunchDetails?.didNotificationLaunchApp.toString();
  print("assa "+asas.toString());
  print("Payload "+notificationAppLaunchDetails!.payload.toString()+"^^");
  if(notificationAppLaunchDetails.payload.toString()!="null") {
    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      selectedNotificationPayload = notificationAppLaunchDetails.payload;
      initialRoute = "/notification";
    }
  }else{
    initialRoute = WeMarkTheSpot.routeName;
  }

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
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);

      });



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

  FirebaseMessaging.onBackgroundMessage(backgroundMessagehandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) =>

      runApp(MultiProvider(providers: [
            ChangeNotifierProvider(create: (_) => Counter()),
          ],


          child:  Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                initialRoute: initialRoute,
                debugShowCheckedModeBanner: false,
                theme: theme(),
                routes: <String, WidgetBuilder>{
                  WeMarkTheSpot.routeName: (_) =>
                      WeMarkTheSpot(notificationAppLaunchDetails),
                  "/notification": (_) => Notifications()
                },
              );

            }
          )



      )


      )


  );



}

Future<void> backgroundMessagehandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Logged beckground");
}

class WeMarkTheSpot extends StatefulWidget {
  static const String routeName = '/';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  WeMarkTheSpot(
      this.notificationAppLaunchDetails, {
        Key? key,
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(

            debugShowCheckedModeBanner: false,
            title: 'We Mark The Spot',
            theme: theme(),
            home: Splash(),
            routes: {
              '/notification': (context)=> Notifications(),

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
