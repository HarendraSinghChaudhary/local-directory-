

import 'package:flutter/material.dart';

import 'package:wemarkthespot/constant.dart';

class FliterScreen extends StatefulWidget {
  const FliterScreen({Key? key}) : super(key: key);

  @override
  _FliterScreenState createState() => _FliterScreenState();
}

class _FliterScreenState extends State<FliterScreen> {

   bool remember = false;




  List data = [];
  List areas = [];
  List<FilterList1> locList1 = [];
  bool arecheckbox = false;
  bool val = false;

  List<ABC> stringList = [];

  @override
  void initState() {
    
    super.initState();
    listText();
  }

  void listText() {
    FilterList1 obj = FilterList1();
    obj.lifestyle = "Show Friends";
    List<Reslist> listres1 = [];

    Reslist reslist = Reslist(); // creating object of class
    reslist.name = "Happy Hour";

    listres1.add(reslist);

    Reslist reslist1 = Reslist(); // creating object of class
    reslist1.name = "Breakfast";

    listres1.add(reslist1);

    obj.area = listres1;

    FilterList1 obj1 = FilterList1();
    obj1.lifestyle = "Current Promotion";

    FilterList1 obj2 = FilterList1();
    obj2.lifestyle = "Online Only";

    FilterList1 obj3 = FilterList1();
    obj3.lifestyle = "Nightlife";

  
    FilterList1 obj4 = FilterList1();
    obj4.lifestyle = "Lit";


    FilterList1 obj5 = FilterList1();
    obj5.lifestyle = "Hit or Miss";

    FilterList1 obj6 = FilterList1();
    obj6.lifestyle = "Chill";

    FilterList1 obj7 = FilterList1();
    obj7.lifestyle = "Restaurants & Bars";
    

    FilterList1 obj8 = FilterList1();
    obj8.lifestyle = "Trades / Professional Services";

    FilterList1 obj9 = FilterList1();
    obj9.lifestyle = "Health / Medical";

    FilterList1 obj10 = FilterList1();
    obj10.lifestyle = "Health / Medical";

    FilterList1 obj11 = FilterList1();
    obj11.lifestyle = "Arts / Crafts";

    locList1.add(obj);
    locList1.add(obj1);
    locList1.add(obj2);
    locList1.add(obj3);
    locList1.add(obj4);
    locList1.add(obj5);
    locList1.add(obj6);
    locList1.add(obj7);
    locList1.add(obj8);
    locList1.add(obj9);
    locList1.add(obj10);
    locList1.add(obj11);

    locList1.forEach((element) {
      print(element.lifestyle);
      element.area.forEach((element) {
        print(element.name);
      });
      // print(element.name);
    });
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
      body: ListView.builder(
        itemCount: locList1.length,
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
            trailing: locList1[index].area.length == 0
                ? Container(
                    width: 50,
                    child: Center(
                      child: locList1[index].isSelected
                          ? Checkbox(
                              // fillColor: MaterialStateProperty.,
                              activeColor: Color(0xffFFBA00),
                              value: locList1[index].isSelected,
                              onChanged: (value) {
                                setState(() {
                                  locList1[index].isSelected =
                                      !locList1[index].isSelected;
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
              locList1[index].lifestyle.toString(),
              style: TextStyle(color: kCyanColor),
            ),
            children: [
              locList1[index].area.length == 0
                  ? Container()
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: locList1[index].area.length,
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
                          onTap: () {
                            setState(() {
                              locList1[index].area[i].isSelected =
                                  !locList1[index].area[i].isSelected;
                            });
                          },
                          title: Text(locList1[index].area[i].name, style: TextStyle(color: Colors.white),), 
                        );
                      },
                    )
            ],
          );
        },
      ),
    );
  }
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
