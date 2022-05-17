import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;



class PrivacyAndPolicy extends StatefulWidget {
  const PrivacyAndPolicy({ Key? key }) : super(key: key);

  @override
  _PrivacyAndPolicyState createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {

  bool isloading = false;

  String description = "";

  @override
  void initState() {
    ppApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
  


         appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Privacy & Policy",
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: double.infinity,
              child:
               Html(data: description.toString(),)
              
              
              //  Text(
              //                       description.toString(),
              //                           style: TextStyle(
              //                               //overflow: TextOverflow.ellipsis,
              //                               fontSize: 10.2.sp,
              //                               color: Color(0xFFCECECE),
              //                               fontFamily: 'Roboto'),
              //                         ),
            )
          ],
        ),
      ),
      
    );
  }

       Future<dynamic> ppApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(Uri.parse(RestDatasource.PRIVACYANDPOLICY_URL));

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
        description = jsonRes['data']["description"].toString();

        print("print: "+description.toString());

        setState(() {

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
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }

   

  }
}