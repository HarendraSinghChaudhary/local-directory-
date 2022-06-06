import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/screens/editProfile.dart';
import 'package:wemarkthespot/services/api_client.dart';

import '../main.dart';


class LocationSelector extends StatefulWidget {
  const LocationSelector({ Key? key }) : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  var description = "";
  bool isloading = false;

  TextEditingController donationController = new TextEditingController();
  var key = 'AIzaSyDyEVBI6DMAPZH5y4x6sxX1-DNOzXRMbcs';
  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace  = GooglePlace('AIzaSyDyEVBI6DMAPZH5y4x6sxX1-DNOzXRMbcs');

  @override
  void initState() {
    super.initState();

  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Select Location",
              style:
              TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildDonationFormField(),
          ),
          /*SizedBox(
            height: 5.h,
          ),
          Center(
            child: DefaultButton(
                width: 40.w,
                height: 6.h,
                text: "Search",
                press: () {

                }),
          ),*/
          SizedBox(
            height: 4.h,
          ),

          isloading==true?Center(child: Platform.isIOS?CupertinoActivityIndicator(color: Colors.white,):CircularProgressIndicator(color: Colors.white,),):Container(
            height: 200.h,
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(predictions[index].description.toString(), style: TextStyle(color: Colors.white),),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    debugPrint(predictions[index].placeId);
                    homeApi(predictions[index].placeId);


                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DetailsPage(
                    //       placeId: predictions[index].placeId,
                    //       googlePlace: googlePlace,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
  TextFormField buildDonationFormField() {
    return TextFormField(
      controller: donationController,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Search place",
        hintStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
        focusColor: Colors.white,

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        suffixIcon:
        //  SvgPicture.asset("assets/icons/-calendar.svg",
        //                                          width: 3.5.w,
        //                                         ),

        CustommSurffixIcon(
          svgIcon: "assets/icons/location-.svg",
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          autoCompleteSearch(value);
        } else {
          if (predictions.length > 0 && mounted) {
            setState(() {
              predictions = [];
            });
          }
        }
      },
    );
  }

  Future<dynamic> homeApi(var id) async {


    print("id Print: " + id.toString());

    if(mounted) {
      setState(() {
        isloading = true;
      });
    }

    var request = http.get(
        Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Cformatted_phone_number%2Cgeometry&place_id=$id&key=$key"),);

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["result"]["geometry"]["location"].toString());
        lat  = jsonRes["result"]["geometry"]["location"]["lat"].toString();
        long  = jsonRes["result"]["geometry"]["location"]["lng"].toString();
        if(lat!=null || lat.toString()!="null" || lat.toString().trim()!=""){
          updateLocation();
        }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }




  Future<dynamic> updateLocation() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("id lat: " + lat.toString());
    print("id long: " + long.toString());
    print("fcm token: " + fcm_token.toString());

    if(mounted) {
      setState(() {
        isloading = true;
      });
    }

    var request = http.post(
        Uri.parse(
          RestDatasource.HOMEAPI_URL,
        ),
        body: {
          "id": id.toString(),
          "lat":  lat.toString(),//"26.8546714985159",
          "long":long.toString(),//"75.76675952576491"
          "fcm_token":fcm_token.toString(),//"75.76675952576491"
        });

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {

        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Location Updated")));
        Navigator.of(context).pop();

      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonRes["message"].toString())));
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
   
}
