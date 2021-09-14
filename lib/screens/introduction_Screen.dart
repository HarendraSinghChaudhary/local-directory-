import 'package:flutter/material.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

class IntdroductionScreen extends StatefulWidget {
  const IntdroductionScreen({Key? key}) : super(key: key);

  @override
  _IntdroductionScreenState createState() => _IntdroductionScreenState();
}

class _IntdroductionScreenState extends State<IntdroductionScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "image": "assets/images/resimage.jpg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "image": "assets/images/resimage.jpg"
    },
    {
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "image": "assets/images/resimage.jpg"
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
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Skip",
                            textAlign: TextAlign.end,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 12.sp),
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
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
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
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem Ipsum",
                  style: TextStyle(fontSize: 20.sp, color: kCyanColor),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  text,
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
