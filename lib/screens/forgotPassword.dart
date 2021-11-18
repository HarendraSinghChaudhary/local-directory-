import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/otp_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isloading = false;

  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Center(child: Image.asset("assets/images/logo_name.png")),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Forgot Password",
              style: TextStyle(
                  color: kCyanColor, fontSize: 18.5.sp, fontFamily: 'Segoepr'),
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              child: Text(
                "Enter your email address to follow\n"
                "the instructions to reset password",
                style: TextStyle(
                    color: Color(0xFFCECECE),
                    fontSize: 11.sp,
                    fontFamily: 'Roboto'),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildEmailFormField(),
            ),
            SizedBox(
              height: 3.h,
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
                    text: "Submit",
                    press: () {
                      var email = emailController.text.toString().trim();

                      if (EmailValidator.validate(email)) {
                        forgotPasswordApi(email.toString());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter valid email id")));
                      }
                    }),
          ],
        ),
      ),
    );
  }

  Future<dynamic> forgotPasswordApi(
    String email,
  ) async {
    setState(() {
      isloading = true;
    });
    print(email);

    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.FORGOTPASSWORD_URL,
        ),
        body: {
          "email": email.toString().trim(),
        });

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
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

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      email: email.toString(),
                    )),
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your Email",
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
    );
  }
}

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        20,
        20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 18,
        color: kPrimaryColor,
      ),
    );
  }
}
