import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/instead/iConstant.dart';
import 'package:wemarkthespot/instead/iDefaultButton.dart';
import 'package:wemarkthespot/instead/iOtpVerification.dart';



class IForgotPassword extends StatefulWidget {
  const IForgotPassword({ Key? key }) : super(key: key);

  @override
  _IForgotPasswordState createState() => _IForgotPasswordState();
}

class _IForgotPasswordState extends State<IForgotPassword> {
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




                  Container(
                    height: 7.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Color(0XFFF6F6F6),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: Color(0XFFE8E8E8)
                      )

                    
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      
                      
                          
                          decoration: InputDecoration(
                             hintText: "Phone Number",
                             hintStyle: TextStyle(color: Color(0XFFBDBDBD), fontSize: 14.sp),
                             border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                              
                              labelStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff000000))),
                        ),
                  ),



                  SizedBox(height: 3.h,),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Don't get OTP yet click on ",
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 13.sp,
                  //         //fontWeight: FontWeight.bold
              
                  //       ),
                  //       ),

                  //       InkWell(
                  //         onTap: () {},
                  //         child: Text("RESEND OTP",
                  //         style: TextStyle(
                  //           color: iPrimaryColor,
                  //           fontSize: 13.sp,
                  //           fontWeight: FontWeight.bold
                                      
                  //         ),
                  //         ),
                  //       ),
                  //   ],
                  // ),








                   SizedBox(height: 4.h,),



                   IDefaultButton(
                     width: 93.w, 
                     height: 6.5.h, 
                     text: "GET OTP", 
                     press: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => IOtpVerification()));
                     }),




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