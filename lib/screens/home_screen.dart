import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                // onTap: () {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => FliterScreen()));
                // },
                child: SvgPicture.asset(
                  "assets/icons/heart1.svg",
                  width: 26,
                  color: Colors.white,
                ),
              ),

              SizedBox(
                width: 6.h,
              ),

              //Image.asset("assets/images/logo_name.png"),

              Text(
                "WE MARK THE SPOT",
                style: TextStyle(
                    fontSize: 18.sp, color: Colors.white, fontFamily: "Roboto"),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Quote of the week",
                style: TextStyle(
                    fontSize: 20.sp, color: kCyanColor, fontFamily: "Segoepr"),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 23.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: Colors.white),
                child: Image.asset("assets/images/map1.png"),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 50.w),
                child: Text(
                  "“Lorem Ipsum”",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontFamily: "Segoepr"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut placerat orci nulla. Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Tempor id eu nisl nunc mi ipsum faucibus. Fusce id velit ut tortor pretium. Massa ultricies mi quis hendrerit dolor magna eget. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFFCECECE),
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 23.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: Colors.white),
                child: Image.asset("assets/images/map1.png"),
              ),
              SizedBox(
                height: 2.h,
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.w),
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/images/restaurant.jpeg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // child: Image.asset(),
                  ),
                  Positioned(
                    bottom: 2.h,
                    left: 8.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Business",
                          style: TextStyle(
                              fontSize: 21.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                              //fontFamily: "Segoepr"
                              ),
                        ),
                        Text(
                          "Restaurant Name",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            //fontWeight: FontWeight.w700
                            //fontFamily: "Segoepr"
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 3.h,
                    right: 6.w,
                    child: Row(
                      children: [
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            //fontWeight: FontWeight.w700
                            //fontFamily: "Segoepr"
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        SvgPicture.asset(
                          "assets/icons/star.svg",
                          color: Color(0xFFE8CD73),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Open time: 10:00 AM",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500
                              //fontFamily: "Segoepr"
                              ),
                        ),
                        Text(
                          "Close time: 04:00 PM",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      "Distance: 2.3 mi",
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500
                          //fontFamily: "Segoepr"
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFFCECECE),
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 58.w),
                child: Text(
                  "Giveaways",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: kCyanColor,
                      fontFamily: "Segoepr"),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFFCECECE),
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFFCECECE),
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }
}
