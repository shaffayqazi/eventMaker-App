// ignore_for_file: unused_field, avoid_print

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List faqList = [];
  List faqList2 = [];
  late ColorNotifire notifire;
  int selectId = 0;

  bool isLoading = false;
  final x = Get.put(AuthController());

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
    faqListApi();
  }

  void faqListApi() {
    isLoading = true;
    var data = {"uid": uID};
    ApiWrapper.dataPost(Config.faq, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          print(val["FaqData"]);

          faqList = val["FaqData"];
          faqList2 = val["FaqData"][0]["faq_list"];
          isLoading = false;
          setState(() {});
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Column(
          children: [
            SizedBox(height: height / 20),
            //! ------ Appbar -----
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
                Text("Helps & FAQs",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor)),
              ],
            ),
            SizedBox(height: height / 25),
            SingleChildScrollView(
                child: !isLoading
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              height: Get.height * 0.05,
                              child: ListView.builder(
                                itemCount: faqList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return treding(faqList, i);
                                },
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Accordion(
                                disableScrolling: true,
                                flipRightIconIfOpen: true,
                                contentVerticalPadding: 0,
                                scrollIntoViewOfItems:
                                    ScrollIntoViewOfItems.fast,
                                contentBorderColor: Colors.transparent,
                                maxOpenSections: 1,
                                headerBackgroundColorOpened:
                                    notifire.getcardcolor,
                                headerPadding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 15),
                                children: [
                                  for (var j = 0; j < faqList2.length; j++)
                                    AccordionSection(
                                        rightIcon: Icon(Icons.add,
                                            color: notifire.getdarkscolor),
                                        headerPadding: const EdgeInsets.all(15),
                                        flipRightIconIfOpen: true,
                                        headerBackgroundColor:
                                            notifire.getcardcolor,
                                        contentBackgroundColor:
                                            notifire.getcardcolor,
                                        header: Text(faqList2[j]["faq_que"],
                                            style: TextStyle(
                                                color: notifire.getdarkscolor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        content: Text(faqList2[j]["faq_ans"],
                                            style: _contentStyle),
                                        contentHorizontalPadding: 20,
                                        contentBorderWidth: 1),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(height: 250),
                          Center(child: CircularProgressIndicator()),
                        ],
                      )),
          ],
        ),
      ),
    );
  }

  treding(user, i) {
    return InkWell(
      onTap: () {
        setState(() {});
        faqList2 = user[i]["faq_list"];
        selectId = i;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
              color: selectId == i ? Colors.blue : notifire.getprimerycolor,
              border: Border.all(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                SizedBox(width: Get.width * 0.02),
                Text(user[i]["cat_name"],
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: selectId == i ? Colors.white : Colors.blue,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
