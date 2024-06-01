// ignore_for_file: file_names

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkMode extends GetxController {
  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
      update();
    } else {
      notifire.setIsDark = previusstate;
      update();
    }
  }
}
