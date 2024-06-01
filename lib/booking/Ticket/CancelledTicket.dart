// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/booking/Ticket/TicketDetails.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { lafayette, jefferson }

class Cancelledticket extends StatefulWidget {
  const Cancelledticket({Key? key}) : super(key: key);

  @override
  _CancelledticketState createState() => _CancelledticketState();
}

class _CancelledticketState extends State<Cancelledticket> {
  late ColorNotifire notifire;
  List orderdata = [];
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
    ticketStatusApi();
  }

  ticketStatusApi() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID, "status": "Cancelled"};

    ApiWrapper.dataPost(Config.ticketStatus, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          orderdata = val["order_data"];
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: !isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    orderdata.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: orderdata.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.only(bottom: Get.height * 0.02),
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) {
                                return bookticket(orderdata, i);
                              },
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: const AssetImage("image/33.png"),
                                  height: Get.height * 0.14),
                              SizedBox(height: Get.height * 0.02),
                              Center(
                                child: Text("Looks like you haven't booked yet",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: notifire.gettextcolor,
                                        fontSize: 16.sp,
                                        fontFamily: 'Gilroy Bold')),
                              ),
                              SizedBox(height: Get.height * 0.02),
                            ],
                          ),
                  ],
                )
              : isLoadingCircular(),
        ),
      ),
    );
  }

  Widget bookticket(user, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Get.to(() => TicketDetailPage(eID: user[i]["ticket_id"]));
        },
        child: Card(
          elevation: 1,
          color: notifire.getprimerycolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: height / 7,
                      width: width * 0.32,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: FadeInImage.assetNetwork(
                                fadeInCurve: Curves.easeInCirc,
                                placeholder: "image/skeleton.gif",
                                image:
                                    Config.imageURLPath + user[i]["event_img"],
                                fit: BoxFit.cover,
                                width: width),
                          ),
                          SizedBox(height: height / 70),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Ink(
                            width: Get.width * 0.54,
                            child: Text(user[i]["event_title"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: 16.sp,
                                    fontFamily: 'Gilroy Medium',
                                    fontWeight: FontWeight.w600)),
                          ),
                          Ink(
                            width: Get.width * 0.54,
                            child: Text(user[i]["event_sdate"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: darktextColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'Gilroy Medium')),
                          ),
                          Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 40),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.46,
                                child: Text(
                                  user[i]["event_address"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: Get.height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ticketbutton(
                      title: "View E-Ticket",
                      bgColor: buttonColor,
                      titleColor: Colors.white,
                      ontap: () {
                        Get.to(
                            () => TicketDetailPage(eID: user[i]["ticket_id"]));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ticketbutton({Function()? ontap, String? title, Color? bgColor, titleColor}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: (BorderRadius.circular(18)),
            border: Border.all(color: buttonColor, width: 1)),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }
}
