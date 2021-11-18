import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';


class InTheKnow extends StatefulWidget {
  const InTheKnow({ Key? key }) : super(key: key);

  @override
  _InTheKnowState createState() => _InTheKnowState();
}

class _InTheKnowState extends State<InTheKnow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("In The Know"),
      ),

      body: Column(
        
        children: [

          SizedBox(height: 6.h,),
          Container(
            height: 24.h,
                width: double.infinity,
                color: Colors.grey,
            child: Stack(
              children: [
              //   Container(
              //   margin: EdgeInsets.symmetric(horizontal: 1.w),
                
              //   height: 20.h,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(3.w),
              //     color: Colors.white
              //   ),
                
              // ),

               Positioned(
                 top: 7.h,
                
                 child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  
                  height: 16.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.w),
                    color: Colors.red
                  ),
                  
                           ),
               ),


              Positioned(
                top: 20.h,
                child: SvgPicture.asset("assets/icons/heart1.svg"))
              ],
            ),
          )
        ],
      ),


      
    );
  }
}