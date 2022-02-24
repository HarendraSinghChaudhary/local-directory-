import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({ Key? key }) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {

  bool isloading = false;




  bool obscure = false;
  bool obscure1 = false;
  bool obscure2 = false;

  TextEditingController oldPasswordController= new TextEditingController();
  TextEditingController newPasswordController= new TextEditingController();
  TextEditingController confirmPasswordController= new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Change Password",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3.h,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildOldPasswordFormField(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildNewPasswordFormField(),
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
              height: 7.h, 
              text: "Save", 
              press: () {

              var old = oldPasswordController.text.trim().toString();
              var newPass = newPasswordController.text.trim().toString();
              var confirm = confirmPasswordController.text.toString().trim();


              if (old.toString() != "" || old.toString() != "null") {


                if (newPass.toString() != "" || newPass.toString() != "null") {


                  if (newPass.length > 7 && newPass.length < 25) {

                    if (confirm.toString() != "" || confirm.toString() != "null") {

                      if (confirm.length > 7 && confirm.length < 25) {

                        if (newPass.toString() == confirm.toString()) {

                          changePassword(old.toString(), confirm.toString());
                          
                        } else {

                           ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "New password and confirm password must be same")));


                        }



                        
                      } else {

                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please enter 8 to 25 characters password")));


                      }




                      
                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter confirm password')));



                    }



                    
                  } else {


                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please enter 8 to 25 characters password")));



                  }







                  
                } else {

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter new password')));




                }


                
              } else {

                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter old password')));


              }








              })
          ],
        ),
      ),


      
    );
  }
   TextFormField buildOldPasswordFormField() {
    return TextFormField(
      controller: oldPasswordController,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please Enter Your Password';
        }
        if (val.length < 9 && val.length > 25) {
          return 'Password must be between 8 to 25 Characters';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: obscure,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Old Password",
        hintStyle: TextStyle(color: Colors.grey),
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

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       
      ),
    );
  }

   TextFormField buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please Enter Your Password';
        }
        if (val.length < 9 && val.length > 25) {
          return 'Password must be between 8 to 25 Characters';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: obscure1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.grey),
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

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       
      ),
    );
  }

   TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please Enter Your Password';
        }
        if (val.length < 9 && val.length > 25) {
          return 'Password must be between 8 to 25 Characters';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: obscure2,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Re-type New Password",
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
                                  icon: obscure2
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
                                      obscure2 = !obscure2;
                                    });
                                  }),
        ),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       
      ),
    );
  }


  Future<dynamic> changePassword(String old_password, String newPassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
       var id = prefs.getString("id");
       print("id Print: " +id.toString());
    setState(() {
      isloading = true;
    });
    print(id.toString);
    print(old_password);
    print(newPassword);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.CHANGEPASSWORD_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "user_id": id.toString(),
          "old_password": old_password.toString(),
          "password": newPassword.toString(),
        });

    await request.then((http.Response response) {
      res = response;
      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");

      if (jsonRes["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );

        // print('getotp1: ' + getotp.toString());
        Navigator.pop(context);

        setState(() {
          isloading = false;
        });
      }
      if (jsonRes["status"] == false) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );
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