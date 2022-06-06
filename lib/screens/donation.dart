import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/editProfile.dart';
import 'package:wemarkthespot/screens/payment_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';

class Donation extends StatefulWidget {
  const Donation({Key? key}) : super(key: key);

  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  bool isloading = false;
  var id = "";

  TextEditingController donationController = new TextEditingController();
  ScrollController _controller = ScrollController();

  List <donationModel> donatioList = [];

  @override
  void initState() {
    // TODO: implement initState
    doantionApi();
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Donation",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildDonationFormField(),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: DefaultButton(
                    width: 40.w,
                    height: 6.h,
                    text: "Donate",
                    press: () {
                      if(int.parse(donationController.text.toString().trim())<=0){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid amount"),));
                        return false;
                      }
                      String msg = donationController.text.toString().trim();

                      if (msg.toString() != "") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentGateway(
                                    price: donationController.text
                                        .toString()
                                        .trim(),
                                    id: id.toString())));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter donation amount')));
                      }
                    }),
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Donation History ",
                      style: TextStyle(
                          fontSize: 14.5.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Segoepr"),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),

                    isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator())
                  :
                    ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: donatioList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int a = donatioList.length - index -1;
                        return Column(
                          children: [
                            Container(
                                height: 10.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    color: kBackgroundColor),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 0.h, left: 2.w),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 6.w,
                                        child: SvgPicture.asset("assets/icons/donation.svg", width: 30,),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 74.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Paid to We Mark The Spot",

                                                  // userCheckInList[index].businessProfile!.name.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: kCyanColor,
                                                      fontFamily: "Segoepr"),
                                                ),

                                                SizedBox(width: 12.w,),

                                                 Text(
                                                  r"$"+donatioList[a].plan_price.toString(),

                                                  // userCheckInList[index].businessProfile!.name.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: Colors.white,
                                                      fontFamily: "Segoepr",
                                                      fontWeight: FontWeight.w700),
                                                ),



                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.4.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Order Id: "+ donatioList[a].order_id.toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: kPrimaryColor,
                                                    fontFamily: "Roboto"),
                                              ),
                                              SizedBox(
                                                width: 1.2.w,
                                              ),
                                              Text(
                                                "|",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey,
                                                    fontFamily: "Roboto"),
                                              ),
                                              SizedBox(
                                                width: 1.2.w,
                                              ),
                                              Text(
                                                donatioList[a].timedelay.toString(),

                                                // userCheckInList[index].timedelay.toString(),
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Color(0XFF979797),
                                                  //fontWeight: FontWeight.w700
                                                  //fontFamily: "Segoepr"
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),

                                           Text(
                                                "Status: "+donatioList[a].payment_status.toString(),

                                                // userCheckInList[index].timedelay.toString(),
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Color(0XFF979797),
                                                  //fontWeight: FontWeight.w700
                                                  //fontFamily: "Segoepr"
                                                ),
                                              ),

                                                SizedBox(
                                            height: 1.h,
                                          ),


                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> doantionApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

     var request = http.get(
        Uri.parse(

          RestDatasource.DONATIONHISTORY_URl +  id.toString()
          
        ),
       );
    String msg = "";
    var jsonArray;
    var jsonRes;
    var jsonErray;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
     
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);
       final date2 = DateTime.now();

      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {

          donationModel modelAgentSearch = new donationModel();


          // NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.order_id = jsonArray[i]["order_id"].toString();
          modelAgentSearch.plan_price = jsonArray[i]["plan_price"].toString();
          modelAgentSearch.payment_status = jsonArray[i]["payment_status"].toString();

          modelAgentSearch.created_at =
              jsonArray[i]["created_at"].toString();
        
                 var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inSeconds;
          modelAgentSearch.timedelay = difference.toString()+" seconds ago";
          if(difference>60){
            var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inMinutes;
            modelAgentSearch.timedelay = difference.toString()+ " minutes ago";

            if(difference>60){
              var difference = date2.difference(DateTime.parse(modelAgentSearch.created_at)).inHours;
              modelAgentSearch.timedelay = difference.toString()+" hours ago";

              if(difference > 24){
                modelAgentSearch.timedelay = modelAgentSearch.created_at.toString().substring(0,10);
              }
            }
          }



          donatioList.add(modelAgentSearch);



              

          setState(() {});
        }

        setState(() {
          isloading = false;
        });
        //Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));
        // sliderBannerApi();
        //Navigator.pop(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Banners()));

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
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }


  TextFormField buildDonationFormField() {
    return TextFormField(
      controller: donationController,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter amount",
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
          svgIcon: "assets/icons/dollar.svg",
        ),
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id").toString();
    print("id Print: " + id.toString());
  }
}



class donationModel {
 
 var id = "";
 var order_id = "";
 var plan_price = "";
 var created_at = "";
 var timedelay = "Secconds";
 var payment_status = "";



}