import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
              "Favorites",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBussiness()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
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
                                          borderRadius:
                                              BorderRadius.circular(3.w),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            ),
                            Positioned(
                              right: 1.w,
                              top: 0.2.h,
                              child: InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                      "assets/icons/-heart.svg",
                                      color: kCyanColor,)),
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
      ),
    );
  }
}
