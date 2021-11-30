import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({ Key? key }) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
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

            DefaultButton(
              width: 40.w, 
              height: 7.h, 
              text: "Save", 
              press: () {})
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
}