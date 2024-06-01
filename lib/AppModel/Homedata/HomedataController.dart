// ignore_for_file: unnecessary_overrides, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';

String? uID;
Map mainData = {};
String wallet = "";

class HomeController extends GetxController {
  Map homeDataList = {};
  bool isLoading = false;
//! -----  Home Page All list -----
  List catlist = [];
  List trendingEvent = [];
  List upcomingEvent = [];
  List nearbyEvent = [];
  List thisMonthEvent = [];

  //! ------- EventsDetails Page Data ---------
  var eventData;
  List event_gallery = [];
  List event_sponsore = [];

  @override
  void onInit() {
    super.onInit();
  }

  homeDataApi(uid, lat, long) {
    isLoading = true;
    update();
    uID = uid;
    var data = {"uid": uid, "lats": lat, "longs": long};
    print("Api Call Home data : :$data");
    ApiWrapper.dataPost(Config.homedat, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          homeDataList = val["HomeData"];
          catlist = val["HomeData"]["Catlist"];
          trendingEvent = val["HomeData"]["trending_event"];
          upcomingEvent = val["HomeData"]["upcoming_event"];
          nearbyEvent = val["HomeData"]["nearby_event"];
          thisMonthEvent = val["HomeData"]["this_month_event"];
          mainData = val["HomeData"]["Main_Data"];
          wallet = val["HomeData"]["wallet"];
          isLoading = false;
          update();
        } else {
          isLoading = false;
          update();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }

  homeDataReffressApi(uid, lat, long) {
    uID = uid;
    var data = {"uid": uid, "lats": lat, "longs": long};
    ApiWrapper.dataPost(Config.homedat, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          homeDataList = val["HomeData"];
          catlist = val["HomeData"]["Catlist"];
          trendingEvent = val["HomeData"]["trending_event"];
          upcomingEvent = val["HomeData"]["upcoming_event"];
          nearbyEvent = val["HomeData"]["nearby_event"];
          thisMonthEvent = val["HomeData"]["this_month_event"];
          mainData = val["HomeData"]["Main_Data"];
          wallet = val["HomeData"]["wallet"];
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }

  eventDetailApi(eid) {
    var data = {"eid": eid, "uid": uID};
    print("Api Call Home data : :$data");
    ApiWrapper.dataPost(Config.eventdataApi, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            eventData = e;
          });
          update();
          event_gallery = val["Event_gallery"];
          event_sponsore = val["Event_sponsore"];
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
        update();
      }
    });
  }
}
