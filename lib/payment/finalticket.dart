// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/booking/booking.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

//   Done
class Final extends StatefulWidget {
  final String? tID;
  const Final({Key? key, this.tID}) : super(key: key);

  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> {
  late ColorNotifire notifire;
  Map ticketData = {};
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
    previewticket();
    getdarkmodepreviousstate();
  }

  previewticket() {
    setState(() {
      isLoading = true;
    });
    var data = {"tid": widget.tID, "uid": uID};
    ApiWrapper.dataPost(Config.ticketpreview, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Ticket Preview");
          ticketData = val["TicketData"];
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
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getticketcolor,
        //! ----- My Booking button  -----
        floatingActionButton: SizedBox(
          height: 45.h,
          width: 410.w,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => Booking(tID: widget.tID));
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border:
                        Border.all(color: notifire.getbuttonscolor, width: 2),
                    color: notifire.getprimerycolor),
                height: height / 15,
                width: width / 1.5,
                child: Row(
                  children: [
                    SizedBox(width: width / 5),
                    Text("My Booking",
                        style: TextStyle(
                            color: notifire.getbuttonscolor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600)),
                    SizedBox(width: width / 9),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Image.asset("image/arrow.png")),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            SizedBox(height: height / 20),
            //! ----- AppBar -----

            Row(
              children: [
                SizedBox(width: width / 20),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white)),
                SizedBox(width: width / 80),
                Text("Congratulation !",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: Colors.white)),
              ],
            ),
            SizedBox(height: height / 25),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ticketData.isNotEmpty
                        ? TicketWidget(
                            color: notifire.getcardcolor,
                            width: Get.width * 0.92,
                            height: Get.height * 0.72,
                            isCornerRounded: true,
                            margin: const EdgeInsets.all(6),
                            padding: EdgeInsets.zero,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: height / 25),
                                  ticketData.isNotEmpty
                                      ? Container(
                                          height: height / 4.7,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(Config
                                                          .imageURLPath +
                                                      ticketData["ticket_img"]),
                                                  fit: BoxFit.cover)))
                                      : SizedBox(),
                                  SizedBox(height: height / 40),
                                  Text(
                                      ticketData.isNotEmpty
                                          ? ticketData["ticket_title"]
                                          : "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Gilroy Medium',
                                          color: notifire.getdarkscolor)),
                                  SizedBox(height: height / 40),
                                  SizedBox(width: width / 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ticketText(
                                        title: "NAME",
                                        subtitle: ticketData.isNotEmpty
                                            ? ticketData["ticket_username"]
                                            : "",
                                      ),
                                      SizedBox(height: height / 40),
                                      Row(
                                        children: [
                                          ticketText(
                                            title: "DATE",
                                            subtitle: ticketData.isNotEmpty
                                                ? ticketData["event_sdate"]
                                                : "",
                                          ),
                                          SizedBox(width: width / 5),
                                          ticketText(
                                            title: "TIME",
                                            subtitle: ticketData.isNotEmpty
                                                ? ticketData["start_time"]
                                                : "",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height / 40),
                                      ticketText(
                                        title: "Location",
                                        subtitle: ticketData.isNotEmpty
                                            ? ticketData["event_address_title"]
                                            : "",
                                      ),
                                      SizedBox(height: height / 200),
                                      Text(
                                        ticketData.isNotEmpty
                                            ? ticketData["event_address"]
                                            : "",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy Normal',
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.04),
                                ],
                              ),
                            ),
                          )
                        : CircularProgressIndicator(),
                    SizedBox(height: Get.height * 0.10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ticketText({String? title, subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
        SizedBox(height: height / 200),
        Text(subtitle!,
            style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Gilroy Bold',
                color: notifire.getdarkscolor)),
      ],
    );
  }
}

class OverlapSquare extends StatelessWidget {
  const OverlapSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.1,
      child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: OverflowBox(
              maxHeight: 250,
              maxWidth: 250,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
