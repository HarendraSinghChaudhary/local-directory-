import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/hotSpotReply.dart';

class Hotspot extends StatefulWidget {
  const Hotspot({Key? key}) : super(key: key);

  @override
  _HotspotState createState() => _HotspotState();
}

class _HotspotState extends State<Hotspot> {
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              "The Hotspot",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/icons/message.svg")),
          )
        ],
      ),
      body: Stack(
        
        children: [
          ListView(
            shrinkWrap: true,
            controller: _controller,
            children: [
              SizedBox(
                height: 2.5.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 7.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: Colors.white),
                child: TextFormField(
                
                  onChanged: (val) {
                  
                  },
                 
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                      suffixIcon: SearchPrefixIcon(
                          svgIcon: "assets/icons/cross.svg"),
                      prefixIcon: Image.asset("assets/images/search.png")),
                ),
              ),
              SizedBox(
                height: 3.5.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          color: kBackgroundColor,
                    
                          child: Column(
                            children: [
                              Row(
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
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {

                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HotSpotReply()));
                                                  
                                                },
                                                child: Text(
                                                  "View Replies",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.white,
                                                      fontFamily: "Roboto"),
                                                ),
                                              ),
                                                     Padding(
                                                       padding: EdgeInsets.only(right: 8.0),
                                                       child: SizedBox
                                                    (
                                                        width: 50.w,
                                                        child: TextField(
                                                          onChanged:(val){
                                                            print(val);
                                                          },
                                                        
                                                          minLines: 1,
                                                          keyboardType: TextInputType.multiline,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            
                                                            
                                                            
                                                              ),
                                                          maxLines: 50,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
                                                            
                                                            fillColor: Colors.black,
                                                            filled: true,
                                                        
                                                              
                                                              hintText: "Reply",
                                                              suffixIcon: SvgPicture.asset("assets/icons/send.svg", color: kPrimaryColor,width: 0.5.w, height: 2.h,),
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      9.sp,
                                                                  color: Colors
                                                                      .white)
                                                                      ),
                                                        ),
                                                    ),
                                                     )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: 2.h,),
                            ],
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      //replyWidget(controller: _controller),
                      
                    ],
                  );
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              
            ],
          ),
      
        //  buildInput()
      
          // Padding(
          //   padding: EdgeInsets.only(top: 75.h),
          //   child: buildMessageFormField(),
          // ),
      
      
          // buildMessageFormField()
      
         
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 6.w ),
        child: buildMessageFormField(),
      ),
    );
  }



    Widget buildInput() {
      return Container(

        height: 7.h,
        width: double.infinity,

        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(9.w)
        ),

        child: TextField(
               onSubmitted: (value) {},
               style: TextStyle(color: Colors.black, fontSize: 15.0),
               // controller: _textEditingController,
               decoration: InputDecoration(
                 border: InputBorder.none,
                 hintText: 'Type your message...',
                 hintStyle: TextStyle(color: Colors.grey),
                //  suffixIcon: Padding(
                //    padding: const EdgeInsets.only(right: 20),
                //    child: InkWell(
                //      onTap: () {},
                //      child: SvgPicture.asset(
                //                "assets/attachment.svg",
                //                width: 5,
                //                color: Colors.grey,

                //              ),
                //    ),
                //  ),
               ),
              // focusNode: focusNode,

             ),

        

      );
    }





  TextFormField buildMessageFormField() {
    return TextFormField(
      // controller: emailController,

      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,

      //inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
        fillColor: kPrimaryColor, filled: true,
        //filled: true,

        hintText: "Leave a message...",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 2.0,
          ),
        ),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

class replyWidget extends StatelessWidget {
  const replyWidget({
    Key? key,
    required ScrollController controller,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
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
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
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
                margin: EdgeInsets.symmetric(horizontal: 4.w),
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
}

class SearchSurffixIcon extends StatelessWidget {
  const SearchSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        20,
        20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 28,
        width: 12,
        color: kPrimaryColor,
      ),
    );
  }
}

class SearchPrefixIcon extends StatelessWidget {
  const SearchPrefixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        20,
        20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        color: kPrimaryColor,
        width: 20,
      ),
    );
  }
}
