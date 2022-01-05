import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;


class CheckIn extends StatefulWidget {
  const CheckIn({ Key? key }) : super(key: key);

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {


  List<UserCheckInList> userCheckInList = [];

  @override
  void initState() {

    checkInListApi();
    super.initState();
    
  }

  bool isloading = false;

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Check Ins",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),



       body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3.h,),
             ListView.builder(
                shrinkWrap: true,
                controller: _controller,
                itemCount: userCheckInList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 9.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              color: kBackgroundColor),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 0.h, left: 2.w),
                                child: CircleAvatar(
                                  radius: 6.w,
                                  backgroundImage: NetworkImage(
                                      userCheckInList[index].businessProfile!.image.toString(),),
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Container(
                                child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      
                                      width: 74.w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            //"Bar Name",

                                            userCheckInList[index].businessProfile!.name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: kCyanColor,
                                                fontFamily: "Segoepr"),
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
                                            "checked in",
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
                                            //"2 days ago",

                                            userCheckInList[index].timedelay.toString(),
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
      
    );
  }


    Future<dynamic> checkInListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

     var request = http.get(
        Uri.parse(

          RestDatasource.USERCHECKINLIST_URL +  id.toString()
          
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

          UserCheckInList modelAgentSearch = new UserCheckInList();


          // NearBy modelAgentSearch = new NearBy();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.created_at =
              jsonArray[i]["created_at"].toString();
          modelAgentSearch.business_id =
              jsonArray[i]["business_id"].toString();
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



              
              jsonErray = jsonRes['data'][i]['user'];
                UserCheckin modelcheckIn = new UserCheckin();

                modelcheckIn.id = jsonErray["id"].toString();
                modelcheckIn.name = jsonErray["name"].toString();
                modelcheckIn.image = jsonErray["image"].toString();


                print("name: aw  "+modelcheckIn.name.toString() );

                modelAgentSearch.businessProfile = modelcheckIn;



    


       

          userCheckInList.add(modelAgentSearch);

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
}



class UserCheckInList {
  UserCheckin? businessProfile ;
  var id = "";
  var created_at = "";
  var business_id = "";
  var timedelay = "Secconds";
  

}


class UserCheckin {
  var id = "";
  var name = "";
  var image = "";

}