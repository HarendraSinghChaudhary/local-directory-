import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({ Key? key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {



  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();



  bool isloading = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: 10.h,
              ),

             
              SizedBox(
                height: 6.h,
              ),
              Text(
                "Change Password",
                style: TextStyle(color: kCyanColor, fontSize: 20.sp),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Create your new secured password",
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              SizedBox(
                height: 7.h,
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPasswordFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildConfirmPasswordFormField(),
              ),



              
              SizedBox(
                height: 5.h,
              ),

              DefaultButton(
                  width: 50.w, height: 8.h, text: "Update", press: () {}),

              SizedBox(
                height: 6.h,
              ),

              
            ],
          ),
        ),
      ),
      
    );
  }
   TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        
      ),
    );
  }

   TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        
      ),
    );
  }

   Future<dynamic> changePassword(String oldPassword, String newPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
       var id = prefs.getString("id");
       print("id Print: " +id.toString());
    setState(() {
      isloading = true;
    });
    print(id.toString);
    print(oldPassword);
    print(newPassword);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.CHANGEPASSWORD_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "user_id": id.toString(),
          "oldPassword": oldPassword.toString(),
          "newPassword": newPassword.toString(),
        });

    await request.then((http.Response response) {
      res = response;
      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");

      if (jsonRes["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );

        // print('getotp1: ' + getotp.toString());
        Navigator.pop(context);

        setState(() {
          isloading = false;
        });
      }
      if (jsonRes["status"] == false) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }

}