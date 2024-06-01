// ignore_for_file: file_names, unused_local_variable, avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/Homepage.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/utils/AppWidget.dart';

class AuthController extends GetxController {
  // UserData? userData;
  var countryCode = [];

  String? uID;

  //! user CountryCode
  cCodeApi() {
    ApiWrapper.dataGet(Config.cCode).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["CountryCode"].forEach((e) {
            countryCode.add(e['ccode']);
          });
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  //! user Login Api
  userLogin(String? number, password) {
    var data = {"mobile": number, "password": password};
    log(data.toString(), name: "Login Api : ");
    ApiWrapper.dataPost(Config.loginuser, data).then((val) {
      log(val.toString(), name: "Login Api : ");
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          save("FirstUser", true);
          // userData = UserData.fromJson(val["UserLogin"]);
          save("UserLogin", val["UserLogin"]);
          Get.to(() => const Bottombar(), duration: Duration.zero);
          update();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  //! user Register Api
  userRegister() {
    var name = getData.read("User")["UserName"];
    var email = getData.read("User")["UserEmail"];
    var mobile = getData.read("User")["Usernumber"];
    var ccode = getData.read("User")["Ccode"];
    var password = getData.read("User")["FPassword"];
    var rcode = getData.read("User")["ReferralCode"];

    var data = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "ccode": ccode,
      "password": password,
      "refercode": rcode
    };
    ApiWrapper.dataPost(Config.reguser, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        log(val.toString(), name: "Api Register data::");
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          save("UserLogin", val["UserLogin"]);
          Get.to(() => const Bottombar(), duration: Duration.zero);
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
