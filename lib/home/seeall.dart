// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:like_button/like_button.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

class All extends StatefulWidget {
  final String? title;
  final List? eventList;
  const All({Key? key, this.title, this.eventList}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  List<String> _images = [];

  final hData = Get.put(HomeController());

  bool selected = false;

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
            SizedBox(height: height / 16),
            //! -------- AppBar --------
            Row(
              children: [
                SizedBox(width: width / 20),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child:
                        Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
                SizedBox(width: width / 80),
                Text(
                  widget.title!,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Gilroy Medium',
                      color: notifire.getdarkscolor),
                ),
              ],
            ),
            SizedBox(height: height / 50),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.eventList!.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return events(widget.eventList, i);
                },
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget events(user, i) {
    _images.clear();
    user[i]["member_list"].forEach((e) {
      _images.add(Config.imageURLPath + e);
    });
    int mEventcount = int.parse(user[i]["total_member_list"].toString()) > 3
        ? 3
        : int.parse(user[i]["total_member_list"].toString());
    for (var i = 0; i < mEventcount; i++) {
      _images.add(Config.userImage);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => EventsDetails(eid: user[i]["event_id"]),
                  duration: Duration.zero);
            },
            child: Card(
              color: notifire.getcardcolor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height / 5.5,
                          width: width,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.transparent),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: SizedBox(
                                  height: height / 3.5,
                                  width: width,
                                  child: FadeInImage.assetNetwork(
                                      fadeInCurve: Curves.easeInCirc,
                                      placeholder: "image/skeleton.gif",
                                      fit: BoxFit.cover,
                                      image: Config.imageURLPath +
                                          user[i]["event_img"]),
                                ),
                              ),
                              SizedBox(height: height / 70)
                            ],
                          ),
                        ),
                        SizedBox(height: height / 60),
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
                        SizedBox(height: height / 60),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("image/location.png",
                                height: height / 40),
                            const SizedBox(width: 2),
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
                        SizedBox(height: height / 70),
                        Row(
                          children: [
                            // SizedBox(width: width / 40),
                            user[i]["total_member_list"] != "0"
                                ? Row(
                                    children: [
                                      // _images.isNotEmpty?

                                      FlutterImageStack(
                                          totalCount: 0,
                                          itemRadius: 30,
                                          itemCount: 3,
                                          itemBorderWidth: 1.5,
                                          imageList: _images),
                                      // : const Image(
                                      //     image:
                                      //         AssetImage("image/user.png"),
                                      //     height: 28),
                                      SizedBox(width: Get.width * 0.01),
                                      Text(
                                        "${user[i]["total_member_list"]} + Going",
                                        style: TextStyle(
                                            color: const Color(0xff5d56f3),
                                            fontSize: 11.sp,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey.shade200,
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
                                            color: Color(0xffF0635A), size: 24);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          // bookMarkListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }
}
