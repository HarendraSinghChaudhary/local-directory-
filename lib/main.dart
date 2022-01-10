import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';



import 'package:wemarkthespot/screens/splash.dart';
import 'package:wemarkthespot/services/modelProvider.dart';



import 'package:wemarkthespot/theme.dart';
String currentPath = "";
void main() {

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child:WeMarkTheSpot()));
}

class WeMarkTheSpot extends StatefulWidget {
  @override
  State<WeMarkTheSpot> createState() => _WeMarkTheSpotState();
}

class _WeMarkTheSpotState extends State<WeMarkTheSpot> {
  late SharedPreferences pref;
  var name, email, id, country_code, phone, dob, image;


  @override
  void initState() {
    super.initState();
    getUserList();
    //getDiff();
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
    print("id no. 1: " +id.toString());
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'We Mark The Spot',
          theme: theme(),
          home:  Splash()
        );
      },
    );
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
    print("time1 "+birthday.toString());
    print("time2 "+date2.toString());
    print("time3 "+difference.toString());
  }



}