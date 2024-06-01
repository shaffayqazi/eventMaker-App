// ignore_for_file: unnecessary_overrides, file_names

import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';

class HomeDataContro extends GetxController {
  List paymentList = [];
  @override
  void onInit() {
    super.onInit();
  }

  //! user CountryCode
  paymentgateway() {
    ApiWrapper.dataGet(Config.paymentgateway).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          paymentList = val["paymentdata"];
          log(val["paymentdata"].length.toString(), name: "payment deta :: ");
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
