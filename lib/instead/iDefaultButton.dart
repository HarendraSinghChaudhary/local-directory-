import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/instead/iConstant.dart';



class IDefaultButton extends StatelessWidget {
  const IDefaultButton({
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
        color: iPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            //fontFamily: 'Roboto'
            

            

          ),
        ),
      ),
    );
  }
}