// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/booking/booking.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/Images.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetailPage extends StatefulWidget {
  final String? eID;
  const TicketDetailPage({Key? key, this.eID}) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  ScreenshotController screenshotController = ScreenshotController();
  late ColorNotifire notifire;
  Uint8List? capturedImage;
  bool isLoading = false;

  Map ticketData = {};
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

//!------------------------
  @override
  void initState() {
    ticketStatusApi();
    getdarkmodepreviousstate();
    super.initState();
  }

  ticketStatusApi() async {
    setState(() {
      isLoading = true;
    });
    var data = {"tid": widget.eID, "uid": uID};

    ApiWrapper.dataPost(Config.ticketdata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          ticketData = val["TicketData"];
          log(val.toString(), name: "Event Ticket : ");
          setState(() {});
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
        }
      }
    });
  }

  Future saveandShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File("${directory.path}/ticket.jpg");
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      floatingActionButton: SizedBox(
        height: 45.h,
        width: 410.w,
        child: FloatingActionButton(
          onPressed: () {
            screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((capturedImage) async {
              capturedImage = capturedImage;
              log(capturedImage.toString(), name: "Image");
              saveandShare(capturedImage!);
            }).catchError((onError) {});
          },
          child: Custombutton.button(
              notifire.getbuttonscolor,
              "Download Ticket",
              SizedBox(width: width / 6.5),
              SizedBox(width: width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height / 20),
          //! ------- AppBar -------

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
                      "E-Ticket",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => Booking(tID: ticketData["ticket_id"]));
                },
                child: Image(
                    image: const AssetImage(Images.more),
                    color: notifire.getdarkscolor,
                    height: Get.height * 0.025),
              ),
              SizedBox(width: width / 20),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: SingleChildScrollView(
                child: !isLoading
                    ? Container(
                        color: notifire.getprimerycolor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //! barcode add
                              SizedBox(height: Get.height * 0.018),
                              ticketTextRow(
                                  title: "Event",
                                  subtitle: ticketData["ticket_title"]),

                              SizedBox(height: Get.height * 0.018),
                              ticketTextRow(
                                  title: "Date and Hour",
                                  subtitle: ticketData["start_time"]),

                              SizedBox(height: Get.height * 0.018),
                              ticketTextRow(
                                  title: "Event Location",
                                  subtitle: ticketData["event_address"]),

                              SizedBox(height: Get.height * 0.018),
                              ticketTextRow(
                                  title: "Event organizer",
                                  subtitle: ticketData["event_address_title"]),

                              SizedBox(height: Get.height * 0.036),
                              //! ------- User Details --------
                              ticketUserRow(
                                  title: "Full Name",
                                  subtitle: ticketData["ticket_username"]),

                              SizedBox(height: Get.height * 0.018),

                              ticketUserRow(
                                  title: "Phone",
                                  subtitle: ticketData["ticket_mobile"]),

                              SizedBox(height: Get.height * 0.018),
                              ticketUserRow(
                                  title: "Email",
                                  subtitle: ticketData["ticket_email"]),
                              SizedBox(height: Get.height * 0.036),
                              // //! ------- Ticket Price  --------
                              ticketUserRow(
                                  title: "Seats",
                                  subtitle:
                                      "${ticketData["total_ticket"]}x ${ticketData["ticket_type"]}"),
                              SizedBox(height: Get.height * 0.018),
                              ticketUserRow(
                                  title: "Tax",
                                  subtitle:
                                      "${mainData["currency"]}${ticketData["ticket_tax"]}"),
                              SizedBox(height: Get.height * 0.018),
                              ticketData != null
                                  ? ticketData["ticket_wall_amt"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Wallet",
                                                subtitle:
                                                    "${mainData["currency"]}${ticketData["ticket_wall_amt"]}"),
                                            SizedBox(
                                                height: Get.height * 0.018),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              ticketData != null
                                  ? ticketData["ticket_total_amt"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Total",
                                                subtitle:
                                                    "${mainData["currency"]}${ticketData["ticket_total_amt"]}"),
                                            SizedBox(
                                                height: Get.height * 0.036),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              ticketData != null
                                  ? ticketData["ticket_transaction_id"] != "0"
                                      ? Column(
                                          children: [
                                            ticketUserRow(
                                                title: "Transaction ID",
                                                subtitle: ticketData[
                                                    "ticket_transaction_id"]),
                                            SizedBox(
                                                height: Get.height * 0.018),
                                          ],
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),

                              ticketUserRow(
                                  title: "Payment Methods",
                                  subtitle: ticketData["ticket_p_method"]),
                              SizedBox(height: Get.height * 0.018),
                              ticketUserRow(
                                  title: "Status",
                                  subtitle: ticketData["ticket_status"]),
                              SizedBox(height: Get.height * 0.12),
                            ],
                          ),
                        ),
                      )
                    : isLoadingCircular(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ticketUserRow({String? title, subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? "",
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
        Ink(
          width: Get.width * 0.50,
          child: Text(subtitle ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor)),
        ),
      ],
    );
  }

  ticketUserCopy(
      {String? title, subtitle, Widget? textCopy, Function()? OnTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          preferBelow: false,
          message: "Copy",
          child: Text(title!,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Gilroy Medium',
                  color: Colors.grey)),
        ),
        InkWell(
          onTap: OnTap,
          child: Row(
            children: [
              Ink(
                width: Get.width * 0.50,
                child: Text(subtitle ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor)),
              ),
              SizedBox(child: textCopy)
            ],
          ),
        )
      ],
    );
  }

  ticketTextRow({String? title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!,
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
        SizedBox(height: Get.height * 0.006),
        Text(subtitle ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Gilroy Medium',
                color: notifire.getdarkscolor)),
      ],
    );
  }
}
