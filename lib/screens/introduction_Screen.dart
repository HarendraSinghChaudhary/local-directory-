import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

class IntdroductionScreen extends StatefulWidget {
  const IntdroductionScreen({Key? key}) : super(key: key);

  @override
  _InteroductionScreenState createState() => _InteroductionScreenState();
}

class _InteroductionScreenState extends State<IntdroductionScreen> {
  int currentPage = 0;
  String btntext = "Skip";
  List<Map<String, String>> splashData = [
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/intro1.png"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/intro2.png"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada.",
      "image": "assets/images/intro3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                    if(currentPage<2){
                      btntext = "Skip";
                    }else{
                      btntext = "Done";
                    }
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"].toString(),
                  text: splashData[index]['text'].toString(),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 125),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashData.length,
                              (index) => buildDot(index: index),
                            ),
                          ),
                        ),
                        
                        InkWell(
                          onTap: () async{
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setBool('isFirstTimeLaunch', false);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            btntext,
                            textAlign: TextAlign.end,
                            style:
                                TextStyle(color: kPrimaryColor, 
                                fontSize: 12.sp,
                                fontFamily: 'Roboto'
                                ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 3),
                      blurRadius: 10,
                      spreadRadius: 1)
                ],
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),

                //     child: FadeInImage(placeholder: AssetImage("assets/images/resimage.jpg"), 
                // image: AssetImage(image),
                // fit: BoxFit.fill,
                // ),


          ),
        ),
        // SizedBox(
        //   height: 2.h,
        // ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem Ipsum",
                  style: TextStyle(fontSize: 22.sp, color: kCyanColor,
                  fontFamily: 'Segoepr'
                  
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Roboto',
                    color: Colors.white.withOpacity(0.7)
                  
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
