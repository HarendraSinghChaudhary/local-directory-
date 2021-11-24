import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';



class ResetPassword extends StatefulWidget {
   String email;

  ResetPassword({required this.email});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isloading = false;

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  bool obscure = true;
  bool obscure1 = true;


  @override
  Widget build(BuildContext context) {

    print("email: "+widget.email.toString());
    return Scaffold(
      backgroundColor: Colors.black,

          body: SingleChildScrollView(
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            SizedBox(height: 20.h,),
            Center(child: Image.asset("assets/images/logo_name.png")),
            SizedBox(height: 10.h,),
             Text(
                "Reset Password",
                style: TextStyle(color: kCyanColor, fontSize: 18.5.sp,
                fontFamily: 'Segoepr'
                ),
              ),

              SizedBox(height: 2.h,),


              Text(
                "Create your new secured password",
                style: TextStyle(color: Color(0xFFCECECE), fontSize: 11.sp,
                fontFamily: 'Roboto'
                ),
              ),
          
             SizedBox(height: 5.h,),
          
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: buildPasswordFormField(),
             ),
          
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: buildConfirmPasswordFormField(),
             ),
          
             SizedBox(height: 3.h,),

              isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator())
                  :
          
          
               DefaultButton(
                    width: 40.w,
                    height: 6.h,
                    text: "Update",
                    
                    press: () {

                      var password = passwordController.text.toString().trim();
                      var confirmPassword = confirmPasswordController.text.toString().trim();


                       if (password.length > 7 && password.length < 25) {
                          print("password: " +password.toString());


                          if (password.toString() == confirmPassword.toString()) {
                            print("confirm password: " +confirmPassword.toString());

                            resetPasswordApi(widget.email.toString(), 
                            passwordController.text.toString().trim(), 
                            confirmPasswordController.text.toString().trim() );


                           
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password and confirm password must be same")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Password must be between 8 to 25 characters")));
                        }
                    }),
                  ],
                ),
          ),
      
    );
  }

   TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      style: TextStyle(color: Colors.white),
      obscureText: obscure,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: obscure
                  ? Icon(
                Icons.visibility_outlined,
                color: Colors.grey,
              )
                  : Icon(
                Icons.visibility_off_outlined,
                color: kPrimaryColor,
              ),
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              }),
        ),
      ),
    );
  }


    TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      obscureText: obscure1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: obscure1
                  ? Icon(
                Icons.visibility_outlined,
                color: Colors.grey,
              )
                  : Icon(
                Icons.visibility_off_outlined,
                color: kPrimaryColor,
              ),
              onPressed: () {
                setState(() {
                  obscure1 = !obscure1;
                });
              }),
        ),
      ),
    );
  }


    Future<dynamic> resetPasswordApi(String email, String newPassword, String confirmPassword) async {
    setState(() {
      isloading = true;
    });
    print(email);
   
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(

          RestDatasource.PASSWORDUPDATE_URL
         
        ),
        body: {
          "email": widget.email.toString().trim(),
          "newPassword": passwordController.text.toString().trim(),
          "confirmPassword": confirmPasswordController.text.toString().trim()
        

          
          
        });

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('id', jsonRes["data"]["id"].toString());
        // prefs.setString('email', jsonRes["data"]["email"].toString());
        // prefs.commit();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg,style: TextStyle(fontSize: 18),)));

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);

        setState(() {
          isloading = false;
        });
      }else{
        setState(() {
          isloading = false;
        });
            ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }



}