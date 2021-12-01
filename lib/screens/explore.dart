import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Map<String, String>> sliderImages = [
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg.jpg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/11.jpeg.jpg"
    },
  ];

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Padding(
          padding: EdgeInsets.only(left: 21.w),
          child: Text(
            "Explore",
            style:
                TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        controller: _controller,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.5.h,
                ),
                Text(
                  "Featured Business",
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Segoepr"),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                CustomSliderWidget(
                  items: [
                    "assets/images/11.jpeg",
                    "assets/images/11.jpeg",
                    "assets/images/restaurant.jpeg"
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Text(
                  "Restaurant Nearby ",
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Segoepr"),
                ),
                // SizedBox(
                //   height: 1.5.h,
                // ),

                // Container(
                //   height: 18.h,
                //   color: Colors.grey,

                //   child: Stack(
                //   children: [
                //     Positioned(
                //       top: 2.5.h,
                     
                //       child: Container(
                //         height: 13.h,
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(3.w),
                //             color: Color(0xFF7A7A7A)),
                //         child: Row(
                //           children: [
                //             Container(
                //               height: 14.h,
                //               width: 16.h,
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(3.w),
                //                   color: Colors.white,
                //                   image: DecorationImage(
                //                       image: AssetImage(
                //                         "assets/images/11.jpeg",
                //                       ),
                //                       fit: BoxFit.fill)),
                //             ),
                //             SizedBox(
                //               width: 2.w,
                //             ),
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 SizedBox(
                //                   height: 0.3.h,
                //                 ),
                //                 Text(
                //                   "Restaurant Name ",
                //                   style: TextStyle(
                //                       fontSize: 14.sp,
                //                       color: kCyanColor,
                //                       fontWeight: FontWeight.w700,
                //                       fontFamily: "Segoepr"),
                //                 ),
                //                 Row(
                //                   children: [
                //                     Text(
                //                       "0.2 miles away",
                //                       style: TextStyle(
                //                           fontSize: 10.sp,
                //                           color: kPrimaryColor,
                //                           fontWeight: FontWeight.w700,
                //                           fontFamily: "Roboto"),
                //                     ),
                //                     SizedBox(
                //                       width: 1.2.w,
                //                     ),
                //                     Text(
                //                       "|",
                //                       style: TextStyle(
                //                           fontSize: 10.sp,
                //                           color: Colors.grey,
                //                           fontWeight: FontWeight.w700,
                //                           fontFamily: "Roboto"),
                //                     ),
                //                     SizedBox(
                //                       width: 1.2.w,
                //                     ),
                //                     Text(
                //                       "4.5",
                //                       style: TextStyle(
                //                         fontSize: 10.sp,
                //                         color: kPrimaryColor,
                //                         //fontWeight: FontWeight.w700
                //                         //fontFamily: "Segoepr"
                //                       ),
                //                     ),
                //                     SizedBox(
                //                       width: 1.w,
                //                     ),
                //                     SvgPicture.asset(
                //                       "assets/icons/star.svg",
                //                       color: kPrimaryColor,
                //                     )
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 1.h,
                //                 ),
                //                 Container(
                //                   width: 56.w,
                //                   child: Text(
                //                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
                //                     style: TextStyle(
                //                         fontSize: 8.sp, color: Colors.white
                //                         //fontWeight: FontWeight.w700
                //                         //fontFamily: "Segoepr"
                //                         ),
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       right: 1.w,
                //       top: 0.2.h,
                //       child: InkWell(
                //           onTap: () {},
                //           child: SvgPicture.asset(
                //               "assets/icons/-heart.svg")),
                //     )
                //   ],
                // ),

                // ),


                SizedBox(
                  height: 1.5.h,
                ),



                ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return   Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBussiness()));
                          },
                          child: Container(
                                          height: 16.h,
                                         
                        
                                          child: Stack(
                                          children: [
                          Positioned(
                            //top: 2.5.h,
                            
                           
                            child: Container(
                              height: 13.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                  color: kBackgroundColor),
                              child: Row(
                                children: [
                                  Container(
                                    height: 14.h,
                                    width: 16.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.w),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/11.jpeg",
                                            ),
                                            fit: BoxFit.fill)),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 0.3.h,
                                      ),
                                      Text(
                                        "Restaurant Name ",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: kCyanColor,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Segoepr"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "0.2 miles away",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w700,
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
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Roboto"),
                                          ),
                                          SizedBox(
                                            width: 1.2.w,
                                          ),
                                          Text(
                                            "4.5",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kPrimaryColor,
                                              //fontWeight: FontWeight.w700
                                              //fontFamily: "Segoepr"
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          SvgPicture.asset(
                                            "assets/icons/star.svg",
                                            color: kPrimaryColor,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        width: 56.w,
                                        child: Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
                                          style: TextStyle(
                                              fontSize: 8.sp, color: Colors.white
                                              //fontWeight: FontWeight.w700
                                              //fontFamily: "Segoepr"
                                              ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 1.w,
                            top: 0.2.h,
                            child: InkWell(
                                onTap: () {},
                                child: SvgPicture.asset(
                                    "assets/icons/-heart.svg")),
                          )
                                          ],
                                        ),
                        
                                        ),
                        ),

                // SizedBox(height: 0.5.h,),
                      ],
                    );

                  },
                ),


                
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomSliderWidget extends StatefulWidget {
  // final List<String> items;
  final List items;

  CustomSliderWidget({required this.items});

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  int activeIndex = 0;
  setActiveDot(index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              onPageChanged: (index, reason) {
                setActiveDot(index);
              },
              enableInfiniteScroll: false,
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              autoPlayAnimationDuration: Duration(seconds: 2),
              // autoPlay: true,
              viewportFraction: 1.0,
            ),
            items: widget.items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(children: [
                    Container(
                     
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.w),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Image.asset(),
                    ),
                    Positioned(
                      bottom: 6.h,
                      left: 8.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Business",
                          //   style: TextStyle(
                          //       fontSize: 21.sp,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w700
                          //       //fontFamily: "Segoepr"
                          //       ),
                          // ),
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
                      bottom: 6.h,
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
                            color: kPrimaryColor,
                          )
                        ],
                      ),
                    ),
                  ]);
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          left: 20,
          right: 0,
          bottom: 20,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (idx) {
                return activeIndex == idx ? ActiveDot() : InactiveDot();
              })),
        )
      ],
    );
  }
}

class ActiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class InactiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
