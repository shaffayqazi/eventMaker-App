// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:like_button/like_button.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmark extends StatefulWidget {
  final String? type;
  const Bookmark({Key? key, this.type}) : super(key: key);

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  List bookmarkList = [];
  late ColorNotifire notifire;
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
    bookMarkListApi();
    getdarkmodepreviousstate();
  }

//!
  bookMarkListApi() {
    setState(() {
      isLoading = true;
    });
    var data = {"uid": uID};
    ApiWrapper.dataPost(Config.bookmarkApi, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          bookmarkList = val["EventData"];
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

  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    print("Api Call Home data : :$data");
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          bookmarkList.clear();
          bookMarkListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height / 20),
              //! -----  AppBar -------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.type == "0"
                      ? InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back))
                      : Container(),
                  Text("Bookmark",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor)),
                  Container(),
                ],
              ),
              SizedBox(height: height / 40),
              Expanded(
                child: SingleChildScrollView(
                  child: !isLoading
                      ? Column(
                          children: [
                            bookmarkList.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: bookmarkList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, i) {
                                      return events(bookmarkList, i);
                                    },
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: Get.height * 0.26),
                                      Image(
                                          image:
                                              const AssetImage("image/49.png"),
                                          height: Get.height * 0.14),
                                      SizedBox(height: Get.height * 0.02),
                                      Center(
                                        child: Text(
                                            "No Event Shortlisted, Yet !",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: notifire.getdarkscolor,
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

              SizedBox(height: height / 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget events(user, i) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            save("EID", user[i]["event_id"]);
            Get.to(() => EventsDetails(eid: user[i]["event_id"]),
                duration: Duration.zero);
          },
          child: Card(
            color: notifire.getcardcolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height / 5.5,
                        width: width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                  fadeInCurve: Curves.easeInCirc,
                                  placeholder: "image/skeleton.gif",
                                  fit: BoxFit.cover,
                                  height: height / 3.5,
                                  width: width,
                                  image: Config.imageURLPath +
                                      user[i]["event_img"]),
                            ),
                            SizedBox(height: height / 70),
                          ],
                        ),
                      ),
                      SizedBox(height: height / 50),
                      Text(
                        user[i]["event_title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy Medium',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("image/location.png",
                              height: height / 40),
                          Ink(
                            width: Get.width * 0.77,
                            child: Text(
                              user[i]["event_address"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Gilroy Medium',
                                  fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: height / 50),
                    ],
                  ),
                  Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: LikeButton(
                            onTap: (val) {
                              return onLikeButtonTapped(
                                  val, user[i]["event_id"]);
                            },
                            likeBuilder: (bool isLiked) {
                              return !isLiked
                                  ? const Icon(Icons.favorite,
                                      color: Color(0xffF0635A), size: 24)
                                  : const Icon(Icons.favorite_border,
                                      color: Colors.grey, size: 24);
                            },
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
