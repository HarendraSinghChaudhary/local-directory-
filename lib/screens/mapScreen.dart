import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';
import 'package:wemarkthespot/screens/explore.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({ Key? key }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

       appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Explore()));
                },
                child: SvgPicture.asset(
                  "assets/icons/explore.svg",
                  width: 26,
                  color: Colors.white,
                ),
              ),

              SizedBox(
                width: 6.h,
              ),

              //Image.asset("assets/images/logo_name.png"),

              Text(
                "WE MARK THE SPOT",
                style: TextStyle(
                    fontSize: 17.sp, color: Colors.white, fontFamily: "Roboto"),
              )
            ],
          ),

          actions: [

             Padding(
               padding: EdgeInsets.only(right: 3.w),
               child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FliterScreen()));
                  },
                  child: SvgPicture.asset(
                    "assets/icons/filter-list.svg",
                    width: 26,
                    color: Colors.white,
                  ),
                ),
             ),

          ],
        ),

        body: Container(
          
          height: double.infinity,
          width: double.infinity,

          decoration: BoxDecoration(
            //color: Colors.red,
            image: DecorationImage(
                    image: AssetImage("assets/images/mapping.png"), fit: BoxFit.fill),
          ),
        
          )
    );
        
      
    
  }
}