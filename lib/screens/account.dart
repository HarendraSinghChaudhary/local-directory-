import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/donation.dart';
import 'package:wemarkthespot/screens/editProfile.dart';
import 'package:wemarkthespot/screens/login_screen.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var name, email, id, country_code, phone, dob, image;

  @override
  void initState() {
    getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              "Profile",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/icons/message.svg")),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.h, left: 5.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15.w,
                  backgroundImage: NetworkImage(image.toString()),
                ),

                SizedBox(
                  width: 5.w,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(
                      height: 0.8.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/mail1.svg",
                          width: 3.5.w,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          email.toString(),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12.sp,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.7.h,
                    ),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       "assets/icons/phone.svg",
                    //       width: 3.5.w,
                    //     ),
                    //     SizedBox(
                    //       width: 2.w,
                    //     ),
                    //     Text(
                    //       country_code.toString()+phone.toString(),
                    //       style: TextStyle(
                    //           color: Colors.white.withOpacity(0.8),
                    //           fontSize: 12.sp,
                    //           fontFamily: 'Roboto'),
                    //     ),
                    //   ],
                    // ),

                    // SizedBox(
                    //   height: 0.7.h,
                    // ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/-calendar.svg",
                          width: 3.5.w,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          dob == "null" ? "DD/MM/YYYY" : dob.toString(),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12.sp,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    )
                  ],
                )

                // Container(
                //   height: 10.h,
                //   width: 10.h,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.red,
                //     image: DecorationImage(
                //       image: AssetImage("assets/images/Profile1.png")
                //     )
                //   ),
                // )
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          DefaultButton(
              width: 42.w,
              height: 6.h,
              text: "Edit",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              id: id.toString(),
                              name: name.toString(),
                              email: email.toString(),
                              country_code: country_code.toString(),
                              phone: phone.toString(),
                              dob: dob.toString(),
                              image: image.toString(),
                            )));
              }),
          SizedBox(
            height: 3.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Inbox",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Reviews",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Check-ins",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change Password",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Close Friends",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Block Users",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Donation()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Donations",
                        style: TextStyle(
                            color: kCyanColor,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                            color: kCyanColor,
                            fontStyle: FontStyle.normal,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto'),
                      ),
                      SvgPicture.asset(
                        "assets/icons/-right.svg",
                        width: 2.5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                DefaultButton(
                    width: 45.w,
                    height: 6.5.h,
                    text: "Log out",
                    press: () async {
                      var pref = await SharedPreferences.getInstance();
                      pref.clear();
                      pref.commit();
                      Navigator.pushAndRemoveUntil(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    }),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    print("id: " + id.toString());
    email = pref.getString("email").toString();
    print("email: " + email.toString());
    name = pref.getString("name").toString();
    print("name: " + name.toString());
    country_code = pref.getString("country_code").toString();
    print("country_code: " + country_code.toString());
    phone = pref.getString("phone").toString();
    print("phone: " + phone.toString());
    dob = pref.getString("dob").toString();
    print("dob: " + dob.toString());
    image = pref.getString("image").toString();
    print("image: " + image.toString());

    setState(() {});
  }
}
