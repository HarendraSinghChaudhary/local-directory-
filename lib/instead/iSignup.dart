import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/instead/iConstant.dart';
import 'package:wemarkthespot/instead/iDefaultButton.dart';
import 'package:wemarkthespot/instead/iLogin.dart';


class ISignUp extends StatefulWidget {
  const ISignUp({ Key? key }) : super(key: key);

  @override
  _ISignUpState createState() => _ISignUpState();
}

class _ISignUpState extends State<ISignUp> {

  bool obsecure = false;

   
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


            Text("Sign Up",
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



                  SizedBox(height: 2.h,),




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
                      obscureText: obsecure,
                      
                      
                      
                          
                          decoration: InputDecoration(
                             hintText: "Password",
                             hintStyle: TextStyle(color: Color(0XFFBDBDBD), fontSize: 14.sp),
                             border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                              
                              labelStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff000000)),

                                  suffixIcon: InkWell(
                                    onTap: () {

                                      setState(() {
                                        obsecure = true;
                                      });

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 2.h, right: 2.w),
                                      child:  obsecure ?   InkWell(
                                        onTap: () {
                                          setState(() {
                                            obsecure = false;
                                          });
                                        },
                                        child: Text("Show",
                                        style: TextStyle(
                                          color: iPrimaryColor.withOpacity(0.7),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold
                                        ),),
                                      )
                                      :

                                      Text("Hide",
                                      style: TextStyle(
                                        color: iPrimaryColor.withOpacity(0.7),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold
                                      ),)

                                      
                                    ),
                                  )
                                  ),
                                
                        ),
                  ),




                   SizedBox(height: 37.h,),



                   IDefaultButton(
                     width: 93.w, 
                     height: 6.5.h, 
                     text: "SIGN UP", 
                     press: () {}),




          



            SizedBox(height: 3.h,),


            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Ilogin()));
              }, 
              child: Text("You have an account. SIGN IN NOW",
                    style: TextStyle(
                      color: iPrimaryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold
              
                    ),
                    ),
            ),

                     

          ],
        ),
      ),


      
    );
  }
}