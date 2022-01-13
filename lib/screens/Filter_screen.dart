import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/default_button.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/googleMap_screen.dart';
import 'package:wemarkthespot/services/api_client.dart';

class FliterScreen extends StatefulWidget {
  const FliterScreen({Key? key}) : super(key: key);

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

  List data = [];
  List areas = [];
  List<LifeStyle> lifeStyleList = [];
  bool arecheckbox = false;
  bool val = false;
  List<String> selectedCat = [];
  @override
  void initState() {
    liefeStyleApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            ListView.builder(
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
                     
                     
                      onPressed: () {},
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
                     lifeStyleList.forEach((element) {
                      if(element.subLifeStyle!=null){
                        if(element.subLifeStyle.length>0){
                          for(var j=0; j<element.subLifeStyle.length; j++){
                            if(element.subLifeStyle[j].isSelected){
                              selectedCat.add(element.subLifeStyle[j].id);
                            }
                          }
                        }
                      }
                    });

                    String s = selectedCat.join(', ');
                    print(selectedCat.toString());
                     Navigator.pushReplacement(context,
                         MaterialPageRoute(builder: (context) => GoogleMapScreen(list: selectedCat,)));
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

            modelAgentSearch.subLifeStyle.add(modelFilter);
          }

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.name.toString());

          lifeStyleList.add(modelAgentSearch);

          setState(() {});
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
