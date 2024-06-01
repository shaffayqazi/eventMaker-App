// ignore_for_file: file_names, avoid_print, unnecessary_import

import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponListPage extends StatefulWidget {
  final dynamic bill;
  const CouponListPage({Key? key, this.bill}) : super(key: key);

  @override
  State<CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  late ColorNotifire notifire;

  dynamic bill = 0.0;
  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    setState(() {});
    bill = double.parse(widget.bill.toString());
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
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
          title: Text("Available Coupon",
              style: TextStyle(
                  color: notifire.getdarkscolor, fontSize: Get.height / 40)),
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            FutureBuilder(
              future: getCouponList(),
              builder: (ctx, AsyncSnapshot snap) {
                if (snap.hasData) {
                  var users = snap.data;
                  return users.length == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: Get.height * 0.35),
                            Center(
                                child: Text(
                              'No Coupon',
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                          ],
                        )
                      : Ink(
                          height: Get.height * 0.85,
                          child: ListView.builder(
                              padding:
                                  EdgeInsets.only(bottom: Get.height * 0.30),
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, i) {
                                return couponlist(users, i);
                              }),
                        );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: Get.height * 0.35),
                      Center(child: loading(size: 60)),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  couponlist(user, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  height: Get.height * 0.05,
                  width: Get.width * 0.35,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(2)),
                  child: FadeInImage(
                      placeholder: const AssetImage("image/skeleton.gif"),
                      image:
                          NetworkImage(Config.imageURLPath + user[i]["c_img"])),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${mainData["currency"]}${user[i]["c_value"]}",
                    style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  // SizedBox(height: Get.height * 0.005),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.015),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Ink(
                  width: Get.width * 0.90,
                  child: Text(user[i]["coupon_title"],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Ink(
                  width: Get.width * 0.85,
                  child: Html(
                    data: user[i]["c_desc"],
                    style: {
                      "body": Style(
                          maxLines: 5,
                          textOverflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                          fontSize: const FontSize(14)),
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(6),
                      strokeWidth: 1, //thickness of dash/dots
                      dashPattern: const [3, 2],
                      color: Colors.blueAccent.shade100,
                      child: Container(
                          height: Get.height * 0.035,
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  user[i]["coupon_code"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: notifire.getdarkscolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  //! -------- Apply button ----------
                  bill > double.parse(user[i]["min_amt"].toString())
                      ? InkWell(
                          onTap: () {
                            couponCheckApi(user[i]);
                          },
                          child: Container(
                            height: Get.height * 0.035,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.shade400, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text("Apply",
                                  style: TextStyle(
                                      color: Colors.green.shade400,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        )
                      : Container(
                          height: Get.height * 0.035,
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text("Apply",
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                ],
              ),
              SizedBox(height: Get.height * 0.01)
            ],
          ),
          Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              endIndent: 2,
              indent: 2),
        ],
      ),
    );
  }

  Future getCouponList() async {
    try {
      var url = Uri.parse(Config.baseurl + Config.couponlist);
      var request = await http.get(url, headers: ApiWrapper.headers);
      var response = jsonDecode(request.body);

      if (request.statusCode == 200) {
        return response["couponlist"];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exeption----- $e");
    }
  }

  Future couponCheckApi(user) async {
    var data = {"cid": user["id"], "uid": uID};
    print(data);
    ApiWrapper.dataPost(Config.checkcoupon, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          Get.back(result: user);
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}

Widget loading({double? size}) {
  return const CircularProgressIndicator(color: Color(0xff5669ff));
}
