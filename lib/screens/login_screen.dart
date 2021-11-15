import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/forgotPassword.dart';
import 'package:wemarkthespot/screens/home_screen.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/otp_Screen.dart';
import 'package:wemarkthespot/screens/signup_Screen.dart';
import 'package:wemarkthespot/services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isloading = false;
  String? email;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool remember = false;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 6.h,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeNav()));
                      },
                      child: Text(
                        "Skip",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 6.h,
              ),

              Center(child: Image.asset("assets/images/logo_name.png")),
              // Text(
              //   "WE MARK THE SPOT",
              //   style: TextStyle(color: kPrimaryColor, fontSize: 20.sp),
              // ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Now",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: kCyanColor,
                        fontFamily: 'Segoepr'),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    height: 4.h,
                    width: 1.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: kThirdcolor,
                          fontFamily: 'Segoepr'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildEmailFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPasswordFormField(),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                children: [
                  Checkbox(
                      activeColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return kPrimaryColor;
                        }
                        return Colors.white60;
                      }),
                      value: remember,
                      onChanged: (val) {
                        setState(() {
                          remember = val!;
                        });
                      }),
                  Text(
                    "Remember me",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12.sp,
                        fontFamily: 'Roboto'),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: kCyanColor,
                            fontSize: 12.sp,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  )
                ],
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
                  :



              DefaultButton(
                  width: 42.w,
                  height: 6.h,
                  text: "Login",
                  press: () {
                    var email = emailController.text.toString().trim();
                    var password = passwordController.text.toString().trim();
                    



                  






                    if (EmailValidator.validate(email) ) {
                          if (
                        password.length > 7 &&
                        password.length < 25) {

                          loginApi(email.toString(), password.toString());

                         


                     
                      
                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password must be between 8 to 25 Charactors")));
                    }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter email id")));
                    }

                
                  }),
              SizedBox(
                height: 10.h,
              ),
              
            ],
          ),
        ),
      ),
    );
  }





  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please Enter Your Email Id';
        }
        if (!EmailValidator.validate(email.toString())) {
          return 'Please Enter valid Email Id';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please Enter Your Password';
        }
        if (val.length < 9 && val.length > 25) {
          return 'Please Enter valid phone number';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Enter your password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }




  Future<dynamic> loginApi(String email, String password, ) async {
    setState(() {
      isloading = true;
    });
    print(email);
    print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(

          RestDatasource.LOGIN_URL,
         
        ),
        body: {
          "email": email.toString().trim(),
          "password": password.toString().trim(),
          
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
            MaterialPageRoute(builder: (context) => HomeNav()),
            (route) => false);

        setState(() {
          isloading = false;
        });
      }else{
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
        //isloading = false;
      });
    }
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
        color: Colors.grey,
      ),
    );
  }
}
