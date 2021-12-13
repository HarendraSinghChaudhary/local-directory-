import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemarkthespot/screens/forgotPassword.dart';


class TextScreen extends StatefulWidget {
  const TextScreen({ Key? key }) : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {

  TextEditingController _TextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(child: buildEmailFormField() ),
      
    );
  }

   TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _TextController,
     
      style: TextStyle(color: Colors.black),
      minLines: 1,
      maxLines: 50,
      cursorColor: Colors.white,
      keyboardType: TextInputType.multiline,
      
      decoration: InputDecoration(
        hintText: "Enter your Email",
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
    );
  }
}