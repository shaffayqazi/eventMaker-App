// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrndingPage extends StatefulWidget {
  final Map? catdata;
  const TrndingPage({Key? key, this.catdata}) : super(key: key);

  @override
  State<TrndingPage> createState() => _TrndingPageState();
}

class _TrndingPageState extends State<TrndingPage> {
  late ColorNotifire notifire;
  List categoryEvent = [];

  @override
  void initState() {
    getdarkmodepreviousstate();
    catEventListApi();
    super.initState();
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

  catEventListApi() {
    var data = {"uid": uID, "cid": widget.catdata!["id"]};
    ApiWrapper.dataPost(Config.catEvent, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          categoryEvent = val["SearchData"];
        } else {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Column(
          children: [
            Container(
              height: Get.height * 0.12,
              width: Get.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          Config.imageURLPath + widget.catdata!["cover_img"]),
                      fit: BoxFit.fill)),
              child: Row(
                children: [
                  SizedBox(width: Get.width / 20),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          color: notifire.getdarkscolor)),
                  SizedBox(width: Get.width / 80),
                  Text(
                    widget.catdata!["title"],
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categoryEvent.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: categoryEvent.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return events(categoryEvent, i);
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height * 0.40),
                              Text("Event List Not Found!",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.getdarkscolor)),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget events(user, i) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => EventsDetails(eid: user[i]["event_id"]),
                duration: Duration.zero);
          },
          child: Card(
            color: notifire.getcardcolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height / 5.5,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent),
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    Config.imageURLPath + user[i]["event_img"],
                                    fit: BoxFit.cover,
                                    height: Get.height / 3.5,
                                    width: Get.width)),
                            Column(
                              children: [
                                SizedBox(height: Get.height / 70),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Text(
                        user[i]["event_title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("image/location.png",
                              height: Get.height / 50),
                          SizedBox(width: Get.width * 0.01),
                          Ink(
                            width: Get.width * 0.77,
                            child: Text(
                              user[i]["event_address"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Gilroy Medium',
                                  fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Row(
                        children: [
                          Row(
                            children: [
                              user[i]["sponsore_list"] != null
                                  ? CircleAvatar(
                                      radius: 16.0,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          Config.imageURLPath +
                                              user[i]["sponsore_list"]
                                                  ["sponsore_img"]),
                                    )
                                  : const Image(
                                      image: AssetImage("image/user.png"),
                                      height: 28),
                              const SizedBox(width: 10),
                              // Text(
                              //   " + 20 Going",
                              //   style: TextStyle(
                              //       color: const Color(0xff5d56f3),
                              //       fontSize: 11.sp,
                              //       fontFamily: 'Gilroy Bold'),
                              // ),
                            ],
                          ),
                          const Spacer(),
                          LikeButton(
                            onTap: (val) {
                              return onLikeButtonTapped(
                                  val, user[i]["event_id"]);
                            },
                            likeBuilder: (bool isLiked) {
                              return user[i]["IS_BOOKMARK"] != 0
                                  ? const Icon(Icons.favorite,
                                      color: Color(0xffF0635A), size: 24)
                                  : const Icon(Icons.favorite_border,
                                      color: Colors.grey, size: 24);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          catEventListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }
}
