import 'package:flutter/material.dart';

import 'color.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = false;
  set setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;

  get getprimerycolor => isDark ? darkPrimeryColor : primeryColor;
  get getcardcolor => isDark ? darkcardColor : cardColor;
  get gettextcolor => isDark ? darktextColor : textColor;
  get getprocolor => isDark ? darkproColor : proColor;
  get gettext1color => isDark ? darktext1Color : text1Color;
  get getwhitecolor => isDark ? whiteColor : darkwhiteColor;
  get getbuttonscolor => isDark ? darkbuttonsColor : buttonsColor;
  get getbuttoncolor => isDark ? buttonboldColor : buttonColor;
  get gettopcolor => isDark ? darktopColor : topColor;
  get getdarkscolor => isDark ? blackColor : darkblackColor;
  get getbluecolor => isDark ? darkblueColor : blueColor;
  get getorangecolor => isDark ? darkorangeColor : orangeColor;
  get getpinkcolor => isDark ? darkpinkColor : pinkColor;
  get getblackcolor => isDark ? darkwhiteColor : whiteColor;
  get getsettingcolor => isDark ? darktopColor : whiteColor;
  get getticketcolor => isDark ? darktopColor1 : buttonColor;
}
