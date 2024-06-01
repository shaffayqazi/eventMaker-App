// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/media.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

OutlineInputBorder myinputborder({Color? borderColor}) {
  return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: borderColor!, width: 1));
}

save(key, val) {
  final data = GetStorage();
  data.write(key, val);
}

doublevaluPer(first, second) {
  return (double.parse(first.toString()) *
          double.parse(second.toString()) /
          100)
      .toStringAsFixed(2);
}

doublevaluemulti(first, second) {
  return (double.parse(first.toString()) * double.parse(second.toString()))
      .toStringAsFixed(2);
}

// value --
valueCal(first, second) {
  return (double.parse(first.toString()) - double.parse(second.toString()))
      .toStringAsFixed(2);
}

//value ++
valuePlus(first, second) {
  return (double.parse(first.toString()) + double.parse(second.toString()))
      .toStringAsFixed(2);
}

// Widget gamess(context, img, name, notifire) {
//   return Column(
//     children: [
//       GestureDetector(
//         onTap: () {
//           Get.to(() => const All(), duration: Duration.zero);
//         },
//         child: Container(
//           color: Colors.transparent,
//           height: height / 6,
//           width: width / 3.4,
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             color: notifire.getprimerycolor,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Image.asset(img, height: height / 10),
//                 Container(
//                   height: height / 40,
//                   width: width / 6,
//                   decoration: BoxDecoration(
//                       color: notifire.gettopcolor,
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(20))),
//                   child: Center(
//                     child: Text(
//                       name,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                           fontSize: height / 70,
//                           fontFamily: 'Gilroy Normal'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget sugestlocationtype(
    {Function()? ontap,
    title,
    val,
    image,
    adress,
    radio,
    Color? borderColor,
    Color? titleColor}) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 18),
        child: Container(
          height: height / 10,
          decoration: BoxDecoration(
              border: Border.all(color: borderColor!, width: 1),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(11)),
          child: Row(
            children: [
              SizedBox(width: width / 55),
              Container(
                  height: height / 12,
                  width: width / 5.5,
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F4F9),
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      Center(child: Image.network(image, height: height / 08))),
              SizedBox(width: width / 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.01),
                  Text(title,
                      style: TextStyle(
                        fontSize: height / 55,
                        fontFamily: 'Gilroy_Bold',
                        color: titleColor,
                      )),
                  SizedBox(
                    width: Get.width * 0.50,
                    child: Text(adress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: height / 65,
                            fontFamily: 'Gilroy_Medium',
                            color: Colors.grey)),
                  ),
                ],
              ),
              const Spacer(),
              radio
            ],
          ),
        ),
      ),
    );
  });
}

Widget loading({double? size}) {
  return Image(
    image: const AssetImage("image/loading.gif"),
    height: size,
  );
}

Widget isLoadingCircular() {
  return Column(
    children: [
      SizedBox(height: Get.height * 0.40),
      Center(
        child: CircularProgressIndicator(color: buttonColor),
      ),
    ],
  );
}

//! --------|| Open Url ||-------
Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
