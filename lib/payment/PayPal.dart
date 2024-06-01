// ignore_for_file: unused_import, avoid_print, deprecated_member_use, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, unnecessary_null_comparison, unused_field, prefer_final_fields, use_key_in_widget_constructors, file_names, await_only_futures, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class PayPalPayment extends StatefulWidget {
  final String? totalAmount;

  const PayPalPayment({this.totalAmount});

  @override
  State<PayPalPayment> createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ColorNotifire notifire;

  String? accessToken;
  bool isLoading = true;

  String? payerID;
  var progress;

  @override
  void initState() {
    super.initState();
    setState(() {});
    getdarkmodepreviousstate();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    if (_scaffoldKey.currentState == null) {
      return Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: SafeArea(
            child: Stack(
          children: [
            WebView(
              initialUrl:
                  "https://townclap.cscodetech.com/paypal/index.php?amt=${widget.totalAmount}",
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              navigationDelegate: (NavigationRequest request) async {
                final uri = Uri.parse(request.url);
                log(uri.queryParameters.toString(), name: "URI :");
                if (uri.queryParameters["status"] == null) {
                  accessToken = uri.queryParameters["token"];
                } else {
                  if (uri.queryParameters["status"] == "payment_success") {
                    payerID = await uri.queryParameters["tid"];

                    Get.back(result: payerID);
                  } else {
                    Get.back();
                    // ApiWrapper.showToastMessage(
                    //     "${uri.queryParameters["status"]}");
                  }
                }

                return NavigationDecision.navigate;
              },
              onPageFinished: (finish) {
                log(finish.toString(), name: "Finish");
                setState(() {
                  isLoading = false;
                });
              },
              onProgress: (val) {
                progress = val;
                setState(() {});
                log(val.toString(), name: "onProgress");
              },
            ),
            isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loading(size: 60),
                        SizedBox(height: Get.height * 0.02),
                        SizedBox(
                          width: Get.width * 0.80,
                          child: Text(
                            'Please don`t press back until the transaction is complete',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: notifire.getdarkscolor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(),
          ],
        )),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back()),
            backgroundColor: Colors.black12,
            elevation: 0.0),
        body: Center(
            child: Container(
          child: loading(size: 60),
        )),
      );
    }
  }
}
