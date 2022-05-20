// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wemarkthespot/constant.dart';







class PaymentGateway extends StatefulWidget {

  var price;
  var id;

  PaymentGateway({required this.price, required this.id});


  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<PaymentGateway> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
       appBar: AppBar(
        backgroundColor: kCyanColor,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              "Payment Screen",
              style:
                  TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {

        return WebView(
     
          initialUrl: 'https://myprojectdesk.tech/development/wemarkthespot/payments/'+widget.id.toString()+"/"+widget.price.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            print("this is :" + webViewController.toString());
             print("this is1 :" + _controller.toString());
             
          },
       
       
          onPageStarted: (String value){
           
          },
         onPageFinished: (value) {
            if (value.toString() ==
                    "https://myprojectdesk.tech/development/wemarkthespot/strippayment" ||
                value.toString() ==
                    "https://myprojectdesk.tech/development/wemarkthespot/payment_failed") {
              Future.delayed(const Duration(seconds: 5), () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          },
          gestureNavigationEnabled: true,
          backgroundColor:  Colors.black,
        );
      }),
    
    );
  }



@override
  void dispose() {
    super.dispose();
  }

}

