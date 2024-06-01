// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';

import 'package:goevent2/utils/AppWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  late ColorNotifire notifire;
  List notificationList = [];
  bool isLoading = false;

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
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    notificationListApi();
  }

  notificationListApis() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID};
    ApiWrapper.dataPost(Config.notification, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          notificationList = val["NotificationData"];

          setState(() {});
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
        }
      }
    });
  }

  Future notificationListApi() async {
    var data = {"uid": uID};
    try {
      var url = Uri.parse(Config.baseurl + Config.notification);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);

      if (request.statusCode == 200) {
        return response["NotificationData"];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Exeption----- $e");
    }
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "m" : "m"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "week"}";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "day"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "h" : "h"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "min"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          color: notifire.getdarkscolor)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    CustomStrings.notification,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor),
                  ),
                ),
                const SizedBox(),
              ],
            ),
            SizedBox(height: height / 40),
            FutureBuilder(
                future: notificationListApi(),
                builder: (ctx, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    var notif = snap.data;

                    return notif.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height * 0.26),
                              Image(
                                  image: const AssetImage("image/56.png"),
                                  height: Get.height * 0.14),
                              SizedBox(height: Get.height * 0.02),
                              Center(
                                child: Text("No New Notifications",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: notifire.gettextcolor,
                                      fontSize: 16.sp,
                                      fontFamily: 'Gilroy Bold',
                                    )),
                              ),
                              SizedBox(height: Get.height * 0.02),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: notif.length,
                            itemBuilder: (context, i) {
                              var notific = notif.reversed.toList();
                              DateTime tempDate =
                                  DateFormat("yyyy-MM-dd hh:mm:ss")
                                      .parse(notific[i]["datetime"]);
                              return notificationslist(
                                title: notific[i]["title"],
                                discription: notific[i]["description"],
                                time: timeAgo(tempDate),
                              );
                            },
                          );
                  } else {
                    return isLoadingCircular();
                  }
                }),
            SizedBox(height: height / 100),
          ],
        ),
      ),
    );
  }

  Widget notificationslist({String? title, String? discription, String? time}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 30),
      child: Column(
        children: [
          SizedBox(height: height / 100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Image.asset("image/Notification2.png",
                      height: height / 34)),
              SizedBox(width: width / 30),
              Container(
                width: width / 1.8,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title!,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontFamily: 'Gilroy_Bold',
                            fontSize: height / 55)),
                    SizedBox(height: height / 200),
                    Text(discription!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.8),
                            fontFamily: 'Gilroy_Medium',
                            fontSize: height / 60)),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                time!,
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontFamily: 'Gilroy_Medium',
                    fontSize: height / 60),
              ),
            ],
          ),
          SizedBox(height: height / 100),
          const Divider(thickness: 0.6),
        ],
      ),
    );
  }
}
