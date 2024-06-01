// ignore_for_file: avoid_print, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loream extends StatefulWidget {
  final String title;
  const Loream(this.title, {Key? key}) : super(key: key);
  @override
  State<Loream> createState() => _LoreamState();
}

class _LoreamState extends State<Loream> {
  late ColorNotifire notifire;

  String? text;
  List<DynamicPageData> dynamicPageDataList = [];
  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();

    getWebData();
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

    var sp;
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.getdarkscolor),
                    SizedBox(width: width / 80),
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height / 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Column(children: [
                      (text != null && text!.isNotEmpty)
                          ? HtmlWidget(text ?? "",
                              textStyle: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal'))
                          : Text("",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height / 50,
                                  fontFamily: 'Gilroy Normal')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getWebData() {
    Map<String, dynamic> data = {};

    dynamicPageDataList.clear();
    ApiWrapper.dataPost(Config.pagelist, data).then((value) {
      if ((value != null) &&
          (value.isNotEmpty) &&
          (value['ResponseCode'] == "200")) {
        List da = value['pagelist'];
        for (int i = 0; i < da.length; i++) {
          Map<String, dynamic> mapData = da[i];
          DynamicPageData a = DynamicPageData.fromJson(mapData);
          dynamicPageDataList.add(a);
          // Privacy Policy
          // Terms & Conditions
          // Contact Us
        }

        for (int i = 0; i < dynamicPageDataList.length; i++) {
          if ((widget.title == dynamicPageDataList[i].title)) {
            text = dynamicPageDataList[i].description;
            setState(() {});
            return;
          } else {
            text = "";
          }
        }
      }
    });
  }
}

class DynamicPageData {
  DynamicPageData(this.title, this.description);

  String? title;
  String? description;

  DynamicPageData.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description};
  }
}
