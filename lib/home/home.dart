// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, unused_local_variable, unused_import, unnecessary_null_comparison, prefer_final_fields

import 'dart:async';
import '../utils/media.dart';
import 'package:get/get.dart';

import '../utils/colornotifire.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:goevent2/Api/Config.dart';
import 'package:provider/provider.dart';

import 'package:goevent2/home/seeall.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/color.dart';
import '../notification/notification.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goevent2/utils/string.dart';
import 'package:like_button/like_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/Search/SearchPage.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:goevent2/home/TrendingCatPage.dart';

import 'package:goevent2/Controller/AuthController.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';

final getData = GetStorage();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final x = Get.put(AuthController());
  final hData = Get.put(HomeController());
  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  bool isChecked = false;
  String code = "0";

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
    walletrefar();
    getdarkmodepreviousstate();
    getUserLocation();
    getPackage();
    getData.read("UserLogin") != null
        ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
        : null;
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(Config.oneSignel);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("Accepted OSPermissionStateChanges : $changes");
    });
    print("--------------__uID : ${getData.read("UserLogin")["id"]}");
    await OneSignal.shared.sendTag("storeid", getData.read("UserLogin")["id"]);
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  getUserLocation() async {
    Position position = await getLatLong();

    lat = position.longitude.toString();
    long = position.latitude.toString();
    setState(() {});
  }

  Future<Position> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

//! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          hData.homeDataReffressApi(getData.read("UserLogin")["id"], lat, long);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
          backgroundColor: notifire.getprimerycolor,
          body: Column(
            children: [
              //! ------ Home AppBar ------
              homeAppbar(),
              Expanded(
                child: SingleChildScrollView(
                  child: !hData.isLoading
                      ? Column(
                          children: [
                            SizedBox(height: height / 60),
                            //! ----- trending Event List ------
                            SizedBox(height: height / 80),
                            hData.catlist.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SizedBox(
                                      height: Get.height * 0.05,
                                      child: ListView.builder(
                                        itemCount: hData
                                            .homeDataList["Catlist"].length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, i) {
                                          var catlist =
                                              hData.homeDataList["Catlist"];
                                          return treding(catlist, i);
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: Get.height * 0.03),
                            hData.trendingEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text(CustomStrings.trending,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Bold',
                                                color: notifire.getdarkscolor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title:
                                                        CustomStrings.trending,
                                                    eventList:
                                                        hData.trendingEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text(CustomStrings.seeall,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: Get.height * 0.03),
                            //! --------- trndingList ---------
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SizedBox(
                                height: Get.height * 0.28,
                                child: ListView.builder(
                                  itemCount: hData.trendingEvent.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    return tredingEvents(
                                        hData.trendingEvent, i);
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: height / 60),
                            //! ---------- upcoming Events --------

                            hData.upcomingEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text(CustomStrings.upcoming,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Bold',
                                                color: notifire.getdarkscolor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title:
                                                        CustomStrings.upcoming,
                                                    eventList:
                                                        hData.upcomingEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text(CustomStrings.seeall,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),

                            SizedBox(height: height / 60),
                            //! ----------- Upcoming Events List -------------
                            Ink(
                              height: Get.height * 0.37,
                              child: ListView.builder(
                                itemCount: hData.upcomingEvent.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return events(hData.upcomingEvent[i], i);
                                },
                              ),
                            ),

                            SizedBox(height: height / 60),
                            //! --------- invite share -----------
                            InkWell(
                              onTap: share,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: notifire.getorangecolor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: height / 6,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              CustomStrings.invites,
                                              style: TextStyle(
                                                  fontFamily: 'Gilroy Medium',
                                                  color: notifire.getdarkscolor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(height: Get.height * 0.01),
                                            Text(
                                              CustomStrings.get,
                                              style: TextStyle(
                                                  fontFamily: 'Gilroy Medium',
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: Get.height * 0.01),
                                            GestureDetector(
                                              onTap: openBottomSheet,
                                              child: Container(
                                                height: height / 30,
                                                width: width / 6,
                                                decoration: BoxDecoration(
                                                    color:
                                                        notifire.getbluecolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Center(
                                                  child: Text(
                                                    CustomStrings.invite,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset("image/invite.png",
                                          height: height / 6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height / 60),
                            //! -------- Nearby You Listview  --------
                            hData.nearbyEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Nearby You",
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Bold',
                                              color: notifire.getdarkscolor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title: "Nearby You",
                                                    eventList:
                                                        hData.nearbyEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text("See All",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: height / 70),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: hData.nearbyEvent.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) {
                                return conference(hData.nearbyEvent, i);
                              },
                            ),

                            SizedBox(height: height / 60),

                            hData.thisMonthEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text("Event This Month",
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Bold',
                                                color: notifire.getdarkscolor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title: "Event This Month",
                                                    eventList:
                                                        hData.thisMonthEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text("See All",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            //! monthly event
                            ListView.builder(
                              itemCount: hData.thisMonthEvent.length,
                              padding: const EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) {
                                return monthly(hData.thisMonthEvent, i);
                              },
                            ),
                          ],
                        )
                      : isLoadingCircular(),
                ),
              )
            ],
          )),
    );
  }

  treding(catList, i) {
    return InkWell(
      onTap: () {
        Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
              color: notifire.getprimerycolor,
              border: Border.all(color: Colors.grey.shade400, width: 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Row(
              children: [
                Image(
                    image: NetworkImage(
                        Config.imageURLPath + catList[i]["cat_img"]),
                    height: 30),
                SizedBox(width: Get.width * 0.02),
                Text(catList[i]["title"],
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imgloading() {
    return Container(
      height: Get.height * 0.20,
      width: Get.width * 0.62,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("image/skeleton.gif"), fit: BoxFit.fill)),
    );
  }

  tredingEvents(tEvent, i) {
    return InkWell(
      onTap: () {
        Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: Get.width * 0.60,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  height: Get.height * 0.20,
                  width: Get.width * 0.62,
                  child: FadeInImage.assetNetwork(
                      fadeInCurve: Curves.easeInCirc,
                      placeholder: "image/skeleton.gif",
                      fit: BoxFit.cover,
                      image: Config.imageURLPath + tEvent[i]["event_img"]),
                ),
              ),
              Positioned(
                top: 8,
                right: Get.width * 0.02,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: LikeButton(
                      onTap: (val) {
                        return onLikeButtonTapped(val, tEvent[i]["event_id"]);
                      },
                      likeBuilder: (bool isLiked) {
                        return tEvent[i]["IS_BOOKMARK"] != 0
                            ? const Icon(Icons.favorite,
                                color: Color(0xffF0635A), size: 22)
                            : const Icon(Icons.favorite_border,
                                color: Color(0xffF0635A), size: 22);
                      },
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Get.height * 0.12,
                    width: Get.width * 0.56,
                    decoration: BoxDecoration(
                        color: notifire.getprimerycolor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.01),
                          Ink(
                            width: Get.width * 0.50,
                            child: Text(tEvent[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.getdarkscolor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: Get.height * 0.006),
                          Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 50),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.45,
                                child: Text(tEvent[i]["event_address"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 14.sp)),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.008),
                          Row(
                            children: [
                              tEvent[i]["sponsore_list"] != null
                                  ? CircleAvatar(
                                      radius: 16.0,
                                      backgroundImage: NetworkImage(
                                          Config.imageURLPath +
                                              tEvent[i]["sponsore_list"]
                                                  ["sponsore_img"]),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const SizedBox(),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                "Sponser",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.grey,
                                    fontSize: 14.sp),
                              ),
                              const Spacer(),
                              Container(
                                height: Get.height * 0.04,
                                width: Get.width * 0.20,
                                decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Join",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Bold',
                                        color: Colors.white,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  homeAppbar() {
    return Container(
      decoration: BoxDecoration(
          color: notifire.gettopcolor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      height: Get.height * 0.18,
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.055),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  height: Get.height * 0.06,
                  color: Colors.transparent,
                  child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset("image/logo.png")),
                ),
                SizedBox(width: width / 4.8),
                Column(
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'Gilroy Medium',
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      getData.read("CurentAdd") ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'Gilroy Medium',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    //! ------ Notification Page -----
                    Get.to(() => const Note(), duration: Duration.zero);
                  },
                  child: Image.asset("image/bell.png", height: height / 20),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: InkWell(
              onTap: () {
                Get.to(() => const SearchPage(type: "0"));
              },
              child: Row(
                children: [
                  Image.asset("image/search.png", height: height / 30),
                  SizedBox(width: width / 90),
                  Container(width: 1, height: height / 40, color: Colors.grey),
                  SizedBox(width: width / 90),
                  //! ------ Search TextField -------
                  Text(
                    "Search...",
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: const Color(0xffd2d2db),
                        fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _mImages = [];

  Widget monthly(mEvent, i) {
    _mImages.clear();
    mEvent[i]["member_list"].forEach((e) {
      _mImages.add(Config.imageURLPath + e);
    });
    int mEventcount = int.parse(mEvent[i]["total_member_list"].toString()) > 3
        ? 3
        : int.parse(mEvent[i]["total_member_list"].toString());
    for (var i = 0; i < mEventcount; i++) {
      _mImages.add(Config.userImage);
    }
    return GestureDetector(
      onTap: () {
        // hData.eventDetailApi(mEvent[i]["event_id"]);
        // Get.to(() => const EventsDetails());
        Get.to(() => EventsDetails(eid: mEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Card(
          color: notifire.getprimerycolor,
          child: Container(
            decoration: BoxDecoration(
                color: notifire.getprimerycolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            height: height / 6.5,
            width: width,
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 5, top: 5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: SizedBox(
                              width: width / 5,
                              height: height / 8,
                              child: FadeInImage.assetNetwork(
                                  fadeInCurve: Curves.easeInCirc,
                                  placeholder: "image/skeleton.gif",
                                  fit: BoxFit.cover,
                                  image: Config.imageURLPath +
                                      mEvent[i]["event_img"]),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.45,
                                child: Text(
                                  mEvent[i]["event_title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.getdarkscolor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: height / 100),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("image/location.png",
                                      height: height / 50),
                                  SizedBox(width: Get.width * 0.01),
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Text(
                                      mEvent[i]["event_address"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 100),
                              mEvent[i]["total_member_list"] != "0"
                                  ? Row(
                                      children: [
                                        // _mImages.isNotEmpty
                                        //     ?
                                        FlutterImageStack(
                                          totalCount: 0,
                                          itemRadius: 30,
                                          itemCount: 3,
                                          itemBorderWidth: 1.5,
                                          imageList: _mImages,
                                        ),
                                        // : const Image(
                                        //     image: AssetImage(
                                        //         "image/user.png"),
                                        //     height: 28),
                                        SizedBox(width: Get.width * 0.01),
                                        Text(
                                            "${mEvent[i]["total_member_list"]} + Joined",
                                            style: TextStyle(
                                              color: const Color(0xffF0635A),
                                              fontSize: 12.sp,
                                              fontFamily: 'Gilroy Bold',
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(height: height / 80)
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(height: height / 80),
                    Container(
                      decoration: BoxDecoration(
                          color: notifire.getpinkcolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      height: height / 12,
                      width: width / 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              width: width / 11,
                              child: Text(
                                mEvent[i]["event_sdate"],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: 14.sp,
                                    fontFamily: 'Gilroy Bold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width / 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rights(se, name1, name, img, txtcolor, ce) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img, height: height / 15),
        SizedBox(width: width / 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name1,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Bold',
                  color: txtcolor),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Gilroy Normal',
                  color: Colors.grey),
            ),
          ],
        ),
        se,
        ce
      ],
    );
  }

  Widget conference(nearby, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() => EventsDetails(eid: nearby[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Card(
          color: notifire.getprimerycolor,
          child: Container(
            decoration: BoxDecoration(
                color: notifire.getprimerycolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            height: height / 7,
            width: width,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
              child: Row(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: SizedBox(
                    width: width / 5,
                    height: height / 8,
                    child: FadeInImage.assetNetwork(
                        fadeInCurve: Curves.easeInCirc,
                        placeholder: "image/skeleton.gif",
                        fit: BoxFit.cover,
                        image: Config.imageURLPath + nearby[i]["event_img"]),
                  ),
                ),
                Column(children: [
                  SizedBox(height: height / 200),
                  Row(
                    children: [
                      SizedBox(width: width / 50),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.35,
                                  child: Text(
                                    nearby[i]["event_sdate"],
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: const Color(0xff4A43EC),
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(width: width / 5),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: LikeButton(
                                      onTap: (val) {
                                        return onLikeButtonTapped(
                                            val, nearby[i]["event_id"]);
                                      },
                                      likeBuilder: (bool isLiked) {
                                        return nearby[i]["IS_BOOKMARK"] != 0
                                            ? const Icon(Icons.favorite,
                                                color: Color(0xffF0635A),
                                                size: 22)
                                            : const Icon(Icons.favorite_border,
                                                color: Color(0xffF0635A),
                                                size: 22);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Get.width * 0.55,
                              child: Text(nearby[i]["event_title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.getdarkscolor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(height: height / 200),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("image/location.png",
                                      height: height / 50),
                                  SizedBox(width: Get.width * 0.01),
                                  SizedBox(
                                    width: Get.width * 0.56,
                                    child: Text(
                                      nearby[i]["event_address"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 10.sp),
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

  List<String> upMember = [];
  Widget events(upEvent, i) {
    upMember.clear();
    upEvent["member_list"].forEach((e) {
      upMember.add(Config.imageURLPath + e);
    });
    int membercount = int.parse(upEvent["total_member_list"].toString()) > 3
        ? 3
        : int.parse(upEvent["total_member_list"].toString());
    for (var i = 0; i < membercount; i++) {
      upMember.add(Config.userImage);
    }
    return Stack(children: [
      InkWell(
        onTap: () {
          Get.to(() => EventsDetails(eid: upEvent["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          color: notifire.getprimerycolor,
          width: width / 1.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height / 5.5,
                    width: width / 1.7,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.transparent),
                    child: Stack(
                      children: [
                        //! Event Image
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: SizedBox(
                            height: Get.height * 0.20,
                            width: Get.width * 0.62,
                            child: FadeInImage.assetNetwork(
                                fadeInCurve: Curves.easeInCirc,
                                placeholder: "image/skeleton.gif",
                                fit: BoxFit.cover,
                                image:
                                    Config.imageURLPath + upEvent["event_img"]),
                          ),
                        ),

                        Column(
                          children: [
                            SizedBox(height: height / 70),
                            Row(
                              children: [
                                SizedBox(width: width / 70),
                                const Spacer(),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: LikeButton(
                                      onTap: (val) {
                                        return onLikeButtonTapped(
                                            val, upEvent["event_id"]);
                                      },
                                      likeBuilder: (bool isLiked) {
                                        return upEvent["IS_BOOKMARK"] != 0
                                            ? const Icon(Icons.favorite,
                                                color: Color(0xffF0635A),
                                                size: 22)
                                            : const Icon(Icons.favorite_border,
                                                color: Color(0xffF0635A),
                                                size: 22);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 40),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height / 40),
                  SizedBox(
                    width: Get.width,
                    child: Text(
                      upEvent["event_title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: height / 140),
                  upEvent["total_member_list"] != "0"
                      ? Row(
                          children: [
                            upEvent["total_member_list"] != "0"
                                ? FlutterImageStack(
                                    totalCount: 0,
                                    itemRadius: 30,
                                    itemBorderWidth: 1.5,
                                    imageList: upMember)
                                : const Image(
                                    image: AssetImage("image/user.png"),
                                    height: 28),
                            SizedBox(width: Get.width * 0.01),
                            Text(
                              "${upEvent["total_member_list"]} + Going",
                              style: TextStyle(
                                  color: const Color(0xff5d56f3),
                                  fontSize: 11.sp,
                                  fontFamily: 'Gilroy Bold'),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(height: height / 60),
                  Row(
                    children: [
                      Image.asset("image/location.png", height: height / 50),
                      SizedBox(width: Get.width * 0.01),
                      SizedBox(
                        width: Get.width * 0.52,
                        child: Text(
                          upEvent["event_address"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Gilroy Medium',
                              color: Colors.grey,
                              fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: height / 6),
                  Row(children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: notifire.getprimerycolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      height: height / 30,
                      width: Get.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 4,
                            child: Center(
                              child: Text(
                                upEvent["event_sdate"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: const Color(0xffF0635A),
                                    fontSize: 11.sp,
                                    fontFamily: 'Gilroy ExtraBold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width / 40),
                  ]),
                ],
              ),
            ]),
          ),
        ),
      ),
    ]);
  }

  openBottomSheet() {
    return showModalBottomSheet<dynamic>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: notifire.getcardcolor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                height: Get.height * 0.70,
                child: Column(
                  children: [
                    SizedBox(height: height / 80),
                    Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: MediaQuery.of(context).size.height / 80,
                        width: MediaQuery.of(context).size.width / 7),
                    SizedBox(height: height / 80),
                    Container(
                      color: Colors.transparent,
                      height: 45.h,
                      width: 300.w,
                      child: TextField(
                        style: TextStyle(
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getdarkscolor),
                        decoration: InputDecoration(
                            labelText: CustomStrings.search,
                            labelStyle: const TextStyle(
                                fontFamily: 'Gilroy Medium',
                                color: Colors.grey),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.sp)),
                            suffixIcon: Padding(
                                padding: const EdgeInsets.all(17),
                                child: Image.asset("image/search2.png")),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.sp)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xff80818d), width: 1),
                                borderRadius: BorderRadius.circular(20.sp)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xff5669FF), width: 1),
                                borderRadius: BorderRadius.circular(20.sp))),
                      ),
                    ),
                    SizedBox(height: height / 80),
                    Expanded(
                      child: SizedBox(
                        width: Get.width * 0.90,
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            return rights(
                              SizedBox(width: width / 2.9),
                              "Angelina Zolly",
                              "2k Followers",
                              "image/p1.png",
                              notifire.gettextcolor,
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  child: Container(
                                      height: height / 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isChecked
                                              ? notifire.getbuttonscolor
                                              : notifire.getpinkcolor),
                                      child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child:
                                                Image.asset("image/right.png")),
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height / 70),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $code & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }

  walletrefar() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.refardata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
        } else {
          setState(() {});
        }
      }
    });
  }
}
