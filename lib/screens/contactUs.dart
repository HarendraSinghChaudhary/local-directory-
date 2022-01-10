import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';


class ContactUs extends StatefulWidget {
  const ContactUs({ Key? key }) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String code = "+91";
  bool isloading = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Contact Us",
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
              child: builNameFormField(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildEmailFormField(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildPhoneFormField(),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 18.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5.w),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.8)

                      )),
                  child: TextFormField(
                    controller: commentController,
                    style: TextStyle(color: Color(0XFFCECECE)),
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontSize: 14.sp, color: Colors.white)),
                  ),
                ),

                SizedBox(height: 3.h,),


                isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator(color: kPrimaryColor,)
                          : CupertinoActivityIndicator())
                  :



                DefaultButton(
                  width: 40.w, 
                  height: 7.h, 
                  text: "Send", 
                  press: () {
                    if(nameController.text.toString()=="" || nameController.text.toString() == "null"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your name")));
                    } else if(emailController.text.toString()=="" || emailController.text.toString() == "null"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your email")));
                    }else if(phoneController.text.toString()=="" || phoneController.text.toString() == "null"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your Phone number")));
                    }else if(commentController.text.toString()=="" || commentController.text.toString() == "null"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your Query")));
                    }else{
                      if(EmailValidator.validate(emailController.text.toString())){
                        contactusApi(code.toString());
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter a valid email")));
                      }
                    }


                       
                 
                  })


          ],
        )
        
      ),
      
    );
  }

    Future<dynamic> contactusApi(
      [String? Codes = "+91"]
   ) async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
      print("code Print: " + code.toString());
    setState(() {
      isloading = true;
    });
    // print("username: " + username);
    // print("useremail: " + email);
    // print("userpassword: " + password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.CONTACTUS_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "user_id": id.toString(),
          "name": nameController.text.toString(),
          "email": emailController.text.toString(),
          "country_code": codes.toString(),
          "phone": phoneController.text.toString(),
          "comment": commentController.text.toString(),
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
      print("message: " + jsonRes["otp"].toString() + "_");

      if (jsonRes["status"] == true) {


        nameController.clear();
        emailController.clear();
        phoneController.clear();
        commentController.clear();
       

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"])),
        );

        // print('getotp1: ' + getotp.toString());
       

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




  TextFormField builNameFormField() {
    return TextFormField(
      controller: nameController,
      inputFormatters: [WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s"))],
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Name",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
     
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,
        disabledBorder: outlineInputBorder(),
        // border:outline  //OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
      ),
    );
  }


   TextFormField buildPhoneFormField() {
     return TextFormField(
       controller: phoneController,

       style: TextStyle(color: Colors.white),
       cursorColor: Colors.white,
       keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
       maxLength: 10,
       decoration: InputDecoration(
         hintText: "Phone Number",
         hintStyle: TextStyle(color: Colors.white),
         focusColor: Colors.white,
          prefixIcon: CountryCodePicker(

                            showFlag: true,

                           onChanged: (val){
                              code = val.toString();
                              print(val);
                           },

                           // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                           initialSelection: code.toString(),
                           // favorite: ['+91', 'FR'],
                           // optional. Shows only country name and flag
                          textStyle: TextStyle(color: Colors.white),
                           showCountryOnly: false,
                           // optional. Shows only country name and flag when popup is closed.
                           showOnlyCountryWhenClosed: false,
                           // optional. aligns the flag and the Text left
                           alignLeft: false,
                         ),

         // If  you are using latest version of flutter then lable text and hint text shown like this
         // if you r using flutter less then 1.20.* then maybe this is not working properly
         floatingLabelBehavior: FloatingLabelBehavior.always,
         fillColor: Colors.white,

       ),
     );
   }


}