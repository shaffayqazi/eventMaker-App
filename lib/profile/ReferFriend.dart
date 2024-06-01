// ignore_for_file: file_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/utils/Images.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReferFriendPage extends StatefulWidget {
  final String? amount;
  const ReferFriendPage({Key? key, this.amount}) : super(key: key);

  @override
  State<ReferFriendPage> createState() => _ReferFriendPageState();
}

class _ReferFriendPageState extends State<ReferFriendPage> {
  final addAmount = TextEditingController();
  late ColorNotifire notifire;
  String code = "0";
  String signupcredit = "0";
  String refercredit = "0";
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    getdarkmodepreviousstate();
    walletrefar();
    getPackage();
    super.initState();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
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

  walletrefar() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.refardata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
          signupcredit = val["signupcredit"];
          refercredit = val["refercredit"];
        } else {
          setState(() {});
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      floatingActionButton: SizedBox(
        height: 45.h,
        width: 410.w,
        child: FloatingActionButton(
          onPressed: () {
            share();
          },
          child: Custombutton.button(
              notifire.getbuttonscolor,
              "Refer a friend".toUpperCase(),
              SizedBox(width: width / 6),
              SizedBox(width: width / 11)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
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
                      "Refer a Friend",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.08),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Image.asset(Images.referAnd),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: Get.width * 0.60,
                      child: Text(
                        "Earn ${mainData["currency"]}${refercredit} for Each Friend you refer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy Bold',
                            color: notifire.getdarkscolor),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    rowText(title: "Share the referral link with your fiends"),
                    SizedBox(height: Get.height * 0.01),
                    rowText(
                        title:
                            "Friend get ${mainData["currency"]}${refercredit} on their first complete transaction"),
                    SizedBox(height: Get.height * 0.01),
                    rowText(
                        title:
                            "You get ${mainData["currency"]}${signupcredit} on your wallet"),
                    SizedBox(height: Get.height * 0.02),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "#$code"));
                        ApiWrapper.showToastMessage("Copied to Code");
                        //   },
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tooltip(
                            preferBelow: false,
                            message: "Copy",
                            child: Text("#$code",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.getdarkscolor)),
                          ),
                          const SizedBox(width: 8),
                          Image(
                            image: const AssetImage("image/Copy.png"),
                            color: notifire.getdarkscolor,
                            height: Get.height * 0.02,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
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

  rowText({String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Icon(Icons.circle, color: notifire.getdarkscolor, size: 8),
          SizedBox(width: Get.width * 0.02),
          Ink(
            width: Get.width * 0.77,
            child: Text(
              title ?? "",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor),
            ),
          ),
        ],
      ),
    );
  }
}
