import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';




class MyHomePage extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expandable Demo"),
      ),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Card1(),
            Card2(),
            Card3(),
          ],
        ),
      ),
    );
  }
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "ExpandablePanel",
                     // style: Theme.of(context).textTheme.body2,
                    )),
                collapsed: Text(
                  loremIpsum,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var _ in Iterable.generate(5))
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            loremIpsum,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          )),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return  ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                          //margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 14.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              color: kBackgroundColor),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 6.h, left: 2.w),
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
                                            color: Color(0xFFCECECE),
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
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.w),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Text(
                                                "Reply",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontFamily: "Roboto"),
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
                          )),
                      
                      
                    ],
                  );
                },
              );
    }

    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    //style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 150);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                   // style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    "3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded2() {
      return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Container(
                //margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: double.infinity,
                height: 11.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.w),
                        topRight: Radius.circular(0.w)),
                    color: kBackgroundColor),
                child: Container(
                  //padding: EdgeInsets.only(left: 3.w),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h, left: 2.w),
                        child: CircleAvatar(
                          radius: 6.w,
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
                                    color: Color(0xFFCECECE),
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
                                  Text(
                                    "2m ago",
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 4.w),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "Reply",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                            fontFamily: "Roboto"),
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
                )),
            ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                   // margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: double.infinity,
                    height: 11.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.w),
                            topRight: Radius.circular(0.w)),
                        color: kBackgroundColor),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 8.w,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h, left: 0.w),
                            child: CircleAvatar(
                              radius: 4.w,
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
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.",
                                    style: TextStyle(
                                        //overflow: TextOverflow.ellipsis,
                                        fontSize: 8.5.sp,
                                        color: Color(0xFFCECECE),
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
                                      Text(
                                        "2m ago",
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 6.w),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "Reply",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                                fontFamily: "Roboto"),
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
                return   Container(
                //margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: double.infinity,
                height: 11.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.w),
                        topRight: Radius.circular(0.w)),
                    color: kBackgroundColor),
                child: Container(
                 
                  padding: EdgeInsets.only(
                    left: 16.w,
                  ),
                  child: Row(
                   
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 6.h, left: 0.w),
                          child: CircleAvatar(
                            radius: 4.w,
                            backgroundImage:
                                AssetImage("assets/images/loc.png"),
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w,),
                     
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
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: kCyanColor,
                                          fontFamily: "Segoepr"),
                                    ),
                                   
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 0.1.h,
                              ),
                              Padding(
                                padding:EdgeInsets.only(right:0.w),
                                child: Container(
                                  width: 70.w,
                                  child: Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                                    style: TextStyle(
                                        //overflow: TextOverflow.ellipsis,
                                        fontSize: 8.5.sp,
                                        color: Color(0xFFCECECE),
                                        fontFamily: 'Roboto'),
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "2m ago",
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Reply",
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                              fontFamily: "Roboto"),
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
                )
                );
              },
            ),
          
           
          ],
        );
      },
    );
    }

    buildExpanded3() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "",
            softWrap: true,
          ),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expandable(
              //   collapsed: buildCollapsed1(),
              //   expanded: buildExpanded1(),
              // ),
              Expandable(
                collapsed: buildCollapsed2(),
                expanded: buildExpanded2(),
              ),
              Expandable(
                collapsed: buildCollapsed3(),
                expanded: buildExpanded3(),
              ),
              Divider(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true)!;
                      return TextButton(
                        child: Text(
                          controller.expanded ? "Close" : "View Replies",
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in [1, 2, 3, 4]) buildItem("Item ${i}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Items",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}