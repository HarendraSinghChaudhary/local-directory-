import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

import '../constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkTandC = false;
  var _selected = "0";

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
                     Text("Skip",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    
                    color: kPrimaryColor,
                    fontSize: 12.sp
                  ),
                  ),
                   ],
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                "Sign Up",
                style: TextStyle(color: kCyanColor, fontSize: 20.sp),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Please sign up to enter the app.",
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              SizedBox(
                height: 7.h,
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
                 Text("I agree with terms and condition and private policy",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 10.sp
                ),

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

              DefaultButton(
                  width: 50.w, height: 8.h, text: "Sign Up", press: () {}),

              SizedBox(
                height: 6.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 12.sp,
                    color: kCyanColor
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Enter your Name",
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

  TextFormField buildPhoneFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter your Phone No.",
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/Call.svg",
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
        hintText: "Enter your password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
