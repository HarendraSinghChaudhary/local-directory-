import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/instead/iConstant.dart';
import 'package:wemarkthespot/instead/iDefaultButton.dart';


class IOtpVerification extends StatefulWidget {
  const IOtpVerification({ Key? key }) : super(key: key);

  @override
  _IOtpVerificationState createState() => _IOtpVerificationState();
}

class _IOtpVerificationState extends State<IOtpVerification> {


    String? otp;

  TextEditingController first = new TextEditingController();
  TextEditingController second = new TextEditingController();
  TextEditingController third = new TextEditingController();
  TextEditingController fourth = new TextEditingController();
  bool isloading = false;

  late FocusNode pin1FocusNode;
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void previousField(String value, FocusNode focusNode) {
    if (value.length == 0) {
      focusNode.requestFocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


       body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

             SizedBox(height: 12.h,),

            SvgPicture.asset("assets/instaAssets/intsandLogo.svg"),

            SizedBox(height: 6.h,),


            Text("OTP Verification",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold
            
                  ),
                  ),

                   SizedBox(height: 4.h,),




                Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
              controller: first,
              focusNode: pin1FocusNode,
              autofocus: true,
              obscureText: false,
              
              style: TextStyle(fontSize: 24, color: Colors.black),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                             color: Color(0XFFE8E8E8),
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Color(0XFFE8E8E8),
                          ),
                        ),
                      ),
              onChanged: (value) {
                nextField(value, pin2FocusNode);
                //previousField(value, pin2FocusNode);
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
                controller: second,
                focusNode: pin2FocusNode,
                obscureText: false,
                style: TextStyle(fontSize: 24, color: Colors.black),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(

                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              // color: ColorsFile.themecolor,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Color(0XFFE8E8E8),
                          ),
                        ),
                      ),
                onChanged: (value) {
                  nextField(value, pin3FocusNode);
                  previousField(value, pin2FocusNode);
                }),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
                controller: third,
                focusNode: pin3FocusNode,
                obscureText: false,
                style: TextStyle(fontSize: 24, color: Colors.black),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              // color: ColorsFile.themecolor,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Color(0XFFE8E8E8),
                          ),
                        ),
                      ),
                onChanged: (value) {
                  nextField(value, pin4FocusNode);
                  previousField(value, pin3FocusNode);
                }),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              maxLength: 1,
              controller: fourth,
              focusNode: pin4FocusNode,
              obscureText: false,
              style: TextStyle(fontSize: 24, color: Colors.black),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              // color: ColorsFile.themecolor,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Color(0XFFE8E8E8),
                          ),
                        ),
                      ),
              onChanged: (value) {
                if (value.length == 1) {
                  pin4FocusNode.unfocus();
                  // Then you need to check is the code is correct or not
                }
              },
            ),
          ),
        ]),
      ),



                  SizedBox(height: 3.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't get OTP yet click on ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          //fontWeight: FontWeight.bold
              
                        ),
                        ),

                        InkWell(
                          onTap: () {},
                          child: Text("RESEND OTP",
                          style: TextStyle(
                            color: iPrimaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold
                                      
                          ),
                          ),
                        ),
                    ],
                  ),








                   SizedBox(height: 4.h,),



                   IDefaultButton(
                     width: 93.w, 
                     height: 6.5.h, 
                     text: "CONFIRM", 
                     press: () {}),




            SizedBox(height: 3.h,),


            // InkWell(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => IForgotPassword()));
            //   }, 
            //   child: Text("Forgot Your Password?",
            //         style: TextStyle(
            //           color: iPrimaryColor.withOpacity(0.5),
            //           fontSize: 15.sp,
            //           fontWeight: FontWeight.bold
              
            //         ),
            //         ),
            // ),



            // SizedBox(height: 3.h,),


            // InkWell(
            //   onTap: () {}, 
            //   child: Text("Don't have an account? SIGNUP NOW",
            //         style: TextStyle(
            //           color: iPrimaryColor,
            //           fontSize: 15.sp,
            //           fontWeight: FontWeight.bold
              
            //         ),
            //         ),
            // ),

                     

          ],
        ),
      ),


      
    );
  }
}