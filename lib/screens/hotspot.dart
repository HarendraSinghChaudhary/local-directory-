import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';

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
      body: ListView(
        shrinkWrap: true,
        controller: _controller,
        children: [

          Stack(
            children: [
                Column(
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
                  //controller: nameController,
                  // validator: (val) {
                  //   if (val == null || val.isEmpty) {
                  //     return 'Please Enter Your Name';
                  //   }

                  //   return null;
                  // },
                  onChanged: (val) {
                    //uptname = val;
                  },
                  //controller: uptname,
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
                      suffixIcon:
                          SearchPrefixIcon(svgIcon: "assets/icons/cross.svg"),
                      prefixIcon: Image.asset("assets/images/search.png")),
                ),
              ),
              SizedBox(
                height: 3.5.h,
              ),
              

              ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 14.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.w),
                          color: 
                          Color(0xFF7A7A7A)
                          ),
                      child: Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(bottom: 6.h, left: 2.w),
                            child: CircleAvatar(
                              radius: 7.w,
                              backgroundImage:
                                  AssetImage("assets/images/profilepic.jpeg"),
                            ),
                          ),

                          SizedBox(width: 2.w,),
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

                                      SizedBox(width: 12.w,),

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

                                SizedBox(height: 0.1.h,),

                                 


                                 Container(
                                   width: 74.w,
                                   child: Text(
                                     
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer",
                                        style: TextStyle(
                                          //overflow: TextOverflow.ellipsis,
                                            fontSize: 10.2.sp,
                                            color: Color(0xFFCECECE),
                                            fontFamily: 'Roboto'
                                            ),
                                      ),
                                 ),

                                 SizedBox(height: 1.h,),


                                  Container(
                                    width: 74.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 
                                 
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
                                        padding: EdgeInsets.only(right: 4.w),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "Reply",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontFamily: "Roboto"
                                                ),
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

                      SizedBox(height: 2.h,)




                      
                    ],
                  );
                },
              ),

              buildMessageFormField(),

             
            ],
          ),

          //  Positioned(
          //    //bottom: 0.0,
          //    child: Padding(
               
          //         padding: const EdgeInsets.all(4.0),
          //         child: buildMessageFormField(),
          //       ),
          //  )


            ],
          )
        
        ],
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
