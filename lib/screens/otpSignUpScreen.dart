import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/change_password.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/resetPassword.dart';
import 'package:wemarkthespot/services/api_client.dart';
import '../constant.dart';

class OTPSignUp extends StatefulWidget {
  String email;

  OTPSignUp({required this.email});

  @override
  _OTPSignUpState createState() => _OTPSignUpState();
}

class _OTPSignUpState extends State<OTPSignUp> {
  String? otp;

  TextEditingController first = new TextEditingController();
  TextEditingController second = new TextEditingController();
  TextEditingController third = new TextEditingController();
  TextEditingController fourth = new TextEditingController();

  bool isloading = false;

  late FocusNode pin1FocusNode;
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void previousField(String value, FocusNode focusNode) {
    if (value.length == 0) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
      SizedBox(
        height: 12.h,
      ),
      Center(child: Image.asset("assets/images/logo_name.png")),
      SizedBox(
        height: 8.h,
      ),
      Text(
        "OTP Verification",
        style: TextStyle(
            color: kCyanColor, fontSize: 18.5.sp, fontFamily: 'Segoepr'),
      ),
      SizedBox(
        height: 2.h,
      ),
      Text(
        "Please enter OTP send on your email",
        style: TextStyle(
            color: Color(0xFFCECECE), fontSize: 11.sp, fontFamily: 'Roboto'),
      ),
      SizedBox(
        height: 10.h,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
              controller: first,
              focusNode: pin1FocusNode,
              autofocus: true,
              obscureText: false,
              style: TextStyle(fontSize: 24, color: Colors.white),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: otpInputDecoration,
              onChanged: (value) {
                nextField(value, pin2FocusNode);
                //previousField(value, pin2FocusNode);
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
                controller: second,
                focusNode: pin2FocusNode,
                obscureText: false,
                style: TextStyle(fontSize: 24, color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  nextField(value, pin3FocusNode);
                  previousField(value, pin2FocusNode);
                }),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
                controller: third,
                focusNode: pin3FocusNode,
                obscureText: false,
                style: TextStyle(fontSize: 24, color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  nextField(value, pin4FocusNode);
                  previousField(value, pin3FocusNode);
                }),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
              controller: fourth,
              focusNode: pin4FocusNode,
              obscureText: false,
              style: TextStyle(fontSize: 24, color: Colors.white),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: otpInputDecoration,
              onChanged: (value) {
                if (value.length == 1) {
                  pin4FocusNode.unfocus();
                  // Then you need to check is the code is correct or not
                }
              },
            ),
          ),
        ]),
      ),
      SizedBox(
        height: 5.h,
      ),
      InkWell(
        onTap: () {
          print("object");
          resendOtpdApi(widget.email);
        },
        child: Text(
          "Resend OTP",
          style: TextStyle(
              color: kPrimaryColor, fontSize: 12.sp, fontFamily: 'Roboto'),
        ),
      ),
      SizedBox(
        height: 7.h,
      ),
      isloading
          ? Align(
              alignment: Alignment.center,
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator())
          : DefaultButton(
              width: 40.w,
              height: 6.h,
              text: "Continue",
              press: () {
                otp = first.text.toString().trim() +
                    second.text.toString().trim() +
                    third.text.toString().trim() +
                    fourth.text.toString().trim();
                if(otp!.length<4){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Please enter correct OTP")));
                }else {
                  forgotPasswordApi(widget.email.toString(), otp.toString());
                }
              })
    ]))));
  }

  Future<dynamic> forgotPasswordApi(String email, String otp) async {
    setState(() {
      isloading = true;
    });

    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.OTPPASSWORD_URL,
        ),
        body: {
          "email": widget.email.toString().trim(),
          "otp": otp,
          "method": "1"
        });

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      msg = jsonRes["message"].toString();
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.commit();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeNav()),
            (route) => false);

        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }

  Future<dynamic> resendOtpdApi(
    String email,
  ) async {
    print("object");
    setState(() {
      isloading = true;
    });
    print(email);

    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.RESEND_OTP,
        ),
        body: {
          "email": widget.email.toString().trim(),
        });

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      msg = jsonRes["message"].toString();
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('id', jsonRes["data"]["id"].toString());
        // prefs.setString('email', jsonRes["data"]["email"].toString());
        // prefs.commit();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));

        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => OtpScreen(email: email.toString(),)),
        //     (route) => false);

        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
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
