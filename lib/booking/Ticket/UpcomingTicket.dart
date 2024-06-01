// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names

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

// Done
class UpcomingTicket extends StatefulWidget {
  const UpcomingTicket({Key? key}) : super(key: key);

  @override
  _UpcomingTicketState createState() => _UpcomingTicketState();
}

class _UpcomingTicketState extends State<UpcomingTicket> {
  var selectedRadioTile;
  final note = TextEditingController();
  String? rejectmsg = '';
  List orderdata = [];
  bool isLoading = false;

  late ColorNotifire notifire;

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
    var data = {"uid": uID, "status": "Booked"};
    print("Api Call type price: :$data");
    ApiWrapper.dataPost(Config.ticketStatus, data).then((val) {
      print("Api Call type price: :$val");

      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          print(val);
          orderdata = val["order_data"];
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            orderdata = [];
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
                      height: height / 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Ink(
                            width: Get.width * 0.54,
                            child: Text(user[i]["event_title"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                      title: "Cancel Booking",
                      bgColor: notifire.getprimerycolor,
                      titleColor: buttonColor,
                      ontap: () {
                        ticketCancell(user[i]["ticket_id"]);
                      },
                    ),
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

  ticketCancell(ticketid) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: notifire.getprimerycolor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Cancel Booking",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Gilroy Bold',
                          color: const Color(0xffF0635A)),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Please select the reason for cancellation:",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return RadioListTile(
                          dense: true,
                          value: i,
                          activeColor: buttonColor,
                          tileColor: notifire.getdarkscolor,
                          selected: true,
                          groupValue: selectedRadioTile,
                          title: Text(
                            cancelList[i]["title"],
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Gilroy Medium',
                                color: notifire.getdarkscolor),
                          ),
                          onChanged: (val) {
                            setState(() {});
                            selectedRadioTile = val;
                            rejectmsg = cancelList[i]["title"];
                          },
                        );
                      },
                    ),
                    rejectmsg == "Others"
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: myinputborder(
                                      borderColor: notifire.gettextcolor),
                                  focusedBorder: myinputborder(
                                      borderColor: notifire.gettextcolor),
                                  hintText: 'Enter reason',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: height / 55,
                                      color: Colors.grey)),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Cancel",
                            bgColor: buttonColor,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Confirm",
                            bgColor: buttonColor,
                            titleColor: Colors.white,
                            ontap: () {
                              cancelticketApi(ticketid);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          });
        });
  }

  List cancelList = [
    {"id": 1, "title": "I have another event, so it collides"},
    {"id": 2, "title": "Imsick. can't come"},
    {"id": 3, "title": "have an urgent need"},
    {"id": 4, "title": "have ne transportation to come"},
    {"id": 5, "title": "thave no friends to come"},
    {"id": 6, "title": "want to book another event"},
    {"id": 7, "title": "just want to cancel"},
    {"id": 8, "title": "Others"},
  ];

  cancelticketApi(ticketid) {
    var addMsg = rejectmsg == "Other" ? note.text : rejectmsg;
    var data = {"uid": uID, "tid": ticketid, "cancle_comment": addMsg};
    print("Api Call type price: :$data");
    ApiWrapper.dataPost(Config.ticketCancel, data).then((val) {
      print("Api Call type price: :$val");

      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          ticketStatusApi();
          Get.back();
        } else {
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
