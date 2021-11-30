import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';

import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

class DetailBussiness extends StatefulWidget {
  const DetailBussiness({Key? key}) : super(key: key);

  @override
  _DetailBussinessState createState() => _DetailBussinessState();
}

class _DetailBussinessState extends State<DetailBussiness> {
    ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                height: 33.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: 33.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/restaurant.jpeg"),
                              fit: BoxFit.fill)),
                    ),
                    Positioned(
                      left: 2.w,
                      top: 1.h,
                      child: IconButton(
                          onPressed: () {

                            Navigator.pop(context);
                            
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          )),
                    ),
                    Positioned(
                        top: 2.h,
                        left: 85.w,
                        child: SvgPicture.asset(
                          "assets/icons/active-heart.svg",
                          width: 12.w,
                        ))
                  ],
                ),
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
                          "Bar Name",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: kCyanColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Segoepr"),
                        ),
                        SizedBox(width: 52.w),
                        Text(
                          "3.5",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500
                              //fontFamily: "Segoepr"
                              ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/star.svg",
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bar",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: kPrimaryColor,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                        ),
                        SizedBox(width: 50.w),
                        Text(
                          "1200 Reviews  | ",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: kPrimaryColor,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                        Text(
                          "25 People",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: kPrimaryColor,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location-.svg",
                          color: kCyanColor,
                          width: 4.w,
                        ),
                        Text(
                          "1230 Roosvelt Road, Wichita",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Distance: 1.2 mi",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Color(0XFF7A7A7A),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Center(
                      child: Text(
                        "Friday Night",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Segoepr"),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "Happy Hours",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: kCyanColor,
                          fontFamily: "Roboto"),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start Date: 12/08/2021",
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                        ),
                        Text(
                          "End Date: 14/08/2021",
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio tempor orci dapibus ultrices in. Egestas diam in arcu cursus euismod. Dictum fusce ut placerat orci nulla. Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Tempor id eu nisl nunc mi ipsum faucibus. Fusce id velit ut tortor pretium. Massa ultricies mi quis hendrerit dolor magna eget. Nullam eget felis eget nunc lobortis. Faucibus ornare suspendisse sed nisi. Sagittis eu volutpat odio facilisis mauris sit amet massa. Erat velit",
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0XFFCECECE),
                          // fontWeight: FontWeight.w500,
                          fontFamily: "Roboto"
                          //fontFamily: "Segoepr"
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      customDialog();
                    },
                    child: Container(
                      height: 7.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                          //color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: kPrimaryColor)),
                      child: Center(
                        child: Text(
                          "Leave a Review",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: kPrimaryColor,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      checkInDialog();
                    },
                    child: Container(
                      height: 7.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(12.w)),
                      child: Center(
                        child: Text(
                          "Check In",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"
                              //fontFamily: "Segoepr"
                              ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              InkWell(
                onTap: () {
                  customModelSheet(context);
                },
                child: Container(
                  height: 8.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kCyanColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.w),
                          topRight: Radius.circular(10.w))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        height: 1.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.w)),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "COMMUNITY REVIEWS",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Segoepr"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> customModelSheet(BuildContext context) {
    return showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        DraggableScrollableSheet(
                          expand: false,
                          maxChildSize: .95,
                          builder: (BuildContext context,
                                  ScrollController scrollController) =>
                              SingleChildScrollView(
                                  controller: scrollController,
                                  child: Container(
                                   // height: double.infinity,
                                    decoration: BoxDecoration(
                                        color: kCyanColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.w),
                                            topRight: Radius.circular(10.w))),
                                    child: SingleChildScrollView(

                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Container(
                                            height: 1.h,
                                            width: 25.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        3.w)),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            "COMMUNITY REVIEWS",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Segoepr"),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: 9,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 4.w),
                                                  height: 19.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.w),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black54
                                                              .withOpacity(0.3),
                                                          offset: Offset(2, 3),
                                                          blurRadius: 10,
                                                          spreadRadius: 1)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 1.5.h,
                                                                    left: 5.w),
                                                            child: Column(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 7.w,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          "assets/images/profilepic.jpeg"),
                                                                ),
                                                                SizedBox(
                                                                  height: 0.5.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "3.5",
                                                                      style: TextStyle(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontWeight:
                                                                              FontWeight.w500
                                                                          //fontFamily: "Segoepr"
                                                                          ),
                                                                    ),
                                                                    SvgPicture
                                                                        .asset(
                                                                      "assets/icons/star.svg",
                                                                      color:
                                                                          kPrimaryColor,
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Restaurant Name",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color:
                                                                          kCyanColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Segoepr"),
                                                                ),
                                                                Container(
                                                                    height: 6.h,
                                                                    width: 65.w,
                                                                    child: Text(
                                                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                                                      style: TextStyle(
                                                                          fontSize: 11.sp,
                                                                          color: Colors.black,
                                                                          // fontWeight: FontWeight.w500,
                                                                          fontFamily: "Roboto"
                                                                          //fontFamily: "Segoepr"
                                                                          ),
                                                                    ))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 1.5.h,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 2.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {},
                                                                    child:
                                                                        SvgPicture
                                                                            .asset(
                                                                      "assets/icons/up.svg",
                                                                      width:
                                                                          4.5.w,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1.w,
                                                                  ),
                                                                  Text(
                                                                    "Like(24)",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11.sp,
                                                                      color:
                                                                          kPrimaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {},
                                                                    child:
                                                                        SvgPicture
                                                                            .asset(
                                                                      "assets/icons/down.svg",
                                                                      width:
                                                                          4.5.w,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1.w,
                                                                  ),
                                                                  Text(
                                                                    "Dislike(05)",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11.sp,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Text(
                                                                "Report",
                                                                style: TextStyle(
                                                                  fontSize: 11.sp,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/share.svg",
                                                                width: 4.5.w,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 2.w),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Replies (05)",
                                                              style: TextStyle(
                                                                fontSize: 11.sp,
                                                                color:
                                                                    Colors.black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 1.h,
                                                            ),
                                                            Container(
                                                              height: 3.h,
                                                              width: 67.w,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7.w)),
                                                              child: SizedBox(
                                                                height: 3.h,
                                                                child:
                                                                    TextFormField(
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0XFFCECECE)),
                                                                  maxLines: 5,
                                                                  decoration: InputDecoration(
                                                                      border:
                                                                          InputBorder
                                                                              .none,
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      enabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      disabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      hintText:
                                                                          "Reply",
                                                                      hintStyle: TextStyle(
                                                                          fontSize: 8
                                                                              .sp,
                                                                          color: Colors
                                                                              .white)),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                          
                                                  SizedBox(height: 2.h,),
                                          
                                          
                                                ],
                                              ) ;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ));
  }

  // customBottomSheet() {
  //   return DraggableScrollableSheet(
  //     expand: true,
  //     initialChildSize: .2,
  //     minChildSize: .5,
  //     maxChildSize: 1,
  //     builder: (BuildContext context, ScrollController scrollController) {
  //       return Container(
  //         // width: double.infinity,
  //         // height: 90.h,
  //         decoration: BoxDecoration(
  //             color: kCyanColor,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(10.w),
  //                 topRight: Radius.circular(10.w))),
  //         child: SingleChildScrollView(
  //           controller: scrollController,
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: 1.h,
  //               ),
  //               Container(
  //                 height: 1.h,
  //                 width: 25.w,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(3.w)),
  //               ),
  //               SizedBox(
  //                 height: 1.h,
  //               ),
  //               Text(
  //                 "COMMUNITY REVIEWS",
  //                 style: TextStyle(
  //                     fontSize: 16.sp,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w700,
  //                     fontFamily: "Segoepr"),
  //               ),
  //               SizedBox(
  //                 height: 2.h,
  //               ),
  //               Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 4.w),
  //                   height: 19.h,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(4.w),
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Colors.black54.withOpacity(0.3),
  //                           offset: Offset(2, 3),
  //                           blurRadius: 10,
  //                           spreadRadius: 1)
  //                     ],
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(top: 1.5.h, left: 5.w),
  //                             child: Column(
  //                               children: [
  //                                 CircleAvatar(
  //                                   radius: 7.w,
  //                                   backgroundImage: AssetImage(
  //                                       "assets/images/profilepic.jpeg"),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 0.5.h,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text(
  //                                       "3.5",
  //                                       style: TextStyle(
  //                                           fontSize: 12.sp,
  //                                           color: kPrimaryColor,
  //                                           fontWeight: FontWeight.w500
  //                                           //fontFamily: "Segoepr"
  //                                           ),
  //                                     ),
  //                                     SvgPicture.asset(
  //                                       "assets/icons/star.svg",
  //                                       color: kPrimaryColor,
  //                                     )
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(left: 3.w),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   "Restaurant Name",
  //                                   style: TextStyle(
  //                                       fontSize: 13.sp,
  //                                       color: kCyanColor,
  //                                       fontWeight: FontWeight.w500,
  //                                       fontFamily: "Segoepr"),
  //                                 ),
  //                                 Container(
  //                                     height: 6.h,
  //                                     width: 65.w,
  //                                     child: Text(
  //                                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  //                                       style: TextStyle(
  //                                           fontSize: 11.sp,
  //                                           color: Colors.black,
  //                                           // fontWeight: FontWeight.w500,
  //                                           fontFamily: "Roboto"
  //                                           //fontFamily: "Segoepr"
  //                                           ),
  //                                     ))
  //                               ],
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 1.5.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 2.w),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Container(
  //                               child: Row(
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: () {},
  //                                     child: SvgPicture.asset(
  //                                       "assets/icons/up.svg",
  //                                       width: 4.5.w,
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     width: 1.w,
  //                                   ),
  //                                   Text(
  //                                     "Like(24)",
  //                                     style: TextStyle(
  //                                       fontSize: 11.sp,
  //                                       color: kPrimaryColor,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Container(
  //                               child: Row(
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: () {},
  //                                     child: SvgPicture.asset(
  //                                       "assets/icons/down.svg",
  //                                       width: 4.5.w,
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     width: 1.w,
  //                                   ),
  //                                   Text(
  //                                     "Dislike(05)",
  //                                     style: TextStyle(
  //                                       fontSize: 11.sp,
  //                                       color: Colors.black,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             InkWell(
  //                               onTap: () {},
  //                               child: Text(
  //                                 "Report",
  //                                 style: TextStyle(
  //                                   fontSize: 11.sp,
  //                                   color: Colors.black,
  //                                 ),
  //                               ),
  //                             ),
  //                             InkWell(
  //                               onTap: () {},
  //                               child: SvgPicture.asset(
  //                                 "assets/icons/share.svg",
  //                                 width: 4.5.w,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 2.w),
  //                         child: Row(
  //                           children: [
  //                             Text(
  //                               "Replies (05)",
  //                               style: TextStyle(
  //                                 fontSize: 11.sp,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: 1.h,
  //                             ),
  //                             Container(
  //                               height: 3.h,
  //                               width: 67.w,
  //                               decoration: BoxDecoration(
  //                                   color: Colors.black,
  //                                   borderRadius: BorderRadius.circular(7.w)),
  //                               child: SizedBox(
  //                                 height: 3.h,
  //                                 child: TextFormField(
  //                                   style: TextStyle(color: Color(0XFFCECECE)),
  //                                   maxLines: 5,
  //                                   decoration: InputDecoration(
  //                                       border: InputBorder.none,
  //                                       focusedBorder: InputBorder.none,
  //                                       enabledBorder: InputBorder.none,
  //                                       errorBorder: InputBorder.none,
  //                                       disabledBorder: InputBorder.none,
  //                                       hintText: "Reply",
  //                                       hintStyle: TextStyle(
  //                                           fontSize: 8.sp,
  //                                           color: Colors.white)),
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ))
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  checkInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          title: SingleChildScrollView(
              child: SizedBox(
            height: 50.h,
            width: 95.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        color: Colors.white,
                        width: 4.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.2.h,
                ),
                Text(
                  "How do you like restaurant\n"
                  "after check in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      // fontWeight: FontWeight.w500,
                      fontFamily: "Roboto"
                      //fontFamily: "Segoepr"
                      ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset("assets/icons/file.svg"),
                        Text(
                          "Fire",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,

                            //fontFamily: "Roboto"
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset("assets/icons/bakance.svg"),
                        Text(
                          "OkOk",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,

                            //fontFamily: "Roboto"
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset("assets/icons/snow.svg"),
                        Text(
                          "Not Cool",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,

                            //fontFamily: "Roboto"
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Overall Ratting",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: kCyanColor,

                            //fontFamily: "Roboto"
                          ),
                        ),
                        SizedBox(
                          height: 0.6.h,
                        ),
                        RatingBar.builder(
                          itemSize: 24,
                          unratedColor: Color(0XFFCECECE),
                          initialRating: 3,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 6.w,
                            color: kPrimaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Add Images/Video",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: kCyanColor,

                            //fontFamily: "Roboto"
                          ),
                        ),
                        SizedBox(
                          height: 0.6.h,
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {},
                                child:
                                    SvgPicture.asset("assets/icons/image.svg")),
                            SizedBox(
                              width: 3.w,
                            ),
                            InkWell(
                                onTap: () {},
                                child:
                                    SvgPicture.asset("assets/icons/video.svg")),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 12.h,
                  width: 85.w,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3.w)),
                  child: Expanded(
                    child: TextFormField(
                      style: TextStyle(color: Color(0XFFCECECE)),
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Type a Review...",
                          hintStyle: TextStyle(
                              fontSize: 12.sp, color: Color(0XFFCECECE))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Expanded(
                  child: DefaultButton(
                      width: 35.w, height: 6.h, text: "Submit", press: () {}),
                )
              ],
            ),
          )),
        );
      },
    );
  }

  customDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          title: SingleChildScrollView(
              child: SizedBox(
            height: 30.h,
            width: 95.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        color: Colors.white,
                        width: 4.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Overall Ratting",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: kCyanColor,

                            //fontFamily: "Roboto"
                          ),
                        ),
                        SizedBox(
                          height: 0.6.h,
                        ),
                        RatingBar.builder(
                          itemSize: 24,
                          unratedColor: Color(0XFFCECECE),
                          initialRating: 3,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 6.w,
                            color: kPrimaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Add Images/Video",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: kCyanColor,

                            //fontFamily: "Roboto"
                          ),
                        ),
                        SizedBox(
                          height: 0.6.h,
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {},
                                child:
                                    SvgPicture.asset("assets/icons/image.svg")),
                            SizedBox(
                              width: 3.w,
                            ),
                            InkWell(
                                onTap: () {},
                                child:
                                    SvgPicture.asset("assets/icons/video.svg")),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 12.h,
                  width: 85.w,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3.w)),
                  child: Expanded(
                    child: TextFormField(
                      style: TextStyle(color: Color(0XFFCECECE)),
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Type a Review...",
                          hintStyle: TextStyle(
                              fontSize: 12.sp, color: Color(0XFFCECECE))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                DefaultButton(
                    width: 35.w, height: 6.h, text: "Submit", press: () {})
              ],
            ),
          )),
        );
      },
    );
  }

  // TextFormField buildReplyFormField() {
  //   return TextFormField(

  //     style: TextStyle(color: Colors.white),
  //     cursorColor: Colors.white,
  //     keyboardType: TextInputType.emailAddress,

  //     decoration: InputDecoration(
  //       hintText: "Enter your Email",
  //       hintStyle: TextStyle(color: Colors.grey),
  //       focusColor: Colors.white,

  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       fillColor: Colors.white,
  //       suffixIcon: CustomSurffixIcon(
  //         svgIcon: "assets/icons/Mail.svg",
  //       ),
  //     ),
  //   );
  // }

}
