import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/bookmark.dart';
import 'package:goevent2/profile/ReferFriend.dart';
import 'package:goevent2/profile/Wallet/WalletHistory.dart';
import 'package:goevent2/profile/faq.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/Login.dart';
import 'package:goevent2/notification/notification.dart';
import 'package:goevent2/profile/editprofile.dart';
import 'package:goevent2/profile/loream.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../booking/TicketStatus.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final x = Get.put(AuthController());

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
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Column(
          children: [
            SizedBox(height: height / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Gilroy Medium',
                      color: notifire.getdarkscolor),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Account Settings",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Gilroy Bold',
                              color: Colors.grey)),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Profie",
                        image: "image/Profile.png",
                        onTap: () {
                          Get.to(() => const Edit());
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "My Booking",
                        image: "image/Calendar.png",
                        onTap: () {
                          Get.to(() => const TicketStatusPage(type: "0"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Wallet",
                        image: "image/wallet.png",
                        onTap: () {
                          Get.to(() => const WalletReportPage());
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Favorite",
                        image: "image/Heart.png",
                        onTap: () {
                          Get.to(() => const Bookmark(type: "0"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Notification",
                        image: "image/Notification2.png",
                        onTap: () {
                          Get.to(() => const Note());
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Refer a Friend",
                        image: "image/Discount-1.png",
                        onTap: () {
                          Get.to(() => const ReferFriendPage());
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Dark Mode",
                        image: "image/Show.png",
                        darkmode: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: notifire.getbuttonscolor,
                            value: notifire.getIsDark,
                            onChanged: (val) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                notifire.setIsDark = val;
                                prefs.setBool("setIsDark", val);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Contact Us",
                        image: "image/Fill1.png",
                        onTap: () {
                          Get.to(() => const Loream("Contact Us"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Privacy Policy",
                        image: "image/Circle.png",
                        onTap: () {
                          Get.to(() => const Loream("Privacy Policy"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Terms & Condition",
                        image: "image/helps.png",
                        onTap: () {
                          Get.to(() => const Loream("Terms & Conditions"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "FAQ",
                        image: "image/faq.png",
                        onTap: () {
                          Get.to(() => const Faq());
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Help",
                        image: "image/Danger.png",
                        onTap: () {
                          Get.to(() => const Loream("HELP"));
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      settingWidget(
                        tital: "Logout",
                        image: "image/Logout.png",
                        onTap: () {
                          signoutSheetMenu();
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  settingWidget({Function()? onTap, String? tital, image, Widget? darkmode}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.06,
        decoration: BoxDecoration(
            color: notifire.getsettingcolor,
            border: Border.all(color: Colors.grey, width: 0.5),
            // boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4)],
            borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image(
                            image: AssetImage(image!),
                            color: notifire.getdarkscolor),
                      )),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    tital!,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor),
                  ),
                ],
              ),
              darkmode ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Colors.grey.withOpacity(0.4),
                  )
            ],
          ),
        ),
      ),
    );
  }

  void signoutSheetMenu() {
    showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return Column(
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
                "Logout",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Gilroy Bold',
                    color: const Color(0xffF0635A)),
              ),
              SizedBox(height: Get.height * 0.02),
              Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.gettextcolor),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Get.width * 0.35,
                    height: Get.height * 0.06,
                    child: MaterialButton(
                      color: const Color(0xFFE9E7FC),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel",
                          style: TextStyle(color: buttonColor, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.35,
                    height: Get.height * 0.06,
                    child: MaterialButton(
                      color: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        getData.remove("UserLogin");
                        getData.remove("FirstUser");
                        Get.offAll(() => const Login());
                      },
                      child: const Text(
                        "Yes Logout",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.04),
            ],
          );
        });
  }
}
