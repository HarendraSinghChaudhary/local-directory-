

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';

class FliterScreen extends StatefulWidget {
  const FliterScreen({Key? key}) : super(key: key);

  @override
  _FliterScreenState createState() => _FliterScreenState();
}

class _FliterScreenState extends State<FliterScreen> {

   bool remember = false;
   bool isloading = false;




  List data = [];
  List areas = [];
  List<LifeStyle> lifeStyleList = [];
  bool arecheckbox = false;
  bool val = false;

  List<ABC> stringList = [];

  @override
  void initState() {
    liefeStyleApi();
    
    super.initState();
    
  }

  // void listText() {
  //   FilterList1 obj = FilterList1();
  //   obj.lifestyle = "Show Friends";
  //   List<Reslist> listres1 = [];

  //   Reslist reslist = Reslist(); // creating object of class
  //   reslist.name = "Happy Hour";

  //   listres1.add(reslist);

  //   Reslist reslist1 = Reslist(); // creating object of class
  //   reslist1.name = "Breakfast";

  //   listres1.add(reslist1);

  //   obj.area = listres1;

  //   FilterList1 obj1 = FilterList1();
  //   obj1.lifestyle = "Current Promotion";

  //   FilterList1 obj2 = FilterList1();
  //   obj2.lifestyle = "Online Only";

  //   FilterList1 obj3 = FilterList1();
  //   obj3.lifestyle = "Nightlife";

  
  //   FilterList1 obj4 = FilterList1();
  //   obj4.lifestyle = "Lit";


  //   FilterList1 obj5 = FilterList1();
  //   obj5.lifestyle = "Hit or Miss";

  //   FilterList1 obj6 = FilterList1();
  //   obj6.lifestyle = "Chill";

  //   FilterList1 obj7 = FilterList1();
  //   obj7.lifestyle = "Restaurants & Bars";
    

  //   FilterList1 obj8 = FilterList1();
  //   obj8.lifestyle = "Trades / Professional Services";

  //   FilterList1 obj9 = FilterList1();
  //   obj9.lifestyle = "Health / Medical";

  //   FilterList1 obj10 = FilterList1();
  //   obj10.lifestyle = "Health / Medical";

  //   FilterList1 obj11 = FilterList1();
  //   obj11.lifestyle = "Arts / Crafts";

  //   locList1.add(obj);
  //   locList1.add(obj1);
  //   locList1.add(obj2);
  //   locList1.add(obj3);
  //   locList1.add(obj4);
  //   locList1.add(obj5);
  //   locList1.add(obj6);
  //   locList1.add(obj7);
  //   locList1.add(obj8);
  //   locList1.add(obj9);
  //   locList1.add(obj10);
  //   locList1.add(obj11);

  //   locList1.forEach((element) {
  //     print(element.lifestyle);
  //     element.area.forEach((element) {
  //       print(element.name);
  //     });
  //     // print(element.name);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Text("Filter"),
        ),
      ),
      body: ListView.builder(
        itemCount: lifeStyleList.length,
        itemBuilder: (BuildContext context, int index) {
          // areas = data[index]['areas'];
          //  print(data[0]['areas'][0]['name']);
          return ExpansionTile(
            onExpansionChanged: (val) {
              // setState(() {
              //   if (locList1[index].area.length == 0) {
              //     locList1[index].isSelected = !locList1[index].isSelected;
              //   }
              // });
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
                      child: Icon(Icons.keyboard_arrow_down_sharp,
                      size: 30,
                      color: Colors.white,
                      )
                    ),
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
                      itemCount: lifeStyleList[index].name.length,
                      itemBuilder: (BuildContext context, int i) {
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
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return kPrimaryColor;
                                }
                                return Colors.white60;
                              }),
                              value: remember,
                              onChanged: (val )  {
                                setState(() {
                                  remember = val!;
                                });
                              }),
                          // onTap: () {
                          //   setState(() {
                          //     locList1[index].area[i].isSelected =
                          //         !locList1[index].area[i].isSelected;
                          //   });
                          // },
                          //title: Text(locList1[index].area[i].name, style: TextStyle(color: Colors.white),), 
                        );
                      },
                    )
            ],
          );
        },
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

          // jsonErray = jsonRes['data'][i]['name'];
          // for (var j = 0; j < jsonErray.length; j++) {
          //   SubLifeStyle modelFilter = new SubLifeStyle();
          //   modelFilter.id = jsonErray[j]["id"].toString();
          //   modelFilter.name = jsonErray[j]["name"].toString();
          //   modelFilter.category_id = jsonErray[j]["category_id"].toString();
          //   print("id sub: " + modelFilter.name.toString());
            

            
          // }

          


          

          

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.name.toString());

          lifeStyleList.add(modelAgentSearch);

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


class LifeStyle {
  String id = "";
  String name = "";
  bool isSelected = false;
  List<SubLifeStyle> subLifeStyle = [];
}

class SubLifeStyle {
  String id = "";
  String category_id = "";
  String name = "";
  bool isSelected = false;

}

class ABC {
  String? name;
  String? id;
}

class FilterList1 {
  String lifestyle = "";
  bool isSelected = false;
  List<Reslist> area = [];
}

class Reslist {
  String name = "";
  String namee = "";
  bool isSelected = false;
}
