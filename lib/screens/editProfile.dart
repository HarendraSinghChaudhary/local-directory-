import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/account.dart';
import 'package:wemarkthespot/screens/forgotPassword.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController dOBController = new TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Profile",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20.h,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 15.w,
                          backgroundImage:
                              AssetImage("assets/images/profilepic.jpeg"),
                        ),
                        Positioned(
                          top: 12.h,
                          left: 12.w,
                          child: Container(
                            height: 4.h,
                            width: 4.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                                child: SvgPicture.asset(
                              "assets/icons/-camera.svg",
                              width: 5.w,
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

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


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildDOBFormField(),
            ),



            SizedBox(height: 3.5.h,),


            DefaultButton(
              width: 40.w, 
              height: 6.h, 
              text: "Save", 
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              })



            



          ],
        ),
      ),
    );
  }



  TextFormField builNameFormField() {
    return TextFormField(
      controller: nameController,
      
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
       inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
        hintText: "Elina Rosewelt",
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
        hintText: "elina@dmail.com",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,

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
      decoration: InputDecoration(
        hintText: "+01 9876543210",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        
      ),
    );
  }



  TextFormField buildDOBFormField() {
    return TextFormField(
      controller: dOBController,
      
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      //keyboardType: TextInputType.emailAddress,
       inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
      decoration: InputDecoration(
        hintText: "12/12/1998",
        hintStyle: TextStyle(color: Colors.white,
        fontStyle: FontStyle.normal
        ),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: 
        //  SvgPicture.asset("assets/icons/-calendar.svg",
        //                                          width: 3.5.w,
        //                                         ),
        
        CustommSurffixIcon(
          svgIcon: "assets/icons/-calendar.svg",
          
        ),
      ),
    );
  }
}

class CustommSurffixIcon extends StatelessWidget {
  const CustommSurffixIcon({
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
        height: 20,
        color: kPrimaryColor,
      ),
    );
  }
}
