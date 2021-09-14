import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/introduction_Screen.dart';
import 'package:wemarkthespot/screens/login_screen.dart';
import 'package:wemarkthespot/theme.dart';

void main() {
  runApp(WeMarkTheSpot());
}

class WeMarkTheSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'We Mark The Spot',
          theme: theme(),
          home:  IntdroductionScreen(),
        );
      },
    );
  }
}