import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 13.w),
            child: Text(
              "Explore",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
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
                Stack(
                  children: [
                    Container(
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
                          // Text("Business",
                          //   style: TextStyle(
                          //     fontSize: 21.sp,
                          //     color:Colors.white,
                          //     fontWeight: FontWeight.w700
                          //     //fontFamily: "Segoepr"
                          //   ),),

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
                            color: kPrimaryColor,
                          )
                        ],
                      ),
                    )
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
                SizedBox(
                  height: 1.5.h,
                ),
               Stack(
                 children: [
                   Container(
                 height: 15.h,
                 child: Stack(
                   children: [
                      Container(
                  height: 13.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.w),
                      color: Color(0xFF7A7A7A)),
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

                      SizedBox(width: 2.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 0.3.h,),
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

                          SizedBox(width: 1.2.w,),

                            Text(
                            "|",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(width: 1.2.w,),

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

                          SizedBox(height: 1.h,),


                          Container(
                            width: 56.w,
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.white
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

                Positioned(
                  left: 14,
                  top: 1,
                  child: InkWell(
                    onTap: () {
                
                    },
                    child: SvgPicture.asset("assets/icons/-heart.svg")),
                )
                   ],
                 ),
               )
                 ],
               )
              ],
            ),
          )
        ],
      ),
    );
  }
}
