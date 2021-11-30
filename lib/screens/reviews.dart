import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wemarkthespot/screens/testing.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<Map<dynamic, dynamic>> splashData = [
    {
      "title": "Bar Name",
      "subTitile":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
      "urlAvatar": "assets/images/profilepic.jpeg",
      "time": "2m ago"
    },
    {
      "title": "Bar Name",
      "subTitile":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
      "urlAvatar": "assets/images/profilepic.jpeg",
      "time": "2m ago"
    },
    {
      "title": "Bar Name",
      "subTitile":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
      "urlAvatar": "assets/images/profilepic.jpeg",
      "time": "2m ago"
    },
  ];

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
              "Reviews",
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
              itemCount: splashData.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                final item = splashData[index];

                return Column(
                  children: [
                    Slidable(
                      key: ValueKey(splashData[index]),

                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: ScrollMotion(),

                        // A pane can dismiss the Slidable.
                        dismissible: DismissiblePane(onDismissed: () {
                          splashData.removeAt(index);
                        }),

                        // All actions are defined in the children parameter.
                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            flex: 1,
                            onPressed: doNothing,
                            backgroundColor: kCyanColor,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),

                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 1,
                            // An action can be bigger than the others.

                            onPressed: deleteNothing,
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),

                      child: Container(
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
                                    EdgeInsets.only(bottom: 2.h, left: 2.w),
                                child: CircleAvatar(
                                  radius: 7.w,
                                  backgroundImage: AssetImage(splashData[index]
                                          ["urlAvatar"]
                                      .toString()),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            splashData[index]["title"]
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: kCyanColor,
                                                fontFamily: "Segoepr"),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.w),
                                            child: Text(
                                              splashData[index]["time"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 8.sp,
                                                color: kPrimaryColor,
                                              ),
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
                                        splashData[index]["subTitile"]
                                            .toString(),
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
                                ),
                              )
                            ],
                          )),
                    ),
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

  customDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          scrollable: true,
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

  customDeleteDialog() {
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
            height: 20.h,
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
                Text(
                  "Are you sure you\n"
                  "want to delete this review",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                     InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(9.w),
                            border: Border.all(
                              color: kPrimaryColor
                            )
                            ),
                        child: Center(
                          child: Text(
                            "No",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 12.sp, color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),

                    




                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(9.w)),
                        child: Center(
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          )),
        );
      },
    );
  }

  void doNothing(BuildContext context) {
    customDialog();
  }

  void deleteNothing(BuildContext context) {
    customDeleteDialog();
  }
}


// void doNothing(BuildContext context) {

//   }




