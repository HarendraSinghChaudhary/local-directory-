import 'package:flutter/material.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:wemarkthespot/screens/explore.dart';

class BlankScreen extends StatefulWidget {
  NearBy nearby;
  BlankScreen({Key? key, required this.nearby}) : super(key: key);

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (builder)=> DetailBussiness(nearBy: widget.nearby,)));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
