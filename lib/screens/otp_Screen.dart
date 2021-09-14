import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/change_password.dart';
import '../constant.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({ Key? key }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
   
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

               SizedBox(
                height: 12.h,
              ),
              Text(
                "OTP Verification",
                style: TextStyle(color: kCyanColor, fontSize: 20.sp),
              ),

              SizedBox(height: 2.h,),


              Text(
                "Please enter OTP to reset your password",
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),

              SizedBox(height: 10.h,),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    autofocus: true,
                    obscureText: false,
                    style: TextStyle(fontSize: 24,
                    color: Colors.white),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      nextField(value, pin2FocusNode);
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    focusNode: pin2FocusNode,
                    obscureText: false,
                    style: TextStyle(fontSize: 24,
                    color: Colors.white),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin3FocusNode),
                  ),
                ),
                SizedBox(
                  width: 60,
                  
                  child: TextFormField(
                    focusNode: pin3FocusNode,
                    obscureText: false,
                    style: TextStyle(fontSize: 24,
                    color: Colors.white),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin4FocusNode),
                  ),
                ),
                

             

               
                SizedBox(
                  width: 60,
                  
                  child: TextFormField(
                    focusNode: pin4FocusNode,
                    obscureText: false,
                    style: TextStyle(fontSize: 24,
                    color: Colors.white),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        pin4FocusNode.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                    },
                  ),
                ),
            ]
        ),
              ),


              SizedBox(height: 5.h,),

              InkWell(
                onTap: () {},
                child: Text("Resend OTP",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 12.sp
                ),
                ),
              ),


              SizedBox(height: 7.h,),

              DefaultButton(
                width: 45.w, 
                height: 8.h,
                text: "Continue",
                
                
                press: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                })


            ]
      )
        )
        )
    );
  }
}