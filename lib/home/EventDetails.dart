// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_label, prefer_final_fields, unused_local_variable, curly_braces_in_flow_control_structures

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/ticket.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/media.dart';
import 'package:goevent2/utils/string.dart';
import 'package:like_button/like_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';

// done
class EventsDetails extends StatefulWidget {
  final String? eid;
  const EventsDetails({Key? key, this.eid}) : super(key: key);

  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  // final event = Get.put(HomeController());

  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  var eventData;
  String code = "0";

  List event_gallery = [];
  List event_sponsore = [];
  bool isloading = false;
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
    getPackage();

    eventDetailApi();
    getdarkmodepreviousstate();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  eventDetailApi() {
    int userCount = 0;
    isloading = true;

    var data = {"eid": widget.eid, "uid": uID};
    ApiWrapper.dataPost(Config.eventdataApi, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            eventData = e;
          });
          event_gallery = val["Event_gallery"];
          event_sponsore = val[""];
          eventData["member_list"]!.forEach((e) {
            _images.add(Config.imageURLPath + e);
          });
          for (var i = 0; i < val[""].length; i++)
            userCount =
                int.parse(val["EventData"][i][""].toString()) >
                        3
                    ? 3
                    : int.parse(
                        val["EventData"][i]["total_member_list"].toString());
          for (var i = 0; i < userCount; i++) {
            _images.add(Config.userImage);
          }
          isloading = false;
          setState(() {});
        } else {
          isloading = false;
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

//! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventDetailApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  List<String> _images = [];
  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 0), () {
    //   setState(() {});
    // });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(builder: (context, child) {
      return Scaffold(
        backgroundColor: notifire.getprimerycolor,
        //! ------ Buy Ticket button -----
        floatingActionButton: SizedBox(
          height: 45.h,
          width: 410.w,
          child: !isloading
              ? FloatingActionButton(
                  onPressed: () {
                    Get.to(() => Ticket(eid: eventData["event_id"]),
                        duration: Duration.zero);
                  },
                  child: Custombutton.button(
                    notifire.getbuttonscolor,
                    CustomStrings.buy +
                        "\$" +
                        "${eventData != null ? eventData["ticket_price"] : ""}",
                    SizedBox(width: width / 10),
                    SizedBox(width: width / 15),
                  ),
                )
              : const SizedBox(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: !isloading
            ? Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(height: Get.height * 0.01),
                      CarouselSlider(
                        options: CarouselOptions(height: height / 4),
                        items: eventData != null
                            ? eventData["event_cover_img"].map<Widget>((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: Get.width,
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      child: FadeInImage.assetNetwork(
                                          fadeInCurve: Curves.easeInCirc,
                                          placeholder: "image/skeleton.gif",
                                          fit: BoxFit.cover,
                                          image: Config.imageURLPath + i),
                                      // Image.network(
                                      //     Config.imageURLPath + i,
                                      //     fit: BoxFit.cover),
                                    );
                                  },
                                );
                              }).toList()
                            : [].map<Widget>((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width: 100,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1),
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                        child: Image.network(
                                            Config.imageURLPath + i,
                                            fit: BoxFit.fill));
                                  },
                                );
                              }).toList(),
                        // ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: height / 20),
                          //! ------- Appbar ------
                          Row(
                            children: [
                              SizedBox(width: width / 20),
                              GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.white)),
                              SizedBox(width: width / 80),
                              Text(
                                CustomStrings.events,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: LikeButton(
                                    onTap: (val) {
                                      return onLikeButtonTapped(
                                          val, eventData["event_id"]);
                                    },
                                    likeBuilder: (bool isLiked) {
                                      return eventData["IS_BOOKMARK"] != 0
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
                              const SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(height: height / 8.5),
                          //! ----- invite button & image -------
                          SizedBox(
                            width: width / 1.4,
                            height: height / 14,
                            child: Card(
                              color: notifire.getprimerycolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Row(
                                mainAxisAlignment:
                                    eventData["total_member_list"] != "0"
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: Get.width * 0.01),
                                  eventData["total_member_list"] != "0"
                                      ? FlutterImageStack(
                                          totalCount: 0,
                                          itemRadius: 30,
                                          itemCount: 3,
                                          itemBorderWidth: 1.5,
                                          imageList: _images)
                                      : const SizedBox(),
                                  SizedBox(width: Get.width * 0.01),
                                  eventData["total_member_list"] != "0"
                                      ? Text(
                                          "${eventData["total_member_list"]} + Going",
                                          style: TextStyle(
                                              color: const Color(0xff5d56f3),
                                              fontSize: 12.sp,
                                              fontFamily: 'Gilroy Bold'),
                                        )
                                      : const SizedBox(),
                                  eventData["total_member_list"] != "0"
                                      ? SizedBox(width: width / 14)
                                      : const SizedBox(),
                                  InkWell(
                                    onTap: share,
                                    child: Container(
                                      height: height / 29,
                                      width: width / 6,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff5669ff),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Center(
                                        child: Text("Invite",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontFamily: 'Gilroy Bold')),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height / 90),

                  //! ------- international  ------
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SizedBox(
                              width: Get.width * 0.90,
                              child: Text(
                                eventData["event_title"] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.getdarkscolor),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 50),
                          concert(
                              "image/date.png",
                              eventData["event_sdate"] ?? "",
                              eventData["event_time_day"] ?? ""),
                          SizedBox(height: height / 50),
                          concert(
                              "image/direction.png",
                              eventData["event_address_title"] ?? "",
                              eventData["event_address"] ?? ""),
                          SizedBox(height: height / 60),

                          //! -------- Event_sponsore List ------
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: event_sponsore.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              return sponserList(event_sponsore, i);
                            },
                          ),

                          SizedBox(height: height / 50),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text("About Event",
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Gilroy Medium',
                                        color: notifire.getdarkscolor)),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 40),
                          //! About Event
                          Ink(
                            width: Get.width * 0.97,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: HtmlWidget(
                                  eventData["event_about"] ?? "",
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: notifire.getdarkscolor,
                                      fontSize: 12.sp,
                                      fontFamily: 'Gilroy Medium'),
                                )),
                          ),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: height / 50)
                              : const SizedBox(),
                          event_gallery.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Text("Gallery",
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Gilroy Medium',
                                              color: notifire.getdarkscolor)),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: height / 40)
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Ink(
                              height: Get.height * 0.14,
                              width: Get.width,
                              child: ListView.builder(
                                itemCount: event_gallery.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return galeryEvent(event_gallery, i);
                                },
                              ),
                            ),
                          ),
                          event_gallery.isNotEmpty
                              ? SizedBox(height: Get.height * 0.10)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : isLoadingCircular(),
      );
    });
  }

  galeryEvent(gEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: Get.width * 0.28,
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
                image: NetworkImage(Config.imageURLPath + gEvent[i]),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget concert(img, name1, name2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Container(
            height: height / 15,
            width: width / 7,
            decoration: BoxDecoration(
                color: notifire.getcardcolor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: const EdgeInsets.all(8), child: Image.asset(img))),
        SizedBox(width: width / 40),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name1,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor)),
          SizedBox(height: height / 300),
          Ink(
            width: Get.width * 0.705,
            child: Text(name2,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy Medium',
                    color: Colors.grey)),
          ),
        ])
      ]),
    );
  }

  sponserList(eventSponsore, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: GestureDetector(
        onTap: () {
          // Get.to(() => const Organize());
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.025),
                child: Container(
                  height: Get.height * 0.05,
                  width: Get.width * 0.11,
                  decoration: BoxDecoration(
                      color: notifire.getcardcolor,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      image: DecorationImage(
                          image: NetworkImage(Config.imageURLPath +
                              eventSponsore[i]["sponsore_img"]),
                          fit: BoxFit.fill)),
                  // child: CircleAvatar(
                  //   radius: 20,
                  //   child: Image.network(
                  //     Config.imageURLPath + eventSponsore[i]["sponsore_img"],
                  //     fit: BoxFit.fill,
                  //   ),
                  // )
                ),
              ),
              SizedBox(width: width / 38),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ink(
                    width: Get.width * 0.70,
                    child: Text(eventSponsore[i]["sponsore_title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getdarkscolor)),
                  ),
                  SizedBox(height: height / 300),
                  Text("Organizer",
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy Medium',
                          color: Colors.grey)),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
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
