import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'package:http/http.dart' as http;

class FAQS extends StatefulWidget {
  const FAQS({Key? key}) : super(key: key);

  @override
  _FAQSState createState() => _FAQSState();
}

class _FAQSState extends State<FAQS> {

bool isloading = false;
  String selected = "";

  List<FaqClass> faqList = [];

  @override
  void initState() {
    faqApi();

    super.initState();
    
  }




  

  ScrollController _controller = new ScrollController();
  bool visibility1 = false;
  bool visibility2 = false;
  bool visibility3 = false;

  List<Map<dynamic, dynamic>> splashData = [
    {
      "title": "Lorem ipsum dolor sit amet?",
      "subTitile":
          "Lorem ipsum dolor sit amet, consetetur spscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.",
      "visibility": true
    },
    {
      "title": "Lorem ipsum dolor sit amet?",
      "subTitile":
          "Lorem ipsum dolor sit amet, consetetur spscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.",
      "visibility": false
    },
    {
      "title": "Lorem ipsum dolor sit amet?",
      "subTitile":
          "Lorem ipsum dolor sit amet, consetetur spscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.",
      "visibility": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "FAQs",
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
              height: 2.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: faqList.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpandableNotifier(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: kBackgroundColor,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                       
                        ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              useInkWell: true,
                              iconColor: kPrimaryColor,
                              iconSize: 30,
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                 // "Lorem ipsum dolor sit amet?",
                                 faqList[index].question.toString(),
                                  style: TextStyle(
                                      color: kCyanColor,
                                      fontSize: 13.sp,
                                      fontFamily: "Roboto"),
                                )),
                            collapsed: Text(
                             // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                             faqList[index].answers.toString(),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: "Roboto"),
                            ),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (var _ in Iterable.generate(5))
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                       // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",

                                       faqList[index].answers.toString(),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontFamily: "Roboto"),
                                      )),
                              ],
                            ),
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                  theme: const ExpandableThemeData(
                                      crossFadePoint: 0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

    Future<dynamic> faqApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.get(Uri.parse(RestDatasource.FAQ_URL));

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
        for (var i = 0; i < jsonArray.length; i++) {
          FaqClass modelAgentSearch = new FaqClass();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.question = jsonArray[i]["question"].toString();
          modelAgentSearch.answers = jsonArray[i]["answers"].toString();
          

          print("id: " + modelAgentSearch.id.toString());
          print("Bussiness: " + modelAgentSearch.question.toString());

          faqList.add(modelAgentSearch);

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


class FaqClass {
   String id = "";
   String question = "";
   String answers = "";
}