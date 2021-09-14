import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({ Key? key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: 10.h,
              ),

             
              SizedBox(
                height: 6.h,
              ),
              Text(
                "Change Password",
                style: TextStyle(color: kCyanColor, fontSize: 20.sp),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Create your new secured password",
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              SizedBox(
                height: 7.h,
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPasswordFormField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildConfirmPasswordFormField(),
              ),



              
              SizedBox(
                height: 5.h,
              ),

              DefaultButton(
                  width: 50.w, height: 8.h, text: "Update", press: () {}),

              SizedBox(
                height: 6.h,
              ),

              
            ],
          ),
        ),
      ),
      
    );
  }
   TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        
      ),
    );
  }

   TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        
      ),
    );
  }
}