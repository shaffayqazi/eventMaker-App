// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/booking/Ticket/TicketDetails.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Completedticket extends StatefulWidget {
  const Completedticket({Key? key}) : super(key: key);

  @override
  _CompletedticketState createState() => _CompletedticketState();
}

class _CompletedticketState extends State<Completedticket> {
  List orderdata = [];
  final commit = TextEditingController();

  late ColorNotifire notifire;
  bool isLoading = false;
  var orderProduc;
  int riderrate = 1;
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
    ticketStatusApi();
    getdarkmodepreviousstate();
  }

  ticketStatusApi() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID, "status": "Completed"};
    ApiWrapper.dataPost(Config.ticketStatus, data).then((val) {
      setState(() {});
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
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
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
                                      fontFamily: 'Gilroy Bold',
                                    )),
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
    return InkWell(
      onTap: () {
        Get.to(() => TicketDetailPage(eID: user[i]["ticket_id"]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                fit: BoxFit.cover,
                                width: width,
                                image:
                                    Config.imageURLPath + user[i]["event_img"]),
                          ),
                          SizedBox(height: height / 70),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 9,
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
                                  fontFamily: 'Gilroy Medium',
                                )),
                          ),
                          Row(
                            children: [
                              Image.asset("image/location.png",
                                  height: height / 40),
                              SizedBox(width: Get.width * 0.01),
                              Ink(
                                width: Get.width * 0.45,
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
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisAlignment: user[i]["is_review"] != "1"
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  children: [
                    user[i]["is_review"] != "1"
                        ? ticketbutton(
                            title: "Review",
                            bgColor: notifire.getprimerycolor,
                            titleColor: buttonColor,
                            ontap: () {
                              reviewRider(
                                  user[i]["ticket_id"], user[i]["event_title"]);
                            },
                          )
                        : const SizedBox(),
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

  Future reviewRider(tID, title) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height / 40),
                Ink(
                  width: Get.width * 0.70,
                  child: Text(
                    "How was your experience with $title",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height / 40),
                RatingBar.builder(
                  unratedColor: Colors.grey.shade300,
                  initialRating: riderrate.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  glowColor: Colors.grey.shade300,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: buttonColor),
                  onRatingUpdate: (rating) {
                    riderrate = rating.ceil();
                  },
                ),
                SizedBox(height: height / 30),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Comment",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: Get.width * 0.80,
                  child: TextFormField(
                    controller: commit,
                    style:
                        TextStyle(fontSize: height / 50, color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "Enter comment",
                        hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.8),
                            fontSize: height / 55),
                        disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                SizedBox(height: height / 30),
                SizedBox(
                    height: 45.h,
                    width: 410.w,
                    child: FloatingActionButton(
                      onPressed: () {
                        isRating(tID);
                      },
                      child: Custombutton.button(
                        notifire.getbuttonscolor,
                        "Submit",
                        SizedBox(width: width / 3.5),
                        SizedBox(width: width / 6),
                      ),
                    )),

                // appButton(tital: "Submit", onTap: isRating),
                SizedBox(height: height / 40),
              ],
            ),
          );
        });
      },
    );
  }

  isRating(tID) {
    var data = {
      "uid": uID,
      "tid": tID,
      "review_comment": commit.text,
      "total_star": "$riderrate"
    };
    ApiWrapper.dataPost(Config.rateUpdate, data)!.then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          ticketStatusApi();
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          setState(() {});
        }
      }
    });
  }
}
