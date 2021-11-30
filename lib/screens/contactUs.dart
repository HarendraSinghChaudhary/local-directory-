import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';


class ContactUs extends StatefulWidget {
  const ContactUs({ Key? key }) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String? code = "+91";

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
                  child: Expanded(
                    child: TextFormField(
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
                ),

                SizedBox(height: 3.h,),



                DefaultButton(
                  width: 40.w, 
                  height: 7.h, 
                  text: "Send", 
                  press: () {})


          ],
        )
        
      ),
      
    );
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