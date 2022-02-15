import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wemarkthespot/screens/testing.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/services/api_client.dart';
import 'package:path/path.dart' as path;

import '../main.dart';

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
  var ivStatus = "";
  var check = "";
  String image = "";
  String base64Image = "";
  String fileName = "";
  String trimFileName = "";
  File? file;
  File? trimFile;
  bool isLoading = false;
  final picker = ImagePicker();
  bool isVisible = false;
  List<Asset> images = [];
  List<File> fileList = [];
  var image_video_status = "0";

  var busId = "";
  var revId = "";

  double ratting = 0.0;
  double rattingcheckin = 0.0;

  TextEditingController reviewController2 = new TextEditingController();
  @override
  void initState() {
    reviewListApi();
    reviewController.text = editBox;
    
    super.initState();
    
  }


  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {

    print("object: "+editBox.toString());

   

   
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
            isLoading==true?Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Center(child: CircularProgressIndicator(),),
            ):ListView.builder(
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
                                    child: reviewList[index].business_images.toString()!="null"?CircleAvatar(
                                      radius: 6.w,
                                      backgroundImage: NetworkImage(reviewList[index].business_images.toString()
                                            ),
                                    )
                                        :CircleAvatar(
                                      radius: 6.w,
                                      backgroundImage: AssetImage("assets/images/resimage.jpg"
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Container(
                                    width: 55.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:50.w,
                                          child: Text(
                                            busId=  reviewList[index].business_name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: kCyanColor,
                                                fontFamily: "Segoepr"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0.1.h,
                                        ),
                                        Container(
                                          width: 45.w,
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
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          reviewList[index].timedelay.toString(),
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 1.h,),
                                        reviewList[index].assets.toString()!=""?
                                        SvgPicture.asset(reviewList[index].assets.toString(),
                                            color: reviewList[index].assetscolor, width: reviewList[index].assetswidth,):
                                        Container(height: 25, width: 10,)
                                      ],
                                    ),
                                  ),
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

Future<dynamic> editReviewApi(String reviews_id, String review, int index) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    
    print("message Print: " + reviews_id.toString());
    print("message Print1: " + review.toString());
    print("ratting Print1: " + ratting.toString());

    Navigator.of(context, rootNavigator: true).pop();

    setState(() {
      isloading = true;
    });
    customDialogReview(index);

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.EDITREVIEW_URL,
      ),
    );
    if (ratting.toString() != "null" || ratting.toString() != "") {
      request.fields["ratting"] =  ratting.toString() ;
      print("ratting1: " + ratting.toString());
    }

    if (review.toString() != "null" || review.toString() != "") {
      request.fields["review"] = review;
      print("review1: " + review.toString());
    }

    if(check.toString() != "null" || check.toString() != "") {
      request.fields["tag"] = check.toString();
      print("check: " + check.toString());
    }
    request.fields["reviews_id"] = reviews_id;
    request.fields["user_id"] = id.toString();
    print("ImageVideoStatus Print1: " + image_video_status.toString());
    if(image_video_status!="") {
      request.fields["image_video_status"] = image_video_status.toString();
      print("ImageVideoStatus " + image_video_status.toString() + "^^");
      if (image_video_status.toString() == "1") {
        if (fileList != null) {
          fileList.forEach((element) async {
            request.files
                .add(
                await http.MultipartFile.fromPath("image[]", element.path));
          });
        }
      } else if (image_video_status.toString() == "2") {
        if (file != null) {
          request.files
              .add(await http.MultipartFile.fromPath("image[]", file!.path));
        }
      }
    }

    var jsonRes;
    var res = await request.send();


    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);
      fileList.clear();
      images.clear();
      image_video_status = "0";
      file = null;
      fileName = "";
      reviewController.text = "";

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });
        reviewList.clear();
        Navigator.of(context, rootNavigator: true).pop();

        reviewListApi();


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
      fileList.clear();
      images.clear();
      image_video_status = "0";
      file = null;
      fileName = "";
      reviewController.text = "";

      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
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
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }




