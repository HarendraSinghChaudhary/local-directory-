import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotspot.dart';

class CommunityReplies extends StatefulWidget {
  const CommunityReplies({Key? key}) : super(key: key);

  @override
  _CommunityRepliesState createState() => _CommunityRepliesState();
}

class _CommunityRepliesState extends State<CommunityReplies> {
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
              "Replies",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
       
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          height: 8.h,
          width: double.infinity,
          //color: Colors.orange,

          child: Row(
            children: [
              IconButton(onPressed: () {}, 
              icon: Icon(Icons.add_circle_outline, size: 9.w, color: kPrimaryColor,), 
              ),

              SizedBox(width: 1.w,),

              Container(
                padding: EdgeInsets.only(top: 1.5.h),
                height: 6.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: kCyanColor,
                  borderRadius: BorderRadius.circular(8.w)
                ),

                child: Center(
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    maxLines: 1,
                  
                    onChanged: (val) {
                    
                    },
                   
                     decoration: InputDecoration(
                       focusColor: Colors.white,
                       hoverColor: Colors.white,
                    //   // fillColor: kCyanColor,
                    //   // filled: true,
                      
                        border: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         enabledBorder: InputBorder.none,
                         errorBorder: InputBorder.none,
                         disabledBorder: InputBorder.none,
                        hintText: "Type..",
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            ),
                        
                    
                       ),
                  ),
                ),
              ),

              SizedBox(width: 3.w,),

               InkWell(
                 onTap: () {},
                 child: SvgPicture.asset("assets/icons/send1.svg", width: 8.w, color: kPrimaryColor,)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w)),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
                              child: CircleAvatar(
                                radius: 7.w,
                                backgroundImage:
                                    AssetImage("assets/images/profilepic.jpeg"),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Person Name @ Bar Name",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: kCyanColor,
                                              fontFamily: "Segoepr"),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Text(
                                          "2m ago",
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
                                      style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                          fontSize: 10.2.sp,
                                          color: Colors.black,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "View Replies",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 2.h,
                    ),
                    //replyWidget(controller: _controller),

                    replyWidget(controller: _controller),

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

class replyWidget extends StatelessWidget {
  const replyWidget({
    Key? key,
    required ScrollController controller,
  }) : _controller = controller, super(key: key);

  final ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Card(
           margin: EdgeInsets.symmetric(horizontal: 4.w),
          
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 2.w, top:1.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 4.h, left: 1.w),
                      child: CircleAvatar(
                        radius: 6.w,
                        backgroundImage: AssetImage(
                            "assets/images/profilepic.jpeg"),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 74.w,
                            child: Row(
                              children: [
                                Text(
                                  "Person Name @ Bar Name",
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: kCyanColor,
                                      fontFamily: "Segoepr"),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 0.1.h,
                          ),
                          Container(
                            width: 74.w,
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                              style: TextStyle(
                                  //overflow: TextOverflow.ellipsis,
                                  fontSize: 8.5.sp,
                                  color: Colors.black87,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            width: 74.w,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                Text(
                                  "2m ago",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 4.w),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      "Reply",
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: kPrimaryColor,
                                          fontFamily:
                                              "Roboto"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h,),
                        ],
                      ),
                    ),

                    
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                 
                     margin: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 8.w,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 6.h, left: 0.w),
                              child: CircleAvatar(
                                radius: 4.w,
                                backgroundImage: AssetImage(
                                    "assets/images/profilepic.jpeg"),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Person Name @ Bar Name",
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kCyanColor,
                                              fontFamily:
                                                  "Segoepr"),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.",
                                      style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                          fontSize: 8.5.sp,
                                          color:
                                              Colors.black87,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                          "2m ago",
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(
                                                  right: 6.w),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                   fontSize: 10.sp,
                                          color: kPrimaryColor,
                                                  fontFamily:
                                                      "Roboto"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 0.w),
                      
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16.w,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 6.h, left: 0.w),
                                child: CircleAvatar(
                                  radius: 4.w,
                                  backgroundImage: AssetImage(
                                      "assets/images/loc.png"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Flexible(
                              flex: 8,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 70.w,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Person Name @ Bar Name",
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kCyanColor,
                                                fontFamily:
                                                    "Segoepr"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.1.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 0.w),
                                      child: Container(
                                        width: 70.w,
                                        child: Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                                          style: TextStyle(
                                              //overflow: TextOverflow.ellipsis,
                                              fontSize: 8.5.sp,
                                              color: Colors.black87,
                                              fontFamily:
                                                  'Roboto'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      width: 74.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Text(
                                            "2m ago",
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              color:
                                                  kPrimaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(
                                                    right: 6.w),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Text(
                                                "Reply",
                                                style: TextStyle(
                                                   fontSize: 10.sp,
                                                color: kCyanColor,
                                                    fontFamily:
                                                        "Roboto"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
