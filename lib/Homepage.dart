// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_null_comparison, unnecessary_brace_in_string_interps, unused_element, file_names

import 'package:flutter/material.dart';
import 'package:goevent2/booking/TicketStatus.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/profile/profile.dart';
import 'package:goevent2/utils/Images.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Search/SearchPage.dart';
import 'home/bookmark.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  late ColorNotifire notifire;

  late int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;
  int _selectedIndex = 0;
  var isLogin = false;

  final _pageOption = [
    const Home(),
    const SearchPage(),
    const TicketStatusPage(),
    const Bookmark(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    // isLogin = getdata.read("firstLogin") ?? false;
    setState(() {});
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      // Scaffold.of(context).removeCurrentSnackBar();
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      // Scaffold.of(context).removeCurrentSnackBar();
      // Scaffold.of(context).showSnackBar(_getExitSnackBar(context));
      return false;
    }
  }

  // SnackBar _getExitSnackBar(BuildContext context) {
  //   return const SnackBar(
  //       content: Text('Press BACK again to exit!'),
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 2),
  //       behavior: SnackBarBehavior.floating);
  // }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: const Color(0xff6978A0).withOpacity(.80),
              backgroundColor: notifire.getprimerycolor,
              selectedLabelStyle: const TextStyle(
                  fontFamily: 'Gilroy_Medium', fontWeight: FontWeight.w500),
              fixedColor: buttonColor,
              unselectedLabelStyle:
                  const TextStyle(fontFamily: 'Gilroy_Medium'),
              currentIndex: _selectedIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(Images.home,
                        color: _selectedIndex == 0
                            ? buttonColor
                            : const Color(0xff6978A0).withOpacity(.80),
                        height: MediaQuery.of(context).size.height / 35),
                    label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Image.asset(Images.search,
                        color: _selectedIndex == 1
                            ? buttonColor
                            : const Color(0xff6978A0).withOpacity(.80),
                        height: MediaQuery.of(context).size.height / 35),
                    label: 'Search'),
                BottomNavigationBarItem(
                    icon: Image.asset(Images.calendar,
                        color: _selectedIndex == 2
                            ? buttonColor
                            : const Color(0xff6978A0).withOpacity(.80),
                        height: MediaQuery.of(context).size.height / 35),
                    label: 'Booking'),
                BottomNavigationBarItem(
                  icon: Image.asset(Images.rectangle,
                      color: _selectedIndex == 3
                          ? buttonColor
                          : const Color(0xff6978A0).withOpacity(.80),
                      height: MediaQuery.of(context).size.height / 35),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(Images.user,
                      color: _selectedIndex == 4
                          ? buttonColor
                          : const Color(0xff6978A0).withOpacity(.80),
                      height: MediaQuery.of(context).size.height / 35),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                setState(() {});
                _selectedIndex = index;

                // if (isLogin == true) {
                //   _selectedIndex = index;
                // } else {
                //   index != 0 ? Get.to(() => Container()) : const SizedBox();
                // }
              }),
          body: _pageOption[_selectedIndex]),
    );
  }
}
