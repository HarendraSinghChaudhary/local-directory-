import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';


class Notifications extends StatefulWidget {
  const Notifications({ Key? key }) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

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
              "Notifications",
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
                          child: Column(
                            children: [
                              Container(
                                
                                
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "One New Message",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: kCyanColor,
                                            fontFamily: "Segoepr"),
                                      ),
                                     
                                      Padding(
                                        padding: EdgeInsets.only(right:3.w),
                                        child: Text(
                                          "2 hrs ago",
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.7.h,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                
                                child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                  style: TextStyle(
                                      //overflow: TextOverflow.ellipsis,
                                      fontSize: 10.2.sp,
                                      color: Color(0xFFCECECE),
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                            
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