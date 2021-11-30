import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/instead/iConstant.dart';
import 'package:wemarkthespot/instead/iLogin.dart';


class IloginDashBoard extends StatefulWidget {
  const IloginDashBoard({ Key? key }) : super(key: key);

  @override
  _LOginDashBoardState createState() => _LOginDashBoardState();
}

class _LOginDashBoardState extends State<IloginDashBoard> {

  String selected = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.h,),

            SvgPicture.asset("assets/instaAssets/intsandLogo.svg"),

            SizedBox(height: 6.h,),
            InkWell(
              onTap: () {
                setState(() {
                  selected = "first";
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Ilogin()));
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
            
                height: 14.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selected == "first" ? iPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                   boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(2, 3),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
            
                ),
                child: Center(
                  child: Text("EMPLOYEE",
                  style: TextStyle(
                    color: selected == "first" ? Colors.white: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
            
                  ),
                  ),
                ),
            
              ),
            ),
             SizedBox(height: 3.h,),


              InkWell(
              onTap: () {
                setState(() {
                  selected = "second";
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
            
                height: 14.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selected == "second" ? iPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                   boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(2, 3),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
            
                ),
                child: Center(
                  child: Text("VENUE OWNER",
                  style: TextStyle(
                    color: selected == "second" ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
            
                  ),
                  ),
                ),
            
              ),
            ),
             SizedBox(height: 3.h,),



              InkWell(
              onTap: () {
                setState(() {
                  selected = "third";
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
            
                height: 14.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selected == "third" ? iPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                   boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(2, 3),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
            
                ),
                child: Center(
                  child: Text("ADMIN",
                  style: TextStyle(
                    color: selected == "third" ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
            
                  ),
                  ),
                ),
            
              ),
            ),
             SizedBox(height: 3.h,),
          ],
        ),
      ),
      
    );
  }
}