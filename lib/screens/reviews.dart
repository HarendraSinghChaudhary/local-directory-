import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  TextEditingController reviewController = new TextEditingController();

  bool isloading = false;

  List<ReviewClass> reviewList = [];

  var editBox = "";

  var busId = "";
  var revId = "";

  @override
  void initState() {
    reviewListApi();
    editBox = reviewController.text;
    
    super.initState();
    
  }


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
              "Reviews",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: reviewList.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {

              

                return cardList(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Column cardList(int index) {
    return Column(
                children: [
                  Slidable(
                    key: ValueKey(reviewList[index]),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: ScrollMotion(),

                      // A pane can dismiss the Slidable.
                   /*   dismissible: DismissiblePane(onDismissed: () {
                        reviewList.removeAt(index);
                      }),*/

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          flex: 1,
                          onPressed: (_) => doNothing(index),
                          backgroundColor: kCyanColor,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 1,
                          // An action can be bigger than the others.

                         onPressed: (_) => deleteNothing(index),
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        Card(
                          color: kBackgroundColor,
                           margin: EdgeInsets.symmetric(horizontal: 4.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w)),
                          child: Container(
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
                                      backgroundImage: NetworkImage(reviewList[index].business_images.toString()
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 74.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                            busId=  reviewList[index].business_name.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: kCyanColor,
                                                    fontFamily: "Segoepr"),
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 3.w),
                                                child: Text(
                                                 reviewList[index].timedelay.toString(),
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.1.h,
                                        ),
                                        Container(
                                          width: 74.w,
                                          child: Text(
                                          reviewList[index].review.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                //overflow: TextOverflow.ellipsis,
                                                fontSize: 10.2.sp,
                                                color: Color(0xFFCECECE),
                                                fontFamily: 'Roboto'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                  //       SizedBox(
                  //   height: 1.h,
                  // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              );
  }

      Future<dynamic> editReviewApi(String reviews_id, String review) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    
    print("message Print: " + reviews_id.toString());
    print("message Print1: " + review.toString());

    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.EDITREVIEW_URL,
        ),
        body: {
         
          
          "reviews_id" : reviews_id.toString(),
          "review": review.toString()
         
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
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

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });
        reviewList.clear();
        reviewController.text = "";
        reviewListApi();
          Navigator.of(context, rootNavigator: true).pop();
        

       ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));

        // getHotspotApi();
        //Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));
        // sliderBannerApi();
        //Navigator.pop(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Banners()));


        setState(() {
          isloading = false;
        });

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


    Future<dynamic> deleteReviewApi( String business_id, String reviews_id) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("business_idPrint: " + business_id.toString());
    print("message Print: " + reviews_id.toString());

    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.REVIEWDELETE_URL,
        ),
        body: {
          "user_id": id.toString(),
          "business_id": business_id.toString(),
          "reviews_id" : reviews_id.toString()
         
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
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

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });

         reviewList.clear();

        reviewListApi();

        Navigator.of(context, rootNavigator: true).pop();
        
        

       ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));

     

        setState(() {
          isloading = false;
        });

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



      Future<dynamic> reviewListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

     var request = http.post(
        Uri.parse(RestDatasource.GETREVIEW_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "user_id": id.toString(),
         
          
        });
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

          ReviewClass modelAgentSearch = new ReviewClass();


          
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.business_name = jsonArray[i]["business_name"].toString();
          modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
          modelAgentSearch.status = jsonArray[i]["status"].toString();
          modelAgentSearch.business_id = jsonArray[i]["business_id"].toString();
          modelAgentSearch.business_reviews_id = jsonArray[i]["business_reviews_id"].toString();
          modelAgentSearch.review = jsonArray[i]["review"].toString();
          modelAgentSearch.business_review_image = jsonArray[i]["business_review_image"].toString();
          modelAgentSearch.business_images = jsonArray[i]["business_images"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();

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
        

         


              
           



    

          editBox = jsonArray[i]["review"].toString();
          print("editBox: "+ editBox.toString());
       

          reviewList.add(modelAgentSearch);
          

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

  customDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
      builder: (context, setState) {
        return  AlertDialog(
          backgroundColor: Colors.black,
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
           title:  isloading == true
              ? Column(
                children: [
                  Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator()),
                  Text("Please wait....", style: TextStyle(fontSize: 20, color: Colors.white),)
                ],
              )
              :
          SingleChildScrollView(
              child: SizedBox(
            height: 24.h,
            width: 95.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        color: Colors.white,
                        width: 4.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
           
                
                Container(
                  height: 12.h,
                  width: 85.w,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3.w)),
                  child: TextFormField(
                    controller: reviewController,
                    style: TextStyle(color: Color(0XFFCECECE)),
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Type a Review...",
                        hintStyle: TextStyle(
                            fontSize: 12.sp, color: Color(0XFFCECECE))),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),

                 isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator())
                  :
                DefaultButton(
                    width: 35.w, height: 6.h, text: "Submit", press: () {

                      editReviewApi(reviewList[index].business_reviews_id.toString(), reviewController.text.toString());

                      

                      
                    

                    })
              ],
            ),
          )),
        );
      }
        );
        
        
        
       
      },
    );
  }

  customDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          title: SingleChildScrollView(
              child: SizedBox(
            height: 20.h,
            width: 95.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        color: Colors.white,
                        width: 4.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Are you sure you\n"
                  "want to delete this review",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                     InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(9.w),
                            border: Border.all(
                              color: kPrimaryColor
                            )
                            ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 12.sp, color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),

                    




                  isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator())
                  :
                    InkWell(
                      onTap: () {
                        deleteReviewApi(reviewList[index].business_id.toString(), reviewList[index].business_reviews_id.toString());
                          
                      },
                      child: Container(
                        height: 5.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(9.w)),
                        child: Center(
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          )),
        );
      }
        ); 
        
        
        
      },
    );
  }

  doNothing(int index) {
    customDialog(index);
  }

 deleteNothing(int index) {
    customDeleteDialog(index);
  }
}

class ReviewClass {
  var id = "";
  var business_name = "";
  var business_images = "";
  var ratting = "";
  var status = "";
  var business_id = "";
  var business_reviews_id = "";
  var review = "";
  var business_review_image = "";
  var created_at = "";
  var timedelay = "Secconds";

}




