import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/login_screen.dart';
import 'package:wemarkthespot/screens/otpSignUpScreen.dart';
import 'package:wemarkthespot/screens/otp_Screen.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscure = true;
  bool obscure1 = true;

  String guestMail = "guest@yopmail.com";
  String guestPassword = "123456";

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  bool checkTandC = false;
  var _selected = "0";
  bool agree = false;
  bool isloading = false;

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
                        guestApi(guestMail.toString().trim(),
                            guestPassword.toString().trim());
                      },
                      child: Text(
                        "Skip",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          //fontFamily: 'Segoe'
                        ),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Login Now",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: kThirdcolor,
                          fontFamily: 'Segoepr'),
                    ),
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
                    onTap: () {},
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: kCyanColor,
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
                child: buildNameFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildEmailFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPasswordFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildConfirmPasswordFormField(),
              ),

              Row(
                children: [
                  Checkbox(
                      activeColor: Color(0xFFE9BC1D),
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
                      value: agree,
                      onChanged: (val) {
                        setState(() {
                          agree = val!;
                        });
                      }),

                  // Radio(
                  //   activeColor: kPrimaryColor,
                  //   hoverColor: Colors.white,
                  //   fillColor: MaterialStateProperty.resolveWith((states) {
                  //     if (states.contains(MaterialState.selected)) {
                  //       return kPrimaryColor;
                  //     }
                  //     return Colors.white60;
                  //   }),
                  //   value: true,
                  //   groupValue: selected,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       selected = !selected;
                  //     });
                  //   },
                  // ),
                  Text(
                    "I agree with terms & condition and privacy policy",
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ],
              ),
              // ListTile(
              //   title: Text("I agree with terms and condition and private policy",
              //   style: TextStyle(
              //     color: kPrimaryColor,
              //     fontSize: 10.sp
              //   ),

              //   ),
              //   leading: Radio(
              //     activeColor: kPrimaryColor,
              //     hoverColor: Colors.white,
              //     fillColor: MaterialStateProperty.resolveWith((states) {
              //           if (states.contains(MaterialState.selected)) {
              //             return kPrimaryColor;
              //           }
              //           return Colors.white60;
              //         }),
              //     value: "1",
              //     groupValue: _selected,
              //     onChanged: (val) {
              //       setState(() {
              //         _selected = val.toString();
              //       });
              //     },
              //   ),
              // ),

              SizedBox(
                height: 5.h,
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
                      text: "Sign Up",
                      press: () {

                          String confirmPassword = "";
                          String username = "";
                          username = nameController.text.toString().trim();

                          var email = emailController.text.toString().trim();
                          var password =
                              passwordController.text.toString().trim();
                         confirmPassword =
                              confirmPasswordController.text.trim().toString();

                          if (username.toString() != "") {
                            print("name: " + username.toString() + "");

                            if (EmailValidator.validate(email)) {
                              print("email: " + email.toString());

                              if (password.length > 7 && password.length < 25) {
                                print("password: " + password.toString());

                                if (confirmPassword.toString() != "") {

                                  if (password.toString() ==
                                    confirmPassword.toString()) {
                                  print("confirm password: " +
                                      confirmPassword.toString());
                                  if (agree) {
                                    userRegister(username.toString(),
                                        email.toString(), password.toString());
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please check on terms and conditions")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Password and confirm password must be same")));
                                }
                                  
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please enter confirm password")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please enter 8 to 25 characters password")));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please enter a valid email id ")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter your name")));
                          }

                      }),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> guestApi(
    String email,
    String password,
  ) async {
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
          "email": guestMail.toString().trim(),
          "password": guestPassword.toString().trim(),
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
         SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.setString('name', jsonRes["data"]["name"].toString());
        prefs.setString('country_code', jsonRes["data"]["country_code"].toString());
        prefs.setString('phone', jsonRes["data"]["phone"].toString());
        prefs.setString('dob', jsonRes["data"]["dob"].toString());
        prefs.setString('image', jsonRes["data"]["image"].toString());
        prefs.commit();


        print("image: "+jsonRes["data"]["image"].toString());

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(msg)));

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
        //isloading = false;
      });
    }
  }

  Future<dynamic> userRegister(
      String username, String email, String password) async {
    setState(() {
      isloading = true;
    });
    print("username: " + username);
    print("useremail: " + email);
    print("userpassword: " + password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.SignUP_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "username": username.toString(),
          "email": email.toString(),
          "password": password.toString()
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
      print("message: " + jsonRes["otp"].toString() + "_");

      if (jsonRes["status"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.setString('name', jsonRes["data"]["name"].toString());
        prefs.setString(
            'country_code', jsonRes["data"]["country_code"].toString());
        prefs.setString('phone', jsonRes["data"]["phone"].toString());
        prefs.setString('dob', jsonRes["data"]["dob"].toString());
        prefs.setString('image', jsonRes["data"]["image"].toString());
        prefs.commit();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"])),
        );

        // print('getotp1: ' + getotp.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPSignUp(
                      email: email.toString(),
                    )));

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

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: nameController,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      inputFormatters: [WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s"))],
      decoration: InputDecoration(
        hintText: " Name",
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/User Icon.svg",
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      //validator: validatePassword(),
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Email",
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
      obscureText: obscure,
      controller: passwordController,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      // keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: obscure
                  ? Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.visibility_off_outlined,
                      color: kPrimaryColor,
                    ),
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              }),
        ),
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      style: TextStyle(color: Colors.white),
      obscureText: obscure1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: obscure1
                  ? Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.visibility_off_outlined,
                      color: kPrimaryColor,
                    ),
              onPressed: () {
                setState(() {
                  obscure1 = !obscure1;
                });
              }),
        ),
      ),
    );
  }
}
