import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';

class DraggableScrollableSheetExample extends StatelessWidget {
  const DraggableScrollableSheetExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: SafeArea(
              child: SingleChildScrollView(
                
              ) )
          ),
          _buildDraggableScrollableSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet _buildDraggableScrollableSheet() {
    bool isloading = false;
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Scrollbar(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(Icons.ac_unit),
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// // Container(
// //           decoration: const BoxDecoration(
// //             color: Colors.blue,
// //             // border: Border.all(color: Colors.blue, width: 2),
// //             borderRadius: BorderRadius.only(
// //               topLeft: Radius.circular(30),
// //               topRight: Radius.circular(30),
// //             ),
// //           ),
// //           child: Scrollbar(
// //             child: ListView.builder(
// //               controller: scrollController,
// //               itemCount: 25,
// //               itemBuilder: (BuildContext context, int index) {
// //                 return ListTile(
// //                   leading: const Icon(Icons.ac_unit),
// //                   title: Text('Item $index'),
// //                 );
// //               },
// //             ),
// //           ),
// //         );
