import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/screens/editProfile.dart';




class Donation extends StatefulWidget {
  const Donation({ Key? key }) : super(key: key);

  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {

  TextEditingController donationController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Donation",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),


      body: ListView(
        children: [
          Column(
            children: [

              SizedBox(height: 5.h,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildDonationFormField(),
              ),


              SizedBox(height: 5.h,),


              DefaultButton(
                width: 40.w, 
                height: 6.h, 
                text: "Donate", 
                press: () {})






            ],
          )
        ],
      ),


      
    );
  }
    TextFormField buildDonationFormField() {
    return TextFormField(
      controller: donationController,
      
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.number,
       
      decoration: InputDecoration(
        hintText: "Enter amount",
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
          svgIcon: "assets/icons/dollar.svg",
          
        ),
      ),
    );
  }
}