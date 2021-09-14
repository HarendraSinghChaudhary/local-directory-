// import 'package:feedme_user/Screens/Registration/NewUserRegister.dart';
// import 'package:feedme_user/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnBoardingPage extends StatefulWidget {
//   @override
//   _OnBoardingPageState createState() => _OnBoardingPageState();
// }

// class _OnBoardingPageState extends State<OnBoardingPage> {

//   final introKey = GlobalKey<IntroductionScreenState>();

//   Future<void> _onIntroEnd(context) async {
//     Route route = MaterialPageRoute(builder: (context) => UserLogin());
//     Navigator.pushAndRemoveUntil(context, route,(r) => false);
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setInt("isIntroEnd", 1);
//       prefs.commit();
//     });
//   }

//   Widget _buildImage(String assetName) {
//     return Align(
//       child: Image.asset(theme.imgPath + '$assetName.png', width: 300.0),
//       alignment: Alignment.bottomCenter,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFF6200));

//     const bodyStyle = TextStyle(fontSize: 19.0);
//     const pageDecoration = const PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
//       bodyTextStyle: bodyStyle,
//       descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//       pageColor: Colors.white,
//       imagePadding: EdgeInsets.zero,
//     );

//     return IntroductionScreen(

//       key: introKey,
//       pages: [
//         PageViewModel(
//           title: "Welcome to FeedMe",
//           body:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
//           image: _buildImage('img_one'),
//           decoration: pageDecoration,
//         ),
//         PageViewModel(
//           title: "Rescue food for everyone",
//           body:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
//           image: _buildImage('img_two'),
//           decoration: pageDecoration,
//         ),
//         PageViewModel(
//           title: "Enjoy affordable and tasty food",
//           body:
//           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
//           image: _buildImage('img_three'),
//           decoration: pageDecoration,
//         ),
//         // PageViewModel(
//         //   title: "Another title page",
//         //   body: "Another beautiful body text for this example onboarding",
//         //   image: _buildImage('img2'),
//         //   footer: RaisedButton(
//         //     onPressed: () {
//         //       introKey.currentState?.animateScroll(0);
//         //     },
//         //     child: const Text(
//         //       'FooButton',
//         //       style: TextStyle(color: Colors.white),
//         //     ),
//         //     color: Colors.lightBlue,
//         //     shape: RoundedRectangleBorder(
//         //       borderRadius: BorderRadius.circular(8.0),
//         //     ),
//         //   ),
//         //   decoration: pageDecoration,
//         // ),
//         // PageViewModel(
//         //   title: "Title of last page",
//         //   bodyWidget: Row(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: const [
//         //       Text("Click on ", style: bodyStyle),
//         //       Icon(Icons.edit),
//         //       Text(" to edit a post", style: bodyStyle),
//         //     ],
//         //   ),
//         //   image: _buildImage('img1'),
//         //   decoration: pageDecoration,
//         // ),
//       ],
//       onDone: () => _onIntroEnd(context),
//       //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
//       showSkipButton: true,
//       skipFlex: 0,
//       nextFlex: 0,
//       skip: const Text('Skip'),
//       // next: const Icon(Icons.arrow_forward),
//       done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
//       dotsDecorator: const DotsDecorator(
//         size: Size(10.0, 10.0),
//         color: Color(0xFFBDBDBD),
//         activeSize: Size(22.0, 10.0),
//         activeColor: Color(0xFFFF6200),
//         activeShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//         ),
//       ),
//     );
//   }
// }
