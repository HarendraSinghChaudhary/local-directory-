import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';


class CheckIn extends StatefulWidget {
  const CheckIn({ Key? key }) : super(key: key);

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Check Ins",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),



       body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3.h,),
             ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 14,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 11.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              color: kBackgroundColor),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 0.h, left: 2.w),
                                child: CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage: AssetImage(
                                      "assets/images/profilepic.jpeg"),
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Container(
                                child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      
                                      width: 74.w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bar Name",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: kCyanColor,
                                                fontFamily: "Segoepr"),
                                          ),
                                          
                                         
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.4.h,
                                    ),
                                    Row(
                                        children: [
                                          Text(
                                            "checked in",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kPrimaryColor,
                                                
                                                fontFamily: "Roboto"),
                                          ),
                                          SizedBox(
                                            width: 1.2.w,
                                          ),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.grey,
                                               
                                                fontFamily: "Roboto"),
                                          ),
                                          SizedBox(
                                            width: 1.2.w,
                                          ),
                                          Text(
                                            "2 days ago",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0XFF979797),
                                              //fontWeight: FontWeight.w700
                                              //fontFamily: "Segoepr"
                                            ),
                                          ),
                                        
                                        ],
                                      ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                  
                                  ],
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                     
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      
    );
  }
}