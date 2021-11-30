import 'package:flutter/material.dart';


const iPrimaryColor = Color(0xFF1B8035);
const iPrimaryLightColor = Color(0xFFFFECDF);
const iIconColor = Color(0xFF7A7A7A);
const iBackgroundColor = Color(0xFF262626);

const iPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const iSecondaryColor = Color(0xFF979797);
const iCyanColor = Color(0xFF1DC2C2);
const iThirdcolor = Colors.white;
const iTextColor = Color(0xFF757575);

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: iIconColor),
  );
}