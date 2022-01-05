import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/signup_Screen.dart';





class GuestAccount extends StatefulWidget {
  const GuestAccount({Key? key}) : super(key: key);

  @override
  _GuestAccountState createState() => _GuestAccountState();
}

class _GuestAccountState extends State<GuestAccount> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.h),
          height: 10.h,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Profile",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Log in or sign up to view your complete profile",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        DefaultButton(
            width: 45.w,
            height: 6.5.h,
            text: "Continue",
            press: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (route) => false);
            }),
      ],
    );
  }
}




class FavGuest extends StatefulWidget {
  const FavGuest({ Key? key }) : super(key: key);

  @override
  _FavGuestState createState() => _FavGuestState();
}

class _FavGuestState extends State<FavGuest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.h),
          height: 10.h,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Favourite Business",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Log in or sign up to view your favourite business",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        DefaultButton(
            width: 45.w,
            height: 6.5.h,
            text: "Continue",
            press: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (route) => false);
            }),
      ],
    );
  }
}