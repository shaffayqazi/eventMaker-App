// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Homepage.dart';
import 'package:goevent2/home/MapPage.dart';
import 'package:goevent2/payment/finalticket.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';

class Booking extends StatefulWidget {
  final String? tID;
  const Booking({Key? key, this.tID}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late ColorNotifire notifire;
  var eventData;
  List event_gallery = [];
  List event_sponsore = [];
  List<String> member = [];
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
    bookTicketApi();
  }

  bookTicketApi() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID, "tid": widget.tID};
    ApiWrapper.dataPost(Config.bookticket, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Ticket Preview");
          eventData = val["EventData"];

          event_gallery = val[""];
          event_sponsore = val["Event_sponsore"];
          // member = val["Member"];
          // int membercount = int.parse(val["Member"].length.toString()) > 5
          //     ? 5
          //     : int.parse(val["Member"].length.toString());

          for (var i = 0; i < val["Member"].length; i++) {
            member.add(Config.userImage);
          }
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
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
        //! Message Bootam sheet
        floatingActionButton: SizedBox(
          height: 45.h,
          width: 410.w,
          child: FloatingActionButton(
              onPressed: () {
                Get.to(() => const Bottombar());
              },
              child: Custombutton.button(
                  notifire.getbuttonscolor,
                  "Buy More Ticket",
                  SizedBox(width: width / 7.0),
                  SizedBox(width: width / 8))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: !isLoading
              ? Column(
                  children: [
                    Stack(
                      children: [
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
                                          child: Image.network(
                                              Config.imageURLPath + i,
                                              fit: BoxFit.cover));
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
                            //! -------- AppBar -------
                            Row(
                              children: [
                                SizedBox(width: width / 20),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back,
                                        color: Colors.white)),
                                SizedBox(width: width / 80),
                                Text("My Booking",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: height / 10),
                            //! ----------- Call Direction My Ticket Button ---------
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.05),
                              child: Card(
                                color: notifire.getcardcolor,
                                elevation: 2,
                                shadowColor: notifire.getcardcolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    rowBooking(
                                        title: eventData != null
                                            ? eventData["ticket_type"]
                                            : "",
                                        image: "image/fire.png",
                                        onTap: () {}),
                                    rowBooking(
                                        title: CustomStrings.dire,
                                        image: "image/Directions.png",
                                        onTap: () async {
                                          Get.to(() => DirectionPage(
                                              lastLatLng: LatLng(
                                                  double.parse(eventData[
                                                          "event_latitude"]
                                                      .toString()),
                                                  double.parse(eventData[
                                                          "event_longtitude"]
                                                      .toString())),
                                              etitle:
                                                  eventData["event_title"]));
                                        }),
                                    rowBooking(
                                        title: CustomStrings.ticket,
                                        image: "image/Ticket.png",
                                        onTap: () async {
                                          Get.to(() => Final(tID: widget.tID),
                                              duration: Duration.zero);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height / 30),
                    //! title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        eventData != null ? eventData["event_title"] : "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.getdarkscolor),
                      ),
                    ),
                    SizedBox(height: height / 40),
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

                    SizedBox(height: height / 40),
                    concert(
                        "image/date.png",
                        eventData != null ? eventData["event_sdate"] : "",
                        eventData != null ? eventData["event_time_day"] : ""),
                    SizedBox(height: height / 50),
                    concert(
                        "image/direction.png",
                        eventData != null
                            ? eventData["event_address_title"]
                            : "",
                        eventData != null ? eventData["event_address"] : ""),
                    member.isNotEmpty
                        ? SizedBox(height: height / 40)
                        : const SizedBox(),
                    //!--------- Members Image --------
                    member.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Members",
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Gilroy Medium',
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    member.isNotEmpty
                        ? SizedBox(height: height / 60)
                        : const SizedBox(),

                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          member.isNotEmpty
                              ? FlutterImageStack(
                                  totalCount: 0,
                                  itemRadius: 34,
                                  itemCount: 5,
                                  itemBorderWidth: 1.5,
                                  imageList: member)
                              : const SizedBox(),
                          SizedBox(width: Get.width * 0.01),
                          member.isNotEmpty
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundColor: notifire.getbuttonscolor,
                                  child: Text("+${member.length}",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.white)),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),

                    //  Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 24),
                    //         child: Ink(
                    //           height: Get.height * 0.05,
                    //           child: ListView.builder(
                    //             padding: EdgeInsets.zero,
                    //             itemCount:
                    //                 member.length < 3 ? member.length : 3,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             itemBuilder: (ctx, i) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 4),
                    //                 child: Container(
                    //                   height: Get.height * 0.05,
                    //                   width: Get.width * 0.11,
                    //                   decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           const BorderRadius.all(
                    //                               Radius.circular(50)),
                    //                       image: DecorationImage(
                    //                           image: NetworkImage(
                    //                               Config.imageURLPath +
                    //                                   member[i]),
                    //                           fit: BoxFit.cover)),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //       member.isNotEmpty
                    //           ? CircleAvatar(
                    //               radius: 24,
                    //               backgroundColor: notifire.getbuttonscolor,
                    //               child: Text("+${member.length}",
                    //                   style: TextStyle(
                    //                       fontSize: 15.sp,
                    //                       fontWeight: FontWeight.w700,
                    //                       fontFamily: 'Gilroy Medium',
                    //                       color: Colors.white)),
                    //             )
                    //           : const SizedBox(),
                    //       Container(),
                    //       Container(),
                    //       Container(),
                    //       Container(),
                    //     ],
                    //   )
                    // : const SizedBox(),
                    SizedBox(height: height / 60),
                    //! ------- About Event -------
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            "About Event",
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Gilroy Medium',
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 40),
                    Container(
                      width: Get.width * 0.97,
                      color: Colors.transparent,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: HtmlWidget(
                              eventData != null ? eventData["event_about"] : "",
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: notifire.getdarkscolor,
                                  fontSize: 12.sp,
                                  fontFamily: 'Gilroy Medium'))),
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
                                        color: notifire.gettextcolor)),
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
                        ? SizedBox(height: Get.height * 0.12)
                        : const SizedBox(),
                  ],
                )
              : isLoadingCircular(),
        ),
      ),
    );
  }

  galeryEvent(gEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: Get.width * 0.28,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: NetworkImage(Config.imageURLPath + gEvent[i]),
                fit: BoxFit.cover)),
      ),
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
                          fit: BoxFit.cover)),
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

  rowBooking({Function()? onTap, String? image, title}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notifire.getcardcolor,
        child: Column(
          children: [
            SizedBox(height: height / 100),
            Image.asset(image!, height: height / 18),
            const SizedBox(height: 4),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.getdarkscolor)),
            SizedBox(height: height / 100),
          ],
        ),
      ),
    );
  }
}
