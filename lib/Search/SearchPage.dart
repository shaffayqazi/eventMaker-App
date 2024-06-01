// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_is_empty

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//! Done
class SearchPage extends StatefulWidget {
  final String? type;
  const SearchPage({Key? key, this.type}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ColorNotifire notifire;

  List eventAllList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    eventSearchApi("a");
    getdarkmodepreviousstate();
  }

  eventSearchApi(String? val) {
    isLoading = true;
    setState(() {});
    var data = {"title": val, "uid": uID};
    print(data);
    ApiWrapper.dataPost(Config.eventSearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventAllList = val["SearchData"];
          isLoading = false;
          setState(() {});
          log(val.toString(), name: " Event Search Api :: ");
        } else {
          isLoading = false;
          setState(() {});
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
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
    Future.delayed(const Duration(seconds: 0), () => setState(() {}));
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: Column(
        children: [
          Container(
            height: Get.height * 0.15,
            width: Get.width,
            decoration: BoxDecoration(
                color: notifire.gettopcolor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 08),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.05),
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.type == "0"
                            ? InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 26),
                              )
                            : const SizedBox(),
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Gilroy Medium',
                          ),
                        ),
                        const SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.008),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Image.asset("image/search.png", height: height / 30),
                        SizedBox(width: width / 90),
                        Container(
                            width: 1, height: height / 40, color: Colors.grey),
                        SizedBox(width: width / 90),
                        //! ------ Search TextField -------
                        Container(
                          color: Colors.transparent,
                          height: height / 20,
                          width: width / 1.7,
                          child: TextField(
                            onChanged: (val) {
                              val.length != 0
                                  ? eventSearchApi(val)
                                  : eventSearchApi("a");
                            },
                            style: TextStyle(
                                fontFamily: 'Gilroy Medium',
                                color: Colors.white,
                                fontSize: 15.sp),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Search...",
                              hintStyle: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: const Color(0xffd2d2db),
                                  fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: !isLoading
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: eventAllList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return conference(eventAllList, i);
                    },
                  )
                : isLoadingCircular(),
          ),
        ],
      ),
    );
  }

  Widget conference(event, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(seconds: 1), () {
            Get.to(() => EventsDetails(eid: event[i]["event_id"]),
                duration: Duration.zero);
          });
        },
        child: Card(
          color: notifire.getprimerycolor,
          child: Container(
            width: width,
            decoration: BoxDecoration(
                color: notifire.getprimerycolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
              child: Row(children: [
                Container(
                    width: width / 5,
                    height: height / 8,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: FadeInImage.assetNetwork(
                          fadeInCurve: Curves.easeInCirc,
                          placeholder: "image/skeleton.gif",
                          fit: BoxFit.cover,
                          image: Config.imageURLPath + event[i]["event_img"]),
                    )),
                Column(children: [
                  SizedBox(height: height / 200),
                  Row(
                    children: [
                      SizedBox(width: width / 50),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event[i]["event_sdate"],
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  color: const Color(0xff4A43EC),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(
                              width: Get.width * 0.60,
                              child: Text(
                                event[i]["event_title"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.getdarkscolor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("image/location.png",
                                      height: height / 50),
                                  SizedBox(width: Get.width * 0.01),
                                  SizedBox(
                                    width: Get.width * 0.55,
                                    child: Text(
                                      event[i]["event_address"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                ]),
                          ]),
                    ],
                  ),
                  SizedBox(height: height / 80),
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
