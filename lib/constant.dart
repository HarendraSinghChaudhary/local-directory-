import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


const kPrimaryColor = Color(0xFFD66821);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kIconColor = Color(0xFF7A7A7A);
const kBackgroundColor = Color(0xFF262626);
const kIconBackgroundColor = Color(0XFFAAAAAA);
const kokokColor = Color(0XFF62C15E);
const kNotCoolColor = Color(0XFF67EDFF);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kCyanColor = Color(0xFF1DC2C2);
const kThirdcolor = Colors.white;
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

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
   borderSide: BorderSide(color: kTextColor),
  );
}

// final headingStyle = TextStyle(
//   fontSize: getProportionateScreenWidth(28),
//   fontWeight: FontWeight.bold,
//   color: Colors.black,
//   height: 1.5,
// );

const defaultDuration = Duration(milliseconds: 250);

// // Form Error
// final RegExp emailValidatorRegExp =
//     RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
// const String kEmailNullError = "Please Enter your email";
// const String kInvalidEmailError = "Please Enter Valid Email";
// const String kPassNullError = "Please Enter your password";
// const String kShortPassError = "Password is too short";
// const String kMatchPassError = "Passwords don't match";
// const String kNamelNullError = "Please Enter your name";
// const String kPhoneNumberNullError = "Please Enter your phone number";
// const String kAddressNullError = "Please Enter your address";

// final otpInputDecoration = InputDecoration(
//   contentPadding:
//       EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
//   border: outlineInputBorder(),
//   focusedBorder: outlineInputBorder(),
//   enabledBorder: outlineInputBorder(),
// );

// OutlineInputBorder outlineInputBorder() {
//   return OutlineInputBorder(
//     borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
//     borderSide: BorderSide(color: kTextColor),
//   );
// }




Future<List<Asset>> pickImages() async {
  List<Asset> resultList = [];
  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 3,
      enableCamera: false,
      selectedAssets: resultList,
      materialOptions: MaterialOptions(
        actionBarTitle: "Select Image",
      ),
    );
   return resultList;
  } on Exception catch (e) {
    print(e);
    return resultList;
  }


}

Future<List<Asset>> pickImagesMultiple(int maxImage) async {
  List<Asset> resultList = [];
  print("maxImage "+maxImage.toString()+"");
  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: maxImage,
      enableCamera: false,
      selectedAssets: resultList,
      materialOptions: MaterialOptions(
        actionBarTitle: "Select Image",
      ),
    );
    return resultList;
  } on Exception catch (e) {
    print(e);
    return resultList;
  }


}