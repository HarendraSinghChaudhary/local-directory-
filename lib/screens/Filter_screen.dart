import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/googleMap_screen.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:wemarkthespot/services/modelProvider.dart';

class FliterScreen extends StatefulWidget {
   var list;
   FliterScreen({required this.list});
  

  @override
  _FliterScreenState createState() => _FliterScreenState();
}

class _FliterScreenState extends State<FliterScreen> {
  ScrollController _controller = new ScrollController();

  bool remember = false;
  bool isloading = false;
  bool statusOnly = false;
  bool statusCp = false;
  bool statusHe = false;
  bool isReligious = false;
  String onlineOnly = "0";
  String currentP = "0";
  String habEsp = "0";
  String resSpri = "0";

  List data = [];
  List areas = [];
  List<LifeStyle> lifeStyleList = [];
  bool arecheckbox = false;
  bool val = false;
  List<String> selectedCat = [];
  @override
  void initState() {
    if(widget.list!=null){
      if(widget.list.length!=0){
        lifeStyleList = widget.list;
      }else{
        liefeStyleApi();
      }
    }else {
      liefeStyleApi();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("object "+widget.list);
    var count = '${context.watch<Counter>().isOnline}';
    print("count "+count.toString());
    if(count == "1"){
      statusOnly = true;
    }else{
      statusOnly = false;
    }

    var count1 = '${context.watch<Counter>().isCurrent}';
    print("count1 "+count1.toString());
    if(count1 == "1"){
      statusCp = true;
    }else{
      statusCp = false;
    }

    var count2 = '${context.watch<Counter>().isHablamos}';
    print("count2 "+count2.toString());
    if(count2 == "1"){
      statusHe = true;
    }else{
      statusHe = false;
    }

    var count3 = '${context.watch<Counter>().isReligious}';
    print("count3 "+count3.toString());
    if(count3 == "1"){
      isReligious = true;
    }else{
      isReligious = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Text("Filter"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isloading==true?Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Center(child: CircularProgressIndicator(),),
            ):ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: lifeStyleList.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  onExpansionChanged: (val) {

                  },
                  trailing: lifeStyleList[index].name.length == 0
                      ? Container(
                          width: 50,
                          child: Center(
                            child: lifeStyleList[index].isSelected
                                ? Checkbox(
                                    // fillColor: MaterialStateProperty.,
                                    activeColor: Color(0xffFFBA00),
                                    value: lifeStyleList[index].isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        lifeStyleList[index].isSelected =
                                            !lifeStyleList[index].isSelected;

                                      });
                                    },
                                  )
                                : Container(),
                          ),
                        )
                      : Container(
                          width: 50,
                          child: Center(
                              child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 30,
                            color: Colors.white,
                          )),
                        ),
                  title: Text(
                    lifeStyleList[index].name.toString(),
                    style: TextStyle(color: kCyanColor),
                  ),
                  children: [
                    lifeStyleList[index].name.length == 0
                        ? Container()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lifeStyleList[index].subLifeStyle.length,
                            itemBuilder: (BuildContext context, int j) {
                              return ListTile(
                                leading: Checkbox(
                                    activeColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return kPrimaryColor;
                                      }
                                      return Colors.white60;
                                    }),
                                    value: lifeStyleList[index]
                                        .subLifeStyle[j]
                                        .isSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        lifeStyleList[index]
                                            .subLifeStyle[j]
                                            .isSelected = val!;
                                      });
                                    }),
                                // onTap: () {
                                //   setState(() {
                                //     locList1[index].area[i].isSelected =
                                //         !locList1[index].area[i].isSelected;
                                //   });
                                // },
                                title: Text(
                                  lifeStyleList[index]
                                      .subLifeStyle[j]
                                      .name
                                      .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          )
                  ],
                );
              },
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Online Only",
                    style: TextStyle(
                        color: kCyanColor,
                        fontSize: 13.sp,
                        fontFamily: 'Roboto'),
                  ),
                  Center(
                    child: Container(
                      child: FlutterSwitch(
                        activeColor: kPrimaryColor,
                        width: 12.w,
                        height: 3.h,
                        valueFontSize: 0.0,
                        toggleSize: 20.0,
                        toggleColor: Colors.black,
                        value: statusOnly,
                        borderRadius: 30.0,
                        //padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            statusOnly = val;
                            if (statusOnly == true) {

                              onlineOnly = "1";

                              print("online 1 : "+onlineOnly.toString());
                              context.read<Counter>().setisOnline("1");

                              
                            } else{
                              context.read<Counter>().setisOnline("0");
                              onlineOnly = "0";
                            }
                            print("status online: "+statusOnly.toString());
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Promotion",
                    style: TextStyle(
                        color: kCyanColor,
                        fontSize: 13.sp,
                        fontFamily: 'Roboto'),
                  ),
                  Center(
                    child: Container(
                      child: FlutterSwitch(
                        activeColor: kPrimaryColor,
                        width: 12.w,
                        height: 3.h,
                        valueFontSize: 0.0,
                        toggleSize: 20.0,
                        toggleColor: Colors.black,
                        value: statusCp,
                        borderRadius: 30.0,
                        //padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            statusCp = val;

                            if (statusCp == true) {

                              currentP = "1";

                              print("current postion: "+currentP.toString());
                              context.read<Counter>().setisCurrent("1");

                              
                            }else{
                              currentP = "0";
                              context.read<Counter>().setisCurrent("0");
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hablamos Espanol ",
                    style: TextStyle(
                        color: kCyanColor,
                        fontSize: 13.sp,
                        fontFamily: 'Roboto'),
                  ),
                  Center(
                    child: Container(
                      child: FlutterSwitch(
                        activeColor: kPrimaryColor,
                        width: 12.w,
                        height: 3.h,
                        valueFontSize: 0.0,
                        toggleSize: 20.0,
                        toggleColor: Colors.black,
                        value: statusHe,
                        borderRadius: 30.0,
                        //padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            statusHe = val;

                            if (statusHe == true) {

                              habEsp = "1";

                              print("hablamos: "+habEsp.toString());

                              context.read<Counter>().setisHablamos("1");
                              
                            }else{
                              context.read<Counter>().setisHablamos("0");
                              habEsp = "0";
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),

               Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Religious Spiritual ",
                    style: TextStyle(
                        color: kCyanColor,
                        fontSize: 13.sp,
                        fontFamily: 'Roboto'),
                  ),
                  Center(
                    child: Container(
                      child: FlutterSwitch(
                        activeColor: kPrimaryColor,
                        width: 12.w,
                        height: 3.h,
                        valueFontSize: 0.0,
                        toggleSize: 20.0,
                        toggleColor: Colors.black,
                        value: isReligious,
                        borderRadius: 30.0,
                        //padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            isReligious = val;

                            if (isReligious == true) {

                              resSpri = "1";


                              print("Relegios: "+resSpri.toString());
                              context.read<Counter>().setisReligious("1");

                              
                            } else 
                            {
                              resSpri = "0";

                              print("Relegios: "+resSpri.toString());
                              context.read<Counter>().setisReligious("0");
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 3.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45.w,
                    height: 7.h,

                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     color: Colors.black,
                     border: Border.all(
                       color: kPrimaryColor
                     )
                    ),
                    child: FlatButton(
                     
                     
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: kPrimaryColor,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                  DefaultButton(
                      width: 45.w, height: 7.h, text: "Apply", press: () {

                     Navigator.pushAndRemoveUntil(context,
                         MaterialPageRoute(builder: (context) =>
                         HomeNav.one(1, lifeStyleList, "filter", 
                         /*onlineOnly.toString() == "null" || onlineOnly.toString() == "" ? "0" : */onlineOnly.toString() ,
                        /* habEsp.toString() == "null" || habEsp.toString() == "" ? "0" : */habEsp.toString() ,
                         /*resSpri.toString() == "null" || resSpri.toString() == "" ? "0" : */resSpri.toString() ,
                         /*currentP.toString() == "null" || currentP.toString() == "" ? "0" : */currentP.toString() ,)
                ), (r)=> false);
                  })
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> liefeStyleApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(Uri.parse(RestDatasource.FILTERAPI_URL));

    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;
    var jsonErray;

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
        lifeStyleList.clear();
        for (var i = 0; i < jsonArray.length; i++) {
          LifeStyle modelAgentSearch = new LifeStyle();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.name = jsonArray[i]["name"].toString();
          modelAgentSearch.subcategory = jsonArray[i]["subcategory"].toString();

          jsonErray = jsonRes['data'][i]['subcategory'];
          for (var j = 0; j < jsonErray.length; j++) {
            SubLifeStyle modelFilter = new SubLifeStyle();
            modelFilter.id = jsonErray[j]["id"].toString();
            modelFilter.name = jsonErray[j]["name"].toString();
            modelFilter.category_id = jsonErray[j]["category_id"].toString();
            print("id sub: " + modelFilter.name.toString());

            // for (var i = 0; i < count; i++) {
              
            // }

            modelAgentSearch.subLifeStyle.add(modelFilter);
          }

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.name.toString());

          lifeStyleList.add(modelAgentSearch);

        }

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
}

class LifeStyle {
  String id = "";
  String name = "";
  bool isSelected = false;
  var subcategory = "";
  List<SubLifeStyle> subLifeStyle = [];
}

class SubLifeStyle {
  String id = "";
  String category_id = "";
  String name = "";
  bool isSelected = false;
}
