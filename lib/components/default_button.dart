import 'package:flutter/material.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';



class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.width,
    required this.height,
     Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function() press;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: kPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
