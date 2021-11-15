import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/login_screen.dart';



class ResetPassword extends StatefulWidget {
  const ResetPassword({ Key? key }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password and confirm password must be same")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Password must be between 8 to 25 Charactors")));
                        }




                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginScreen()));
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
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }


    TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      obscureText: false,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        hintStyle: TextStyle(color: Colors.grey),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}