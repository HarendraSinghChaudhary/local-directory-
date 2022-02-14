import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/account.dart';
import 'package:wemarkthespot/screens/forgotPassword.dart';
import 'package:wemarkthespot/services/api_client.dart';

class EditProfile extends StatefulWidget {
  String id;
  String name;
  String email;
  String country_code;
  String phone;
  String dob;
  String image;

  EditProfile(
      {required this.id,
      required this.name,
      required this.email,
      required this.country_code,
      required this.phone,
      required this.dob,
      required this.image});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? uptoname;
  String? uptoemail;
  String? uptoPhone;
  String? uptoDob;


  String? code = "+91";
  bool isloading = false;
  String image = "";
  String base64Image = "";
  String fileName = "";
  File? file;
  bool isLoading = false;
  final picker = ImagePicker();
  get kPrimaryColor => null;

  final formkey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController dOBController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
    phoneController.text = widget.phone=='null'?"Phone no.":widget.phone;
    dOBController.text = widget.dob == 'null' ? '' : widget.dob;
    code = widget.country_code=="null"?"+91":widget.country_code;
  }

  String? dob;
  @override
  Widget build(BuildContext context) {
    print(dOBController.text.runtimeType);
    print("name1: " + widget.name.toString());
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Edit Profile",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20.h,
                    child: Stack(
                      children: [
                        file == null
                            ? CircleAvatar(
                                radius: 15.w,
                                backgroundImage:
                                    NetworkImage(widget.image.toString()),
                              )
                            : CircleAvatar(
                                radius: 15.w,
                                backgroundImage: FileImage(File(file!.path)),
                              ),
                        Positioned(
                          top: 12.h,
                          left: 12.w,
                          child: InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              height: 4.h,
                              width: 4.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                "assets/icons/-camera.svg",
                                width: 5.w,
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: builNameFormField(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: buildEmailFormField(),
            ),
             Padding(
               padding: EdgeInsets.all(8.0),
               child: buildPhoneFormField(),
             ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    var picked = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );
                    picked.then((value) {
                      // print(value!.day.toString().padLeft(2, '0'));
                      // print(value.month.toString().padLeft(2, '0'));
                      setState(() {
                        dob = value!.day.toString().padLeft(2, '0') +
                            '/' +
                            value.month.toString().padLeft(2, '0') +
                            '/' +
                            value.year.toString();
                        print(dob);
                        dOBController.text = dob!;
                      });
                    });
                  },
                  child: buildDOBFormField()),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            isloading
                ? Align(
                    alignment: Alignment.center,
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator())
                : DefaultButton(
                    width: 40.w,
                    height: 6.h,
                    text: "Save",
                    press: () {
                      uptoname = nameController.text.toString();
                      if (uptoname == null) {
                        uptoname = widget.name.toString();
                      }
                      print("name: " + uptoname.toString());

                      uptoemail = emailController.text.toString();

                      if (uptoemail == null) {
                        uptoemail = widget.email.toString();
                      }
                      print("email : " + uptoemail.toString());

                      uptoPhone = phoneController.text.toString();

                      if (uptoPhone == null) {
                        uptoPhone = phoneController.text.toString();
                        print(
                            "phone Number: " + phoneController.text.toString());
                      }

                      uptoDob = dOBController.text.toString();

                      if (uptoDob == null) {
                        uptoDob = phoneController.text.toString();
                        print("dob: " + dOBController.text.toString());
                      }

                      uploadData(
                          uptoname.toString(),
                          widget.email.toString(),
                          uptoPhone.toString(),
                          uptoDob.toString(),
                          code.toString());

                    })
          ],
        ),
      ),
    );
  }

  TextFormField builNameFormField() {
    return TextFormField(
      controller: nameController,
      maxLength: 30,
      maxLines: 1,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))],
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Name",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      enabled: false,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
      decoration: InputDecoration(
        hintText: "",
        hintStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,
        disabledBorder: outlineInputBorder(),
        // border:outline  //OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
      ),
    );
  }


   TextFormField buildPhoneFormField() {
     return TextFormField(
       controller: phoneController,

       style: TextStyle(color: Colors.white),
       cursorColor: Colors.white,
       keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
       maxLength: 10,
       decoration: InputDecoration(
         hintText: "Phone no.",
         hintStyle: TextStyle(color: Colors.white),
         focusColor: Colors.white,
          prefixIcon: CountryCodePicker(

                            showFlag: true,

                           onChanged: (val){
                              code = val.toString();
                              print(val);
                           },

                           // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                           initialSelection: code.toString(),
                           // favorite: ['+91', 'FR'],
                           // optional. Shows only country name and flag
                          textStyle: TextStyle(color: Colors.white),
                           showCountryOnly: false,
                           // optional. Shows only country name and flag when popup is closed.
                           showOnlyCountryWhenClosed: false,
                           // optional. aligns the flag and the Text left
                           alignLeft: false,
                         ),

         // If  you are using latest version of flutter then lable text and hint text shown like this
         // if you r using flutter less then 1.20.* then maybe this is not working properly
         floatingLabelBehavior: FloatingLabelBehavior.always,
         fillColor: Colors.white,

       ),
     );
   }

  TextFormField buildDOBFormField() {
    return TextFormField(
      controller: dOBController,

      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      enabled: false,
      //keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
      decoration: InputDecoration(
        disabledBorder: outlineInputBorder(),
        hintText: "DD/MM/YYYY",
        hintStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon: CustommSurffixIcon(
          svgIcon: "assets/icons/-calendar.svg",
        ),
      ),
    );
  }

  Future<dynamic> uploadData(
    String name,
    String email,
    String phone,
    String dob,
    String country_code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    print("title " + name.toString() + "");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.EDITPROFILE_URL,
      ),
    );
    if (name.toString() != "null" || name.toString() != "") {
      request.fields["name"] = name.toString();
      print("name: " + name.toString());
    }

    if (email.toString() != "null" || email.toString() != "") {
      request.fields["email"] = widget.email.toString();
      print("email: " + email.toString());
    }

    if (phone.toString() != "null" || phone.toString() != "") {
      request.fields["phone"] = phone.toString();
      print("phone: " + phone.toString());
    }

    if (dob.toString() != "dob" || phone.toString() != "") {
      request.fields["dob"] = dob.toString();
      print("dob: " + dob.toString());
    }

    if (country_code.toString() != "null" || country_code.toString() != "") {
      request.fields["country_code"] = country_code.toString();
      print("country_code: " + country_code.toString());
    }

    request.fields["id"] = id.toString();
    //request.files.add(await http.MultipartFile.fromPath(base64Image, fileName));
    if (file != null) {
      request.files.add(http.MultipartFile(
          'image',
          File(file!.path).readAsBytes().asStream(),
          File(file!.path).lengthSync(),
          filename: fileName));
      print("image: " + fileName.toString());
    }
    var jsonRes;
    var res = await request.send();
    // print("ResponseJSON: " + respone.toString() + "_");
    // print("status: " + jsonRes["success"].toString() + "_");
    // print("message: " + jsonRes["message"].toString() + "_");

    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.setString('name', jsonRes["data"]["name"].toString());
        prefs.setString(
            'country_code', jsonRes["data"]["country_code"].toString());
        prefs.setString('phone', jsonRes["data"]["phone"].toString());
        prefs.setString('dob', jsonRes["data"]["dob"].toString());
        prefs.setString('image', jsonRes["data"]["image"].toString());
        prefs.commit();
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        Navigator.of(context).pop();
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
    }

    fileName = file!.path.split("/").last;
    print("ImageName: " + fileName.toString() + "_");
    print("Image: " + base64Image.toString() + "_");
    setState(() {});
  }
}

class CustommSurffixIcon extends StatelessWidget {
  const CustommSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        20,
        20,
        20,
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: 20,
        color: kPrimaryColor,
      ),
    );
  }
}
