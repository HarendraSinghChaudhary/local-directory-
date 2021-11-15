import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  bool checkTandC = false;
  var _selected = "0";

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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeNav()));
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
                child: buildPhoneFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPasswordFormField(),
              ),

              Row(
                children: [
                  Radio(
                    activeColor: kPrimaryColor,
                    hoverColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return kPrimaryColor;
                      }
                      return Colors.white60;
                    }),
                    value: "1",
                    groupValue: _selected,
                    onChanged: (val) {
                      setState(() {
                        _selected = val.toString();
                      });
                    },
                  ),
                  Text(
                    "I agree with terms and condition and private policy",
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
                  :

              DefaultButton(
                  width: 40.w,
                  height: 6.h,
                  text: "Sign Up",
                  press: () {
                    String username = "";
                    username = nameController.text.toString().trim();
                   
                    var email = emailController.text.toString().trim();
                    var password = passwordController.text.toString().trim();
                    var confirmPassword =
                        confirmPasswordController.text.trim().toString();

                    if (username.toString()!= "") {
                      print("name: " +username.toString()+"00");

                      if (EmailValidator.validate(email)) {
                        print("email: " +email.toString());


                        if (password.length > 7 && password.length < 25) {
                          print("password: " +password.toString());


                          if (password.toString() == confirmPassword.toString()) {
                            print("confirm password: " +confirmPassword.toString());
                            userRegister(username.toString(),
                            email.toString(),
                            password.toString());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password and confirm password must be same")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Password must be between 8 to 25 Charactors")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter email id ")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your name")));
                    }
                  }),

       
            ],
          ),
        ),
      ),
    );
  }


    Future<dynamic> userRegister(String username, String email, String password) async {
    setState(() {
      isloading = true;
    });
    print("username: "+username);
    print("useremail: "+email);
    print("userpassword: "+password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.SignUP_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {"username": username.toString(),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to registered Email Id  ')),
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
      inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
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

  TextFormField buildPhoneFormField() {
    return TextFormField(
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
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
