import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/otp_Screen.dart';
import 'package:wemarkthespot/screens/signup_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool remember = false;

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
              Text(
                "WE MARK THE SPOT",
                style: TextStyle(color: kPrimaryColor, fontSize: 20.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Now",
                    style: TextStyle(fontSize: 16.sp, color: kCyanColor),
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
                      style: TextStyle(fontSize: 16.sp, color: kThirdcolor),
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
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OtpScreen()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.none, color: kCyanColor),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              DefaultButton(
                  width: 60.w,
                  height: 8.h,
                  text: "Login",
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OtpScreen()));
                  }),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 12.sp, color: kPrimaryColor),
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your Email/Phone No.",
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