Future<dynamic> reviewListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isLoading = true;
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
          modelAgentSearch.image_video_status = jsonArray[i]["image_video_status"].toString();
          modelAgentSearch.review = jsonArray[i]["review"].toString();
          modelAgentSearch.tag = jsonArray[i]["tag"].toString();

          if(modelAgentSearch.tag=="fire"){
            modelAgentSearch.assets = "assets/icons/file.svg";
            modelAgentSearch.assetscolor = kPrimaryColor;
            modelAgentSearch.assetswidth = 5.w;
          }else if(modelAgentSearch.tag == "OkOk"){
            modelAgentSearch.assets = "assets/icons/bakance.svg";
            modelAgentSearch.assetscolor = kokokColor;
            modelAgentSearch.assetswidth = 10.w;


          }else if(modelAgentSearch.tag == "Not Cool"){
            modelAgentSearch.assets = "assets/icons/snow.svg";
            modelAgentSearch.assetscolor = kNotCoolColor;
            modelAgentSearch.assetswidth= 8.w;


          }else{
            modelAgentSearch.assets = "";
          }
          modelAgentSearch.reviewType = jsonArray[i]["type"].toString();
          modelAgentSearch.business_review_image = jsonArray[i]["business_review_image"];
       /*   if(jsonArray[i]["business_review_image"].length>0){
            var jsonArrayy = jsonArray[i]["business_review_image"];
            for (var j=0; j<jsonArrayy.length; j++){
              modelAgentSearch.business_review_image.clear();
              if(jsonArrayy[j].toString().trim()!=""){
              modelAgentSearch.business_review_image.add(jsonArrayy[j].toString().trim());
              }
            }
          }*/
          modelAgentSearch.business_images = jsonArray[i]["business_images"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
          print("Created At "+modelAgentSearch.created_at+"^");
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
          print("editBox  : "+ editBox.toString());
       

          reviewList.add(modelAgentSearch);
          

        }
        print("FileLength "+fileList.length.toString());

        setState(() {
          isLoading = false;
        });
        //Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));
        // sliderBannerApi();
        //Navigator.pop(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Banners()));

      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> deleteImageApi( int index, String review_id, String image) async {

    var request = http.post(
        Uri.parse(
          RestDatasource.DELETE_IMAGE,
        ),
        body: {
          "review_id": review_id.toString(),
          "image": image.toString()

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

/*
  customDialog(int index) {
    reviewController.text =  reviewList[index].review.toString();
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
*/

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    print("FileLocalPath "+file.path.toString()+"^^");

// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }
  Future <File?> createFileList(int index) async {
    if(reviewList[index].business_review_image.length>0){
      reviewList[index].business_review_image.forEach((element) async {

        try {
          /*  print(element.toString());
          // Uri string

          // Don't pass uri parameter using [Uri] object via uri.toString().
          // Because uri.toString() changes the string to lowercase which causes this package to misbehave

          // If you are using uni_links package for deep linking purpose.
          // Pass the uri string using getInitialLink() or linkStream

          File file = await urlToFile(element);
          fileList.add(file);*/
          var rng = new Random();
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
          http.Response response = await http.get(Uri.parse(element));
          await file!.writeAsBytes(response.bodyBytes);
          print("FileLocalPath "+file!.path.toString()+"^^");
          fileList.add(file!);

          // Converting uri to file
        } on UnsupportedError catch (e) {
          print(e.message);
          return null;// Unsupported error for uri not supported
        } on IOException catch (e) {
          print(e);
          return null;// IOException for system error
        } catch (e) {
          print(e);
          return null;// General exception
        }

      });
    }
    return file;
  }
  customDialogReview(int index) async {
    if(isloading!=true){
      if(isLoading!=true){
        ratting = reviewList[index].ratting!=null?double.parse(reviewList[index].ratting):0.0;
        ivStatus = reviewList[index].image_video_status;
        check = reviewList[index].tag;
        image_video_status = reviewList[index].image_video_status;
        if(ivStatus=="2"){
          isVisible = true;
        }
        print("FilemnscnlancDialoge "+fileList.length.toString()+"^^");
        print("ivStatus "+ivStatus.toString()+"^^");


      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: isloading == true
                ? Column(
              children: [
                Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator()),
                Text(
                  "Please wait....",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            )
                : SingleChildScrollView(
                child: Card(
                  color: Colors.black,
                  // height: 49.h,
                  // width: 95.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              check = "";
                              ratting = 0.0;
                              reviewController.clear();
                              file = null;
                              fileName = "";
                              trimFile = null;
                              trimFileName = "";
                              ivStatus = "";
                              image_video_status = "";
                              currentPath = "";
                              fileList.clear();
                              images.clear();
                            },
                            child: Container(
                              height: 8.w,
                              width: 8.w,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/cross.svg",
                                  color: Colors.white,
                                  width: 4.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      reviewList[index].reviewType!="REVIEW"?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),
                          InkWell(
                            onTap: () {
                              setState(() {
                                check = "fire";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/file.svg",
                                    color: check == "fire"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  SizedBox(
                                    height: 1.2.h,
                                  ),
                                  Text(
                                    "Fire",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "fire"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),

                          InkWell(
                            onTap: () {
                              print("tab");
                              setState(() {
                                check = "OkOk";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/bakance.svg",
                                    color:check == "OkOk"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  Text(
                                    "OkOk",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "OkOk"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              setState(() {
                                check = "Not Cool";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/snow.svg",
                                    color: check == "Not Cool"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  Text(
                                    "Not Cool",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "Not Cool"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),
                        ],
                      ):Container(height: 0,width: 0,),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Overall Rating",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: kCyanColor,

                                  //fontFamily: "Roboto"
                                ),
                              ),
                              SizedBox(
                                height: 0.6.h,
                              ),
                              RatingBar.builder(
                                itemSize: 24,
                                unratedColor: Color(0XFFCECECE),
                                initialRating: ratting.toString()!="null" || ratting.toString() !=""?ratting:0.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) =>
                                    Icon(
                                      Icons.star,
                                      size: 6.w,
                                      color: kPrimaryColor,
                                    ),
                                onRatingUpdate: (rating) {
                                  print("Ratting :" + rating.toString());
                                  ratting = rating;
                                 // reviewList[index].ratting = ratting.toString();
                                  //rat = rattingController.text.toString();
                                  print("Rat: " + ratting.toString());
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Add Images/Video",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: kCyanColor,

                                  //fontFamily: "Roboto"
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (ivStatus == "2") {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Either image or video can be post at a time'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          snackBar,
                                        );
                                      } else {
                                        // getImage();
                                       // fileList.clear();
                                        images.clear();
                                        file = null;
                                        fileName = "";
                                        int lengt = 3 - fileList.length;
                                        print("lengthFile "+fileList.length.toString()+"^^");
                                        if(fileList.length<3) {
                                          await pickImagesMultiple(lengt).then((
                                              value) {
                                            images = value;
                                            print("lengthhhhhh " +
                                                images.length.toString() + "*");
                                          });

                                          if (images.length > 0) {
                                            image_video_status = "1";
                                            ivStatus = "1";

                                            images.forEach((element) async {
                                              var path = await FlutterAbsolutePath
                                                  .getAbsolutePath(
                                                  element.identifier
                                                      .toString());
                                              print(
                                                  "pathhh " + path.toString() +
                                                      "*");

                                              file = File(path.toString());
                                              fileName = file!
                                                  .path
                                                  .split("/")
                                                  .last;
                                              fileList.add(file!);
                                              setState(() {

                                              });
                                            });
                                          } else {
                                            image_video_status = "0";
                                            ivStatus = "0";
                                            images.clear();
                                            fileList.clear();
                                          }
                                        }

                                        /* await pickImagess("review");
                                    setState(() {});*/
                                      }
                                    },
                                    child: /* file == null
                                          ? Container(
                                              child: SvgPicture.asset(
                                                  "assets/icons/image.svg"))
                                          : file!.path
                                                  .toString()
                                                  .endsWith("mp4")
                                              ? */
                                    Container(
                                        child: SvgPicture.asset(
                                            "assets/icons/image.svg"))
                                    /* : Container(
                                                  height: 3.h,
                                                  width: 3.h,
                                                  decoration: BoxDecoration(
                                                      // borderRadius:
                                                      //     BorderRadius.circular(3.w),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        //Color(0xffD5D5D5)
                                                      ),
                                                      image: DecorationImage(
                                                          image: FileImage(File(
                                                              file!.path)))),
                                                )*/
                                    ,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (ivStatus == "1") {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Either image or video can be post at a time'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBar,
                                          );
                                        } else {
                                          trimFileName = "";
                                          trimFile = null;
                                          file = null;
                                          fileName = "";
                                          currentPath = "";
                                          fileList.clear();
                                          images.clear();
                                          image_video_status = "0";
                                          ivStatus = "0";
                                          setState(() {

                                          });
                                          File file1;
                                          FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(
                                            type: FileType.video,
                                            allowCompression: false,
                                          );
                                          if (result != null) {

                                            file1 = File(
                                                result.files.single.path!);


                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return TrimmerView(file1);
                                                  }),
                                            );


                                            setState(() {
                                              if (currentPath.toString() !=
                                                  "") {
                                                file = File(currentPath.toString());
                                                fileName = path.basename(
                                                    file!.path.toString());
                                                ivStatus = "2";
                                                image_video_status = "2";
                                                print("FileName "+fileName+"");
                                              } else {
                                                trimFileName = "";
                                                trimFile = null;
                                                file = null;
                                                fileName = "";
                                                currentPath = "";
                                                fileList.clear();
                                                images.clear();
                                                ivStatus = "0";
                                                image_video_status = "0";
                                              }
                                              if (fileName == "" ||
                                                  fileName == null) {
                                                fileName = "File:- ";
                                                isVisible = false;
                                              } else {
                                                fileName = "File:- " + fileName;
                                                isVisible = true;
                                              }
                                            });

                                          }else{
                                            trimFileName = "";
                                            trimFile = null;
                                            file = null;
                                            fileName = "";
                                            currentPath = "";
                                            fileList.clear();
                                            images.clear();
                                            ivStatus = "0";
                                            image_video_status = "0";
                                          }
                                        }
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/video.svg")),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: .2.h),
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
                        height: 1.2.h,
                      ),
                      Visibility(
                        visible: image_video_status == "1" ? true : false,
                        child: Container(
                          height: 8.h,
                          width: 80.w,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            itemCount: fileList.length,
                            itemBuilder: (BuildContext context, int i) {
                              print("sdksndksan "+fileList[i].path.toString());
                              return Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 7.h,
                                        width: 9.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(2.w),
                                            image: DecorationImage(
                                                image: FileImage(
                                                    fileList[i]),
                                                fit: BoxFit.fill)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 11.w, bottom: 5.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            fileList.removeAt(i);
                                     /*       if(reviewList[index].business_review_image.length>i) {
                                              deleteImageApi(index,
                                                  reviewList[index]
                                                      .business_reviews_id,
                                                  reviewList[index]
                                                      .business_review_image[i]);
                                              reviewList[index]
                                                  .business_review_image
                                                  .removeAt(i);
                                            }
*/
                                            if (fileList.length == 0) {
                                              trimFile = null;
                                              trimFileName = "";
                                              ivStatus = "0";
                                              image_video_status = "0";
                                              file = null;
                                              fileName = "";
                                              fileList.clear();
                                              images.clear();
                                            }
                                            setState(() {

                                            });
                                          },
                                          child: Container(
                                            height: 4.h,
                                            width: 4.h,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                height: 2.h,
                                                width: 2.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/cross.svg",
                                                    width: 8,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                /*      ivStatus=="1"?  Container(

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Visibility(
                              visible: reviewList[index].image_video_status=="1"?true:false ,
                              child: Container(
                                height: 8.h,
                                width: 80.w,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: _controller,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: reviewList[index].business_review_image.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 7.h,
                                              width: 9.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(2.w),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          reviewList[index].business_review_image[i]),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 11.w, bottom: 5.h),
                                              child: GestureDetector(
                                                onTap: () {
                                                  deleteImageApi(index, reviewList[index].business_reviews_id, reviewList[index].business_review_image[i]);
                                                  reviewList[index].business_review_image.removeAt(i);
                                                  if (reviewList[index].business_review_image.length == 0) {
                                                    trimFile = null;
                                                    trimFileName = "";
                                                    ivStatus = "0";
                                                    image_video_status = "0";
                                                    file = null;
                                                    fileName = "";
                                                    fileList.clear();
                                                    images.clear();
                                                  }
                                                  setState(() {

                                                  });
                                                },
                                                child: Container(
                                                  height: 4.h,
                                                  width: 4.h,
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Container(
                                                      height: 2.h,
                                                      width: 2.h,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          "assets/icons/cross.svg",
                                                          width: 8,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):Container(height: 0, width: 0,),*/

                      ivStatus=="2"? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {

                                    print("run");
                                  /*  if(reviewList[index].business_review_image.length>0){

                                      deleteImageApi(index, reviewList[index].business_reviews_id, reviewList[index].business_review_image[0]);
                                      reviewList[index].business_review_image.clear();

                                    }*/
                                   // Navigator.of(context, rootNavigator: true).pop();
                                    setState(() {

                                      file = null;
                                      fileName = "";
                                      base64Image = "";
                                      image_video_status = "0";
                                      ivStatus = "0";
                                      currentPath = "";
                                    });
                                   // customDialogReview(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/cross.svg",
                                      color: Colors.white,
                                      width: 4.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                fileName==""?reviewList[index].business_review_image.length>0?reviewList[index].business_review_image[0]:"":fileName,
                                maxLines: 3,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ):Container(height: 0, width: 0,),
                      isloading
                          ? Align(
                          alignment: Alignment.center,
                          child: Platform.isAndroid
                              ? CircularProgressIndicator()
                              : CupertinoActivityIndicator())
                          : DefaultButton(
                          width: 35.w,
                          height: 6.h,
                          text: "Submit",
                          press: () {
                           if (reviewController.text.toString() ==
                                "" ||
                                reviewController.text.toString() ==
                                    "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                      Text("Please enter review")));
                            } else {
                              if (currentPath != "") {
                                file = File(currentPath.toString());
                                fileName = path.basename(file!.path);
                              }

                              editReviewApi(reviewList[index].business_reviews_id.toString(), reviewController.text.toString(), index);

                            }
                          })
                    ],
                  ),
                )),
          );
        });
      },
    );
  }
  checkInDialog(int index) {
    print("Checkin");
    ratting = reviewList[index].ratting!=null?double.parse(reviewList[index].ratting):0.0;
    ivStatus = reviewList[index].image_video_status;
    image_video_status = reviewList[index].image_video_status;
    if(ivStatus=="2"){
      isVisible = true;
    }
    print("FilemnscnlancDialoge "+fileList.length.toString()+"^^");


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          print("check: " + check.toString());
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w)),
            title: isloading == true
                ? Column(
              children: [
                Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator()),
                Text(
                  "Please wait....",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            )
                : SingleChildScrollView(
                child: Card(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();

                              reviewController2.clear();
                              file = null;
                              fileName = "";
                              image_video_status = "0";
                              ivStatus = "";
                              currentPath = "";
                              rattingcheckin = 0.0;
                              check = "";
                              fileList.clear();
                              images.clear();
                            },
                            child: Container(
                              height: 10.w,
                              width: 10.w,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/cross.svg",
                                  color: Colors.white,
                                  width: 4.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.2.h,
                      ),
                      Text(
                        "How do you like restaurant\n"
                            "after check in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                            // fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"
                          //fontFamily: "Segoepr"
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),
                          InkWell(
                            onTap: () {
                              setState(() {
                                check = "fire";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/file.svg",
                                    color: check == "fire"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  SizedBox(
                                    height: 1.2.h,
                                  ),
                                  Text(
                                    "Fire",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "fire"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),

                          InkWell(
                            onTap: () {
                              print("tab");
                              setState(() {
                                check = "OkOk";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/bakance.svg",
                                    color: check == "OkOk"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  Text(
                                    "OkOk",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "OkOk"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              setState(() {
                                check = "Not Cool";
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/snow.svg",
                                    color: check == "Not Cool"
                                        ? kPrimaryColor
                                        : kIconBackgroundColor,
                                  ),
                                  Text(
                                    "Not Cool",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: check == "Not Cool"
                                          ? kPrimaryColor
                                          : Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // StatefulBuilder(builder: (context, setState) {
                          //   return
                          // }),
                        ],
                      ),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      Container(
                        height: 0.5,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Overall Rating",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: kCyanColor,

                                  //fontFamily: "Roboto"
                                ),
                              ),
                              SizedBox(
                                height: 0.6.h,
                              ),
                              RatingBar.builder(
                                itemSize: 24,
                                unratedColor: Color(0XFFCECECE),
                                initialRating: rattingcheckin,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) =>
                                    Icon(
                                      Icons.star,
                                      size: 6.w,
                                      color: kPrimaryColor,
                                    ),
                                onRatingUpdate: (rating) {
                                  print("Ratting :" + rating.toString());
                                  rattingcheckin = rating;
                                  //rat = rattingController.text.toString();
                                  print("Rat: " + rattingcheckin.toString());
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Add Images/Video",
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: kCyanColor,

                                  //fontFamily: "Roboto"
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (image_video_status == "2") {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Either image or video can be post at a time'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          snackBar,
                                        );
                                      } else {
                                        fileList.clear();
                                        images.clear();
                                        file = null;
                                        fileName = "";
                                        await pickImages().then((value) {
                                          images = value;
                                          print("lengthhhhhh " + images.length.toString() + "*");
                                        });
                                        if (images.length > 0) {
                                          image_video_status = "1";
                                          ivStatus = "1";
                                          images.forEach((element) async {
                                            var path = await FlutterAbsolutePath.getAbsolutePath(
                                                element.identifier.toString());
                                            print("pathhh " + path.toString() + "*");

                                            file = File(path.toString());
                                            fileName = file!
                                                .path
                                                .split("/")
                                                .last;
                                            fileList.add(file!);
                                            setState(() {

                                            });
                                          });


                                        } else {
                                          image_video_status = "0";
                                          ivStatus = "0";
                                          images.clear();
                                          fileList.clear();
                                        }
                                        //getCheckInImage();
                                      }
                                      //                              ScaffoldMessenger.of(context)
                                      // .showSnackBar(SnackBar(content: Text("You can select either images or video")));

                                      //                             if (fileName.toString() != "null" || fileName.toString() != "") {
                                      //                               ScaffoldMessenger.of(context)
                                      // .showSnackBar(SnackBar(content: Text("You can select either images or video")));

                                      //                             }
                                    },
                                    child: file == null
                                        ? Container(
                                        child: SvgPicture.asset(
                                            "assets/icons/image.svg"))
                                        : file!.path
                                        .toString()
                                        .endsWith("mp4")
                                        ? Container(
                                        child: SvgPicture.asset(
                                            "assets/icons/image.svg"))
                                        : Container(
                                        child: SvgPicture.asset(
                                            "assets/icons/image.svg")),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (image_video_status == "1") {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Either image or video can be post at a time'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBar,
                                          );
                                        } else {
                                          File file1;
                                          trimFileName = "";
                                          trimFile = null;
                                          file = null;
                                          fileName = "";
                                          currentPath = "";
                                          fileList.clear();
                                          images.clear();
                                          image_video_status = "0";
                                          setState(() {

                                          });
                                          FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(
                                            type: FileType.video,
                                            allowCompression: false,
                                          );
                                          if (result != null) {
                                            file1 = File(
                                                result.files.single.path!);


                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return TrimmerView(file1);
                                                  }),
                                            );
                                            Navigator.of(context,
                                                rootNavigator: true)
                                                .pop();
                                            setState(() {
                                              if (currentPath.toString() !=
                                                  "") {
                                                ivStatus = "2";
                                                file = File(
                                                    currentPath.toString());
                                                fileName = path.basename(
                                                    file!.path.toString());
                                                image_video_status = "2";
                                              } else {
                                                trimFileName = "";
                                                trimFile = null;
                                                file = null;
                                                fileName = "";
                                                currentPath = "";
                                                fileList.clear();
                                                images.clear();
                                                image_video_status = "0";
                                              }

                                              if (fileName == "" ||
                                                  fileName == null) {
                                                fileName = "File:- ";
                                                isVisible = false;
                                              } else {
                                                fileName = "File:- " + fileName;
                                                isVisible = true;
                                              }
                                            });
                                            checkInDialog(index);
                                          }
                                        }
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/video.svg")),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 12.h,
                        width: 85.w,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(3.w)),
                        child: TextFormField(
                          controller: reviewController2,
                          style: TextStyle(color: Color(0XFFCECECE)),
                          maxLines: 5,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: .2.h),
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
                        height: 1.2.h,
                      ),
                      Visibility(
                        visible: true,
                        child: Container(
                          height: 8.h,
                          width: 80.w,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            fileList.length == 0 ? 0 : fileList.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 7.h,
                                        width: 9.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(2.w),
                                            image: DecorationImage(
                                                image: FileImage(
                                                    fileList[i]),
                                                fit: BoxFit.fill)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 11.w, bottom: 5.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            fileList.removeAt(i);
                                            images.removeAt(i);

                                            if (fileList.length == 0) {
                                              file = null;
                                              fileName = "";
                                              fileList.clear();
                                              images.clear();
                                              ivStatus = "0";
                                              image_video_status = "0";
                                            }
                                            setState(() {

                                            });
                                          },
                                          child: Container(
                                            height: 4.h,
                                            width: 4.h,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                height: 2.h,
                                                width: 2.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/cross.svg",
                                                    width: 8,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Visibility(
                            visible: isVisible,
                            child: Text(
                              fileName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      DefaultButton(
                          width: 35.w,
                          height: 6.h,
                          text: "Submit",
                          press: () {
                            if (check.toString() == "" ||
                                check.toString() == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select tag")));
                            } else if (rattingcheckin.toString() == "0.0" ||
                                rattingcheckin.toString() == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select rating")));
                            } else if (reviewController2.text.toString() ==
                                "" ||
                                reviewController2.text.toString() == "null") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please enter review")));
                            } else {
                              if (currentPath != "") {
                                file = File(currentPath.toString());
                                fileName = path.basename(file!.path);
                                print("Filename " + fileName.toString());
                              }
                              Navigator.of(context, rootNavigator: true).pop();
                              setState(() {
                                isloading = true;
                                checkInDialog(index);
                              });
                            /*  editReviewApi(
                                  reviewList[index].id,
                                  reviewController2.text.toString(),);*/
                            }
                          })
                    ],
                  ),
                )),
          );
        });
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
                  "want to delete this review?",
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

  Future<List<File>> getData(int index) async{
    setState(() {
      isloading = true;
      customDialogReview(index);
    });
    for(var k = 0; k< reviewList[index].business_review_image.length; k++){
      if(reviewList[index].business_review_image[k].toString().trim()!="") {
        var rng = new Random();
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
        http.Response response = await http.get(Uri.parse(reviewList[index].business_review_image[k]));
        await file.writeAsBytes(response.bodyBytes);
        fileList.add(file);
        print(fileList.length.toString());

      }
    }
    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
      isloading = false;
      customDialogReview(index);
    });
    //Navigator.of(context, rootNavigator: true).pop();

    return fileList;
  }

  Future<List<File>> getDataCheckin(int index) async{
    reviewList[index].business_review_image.forEach((element) async {
      if(element.toString().trim()!="") {
        var rng = new Random();
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
        http.Response response = await http.get(Uri.parse(element));
        await file.writeAsBytes(response.bodyBytes);
        fileList.add(file);
        print(fileList.length.toString());
        Navigator.of(context, rootNavigator: true).pop();
        checkInDialog(index);
      }

    });


    return fileList;
  }
  doNothing(int index) async {
    reviewController.text = reviewList[index].review;
      print("ImageLength "+reviewList[index].business_review_image.length.toString()+"%^%^");
      if(reviewList[index].business_review_image.length>0){
        //customDialogReview(index);
        await getData(index);
      }else{
        customDialogReview(index);
      }


    /*else{
      print("ElseCheckin");
      if(reviewList[index].business_review_image.length>0){
      checkInDialog(index);
      await getDataCheckin(index);
    }else{
      checkInDialog(index);
    }

    }*/


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
  var image_video_status = "0";
  var review = "";
  var reviewType = "";
  var tag = "";
  var assets = "";
  Color assetscolor = kPrimaryColor;
  double assetswidth = 5.w;
  List<dynamic> business_review_image = [];
  var created_at = "";
  var timedelay = "Seconds";

}




