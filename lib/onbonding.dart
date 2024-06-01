import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/utils/media.dart';
import 'package:goevent2/utils/string.dart';

import 'package:provider/provider.dart';

import 'utils/colornotifire.dart';

class Onbonding extends StatefulWidget {
  const Onbonding({Key? key}) : super(key: key);

  @override
  _OnbondingState createState() => _OnbondingState();
}

class _OnbondingState extends State<Onbonding> {
  final int _numPages = 3;

  late ColorNotifire notifire;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 8.0,
      width: isActive ? 8.0 : 8.0,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 1.1,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset("image/onbonding1.png",
                                    fit: BoxFit.fill,
                                    height: height / 1.5,
                                    width: width),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff5669FF),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      topLeft: Radius.circular(50))),
                              height: height / 4,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: height / 30),
                                    Text(
                                      CustomStrings.onbonding1,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 20.sp),
                                    ),
                                    Text(
                                      CustomStrings.onbonding2,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.white,
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(height: height / 30),
                                    Text(
                                      "In publishing and graphic design, Lorem is",
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.white,
                                          fontSize: 12.sp),
                                    ),
                                    Text(
                                      "a placeholder text commonly",
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.white,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset("image/onbonding2.png",
                                    fit: BoxFit.fill,
                                    height: height / 1.5,
                                    width: width),
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff5669FF),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      topLeft: Radius.circular(50))),
                              height: height / 4,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: height / 30),
                                    Text("Web Have Modern Events",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 20.sp)),
                                    Text("Calendar Feature",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            color: Colors.white,
                                            fontSize: 20.sp)),
                                    SizedBox(height: height / 30),
                                    Text(
                                        "In publishing and graphic design, Lorem is",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            color: Colors.white,
                                            fontSize: 12.sp)),
                                    Text(
                                      "a placeholder text commonly",
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.white,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset("image/onbonding3.png",
                                    fit: BoxFit.fill,
                                    height: height / 1.5,
                                    width: width)
                              ],
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff5669FF),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      topLeft: Radius.circular(50))),
                              height: height / 4,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: height / 30),
                                    Text("To Look Up More Events or",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 20.sp)),
                                    Text("Activities Nearby By Map",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            color: Colors.white,
                                            fontSize: 20.sp)),
                                    SizedBox(height: height / 30),
                                    Text(
                                        "In publishing and graphic design, Lorem is",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            color: Colors.white,
                                            fontSize: 12.sp)),
                                    Text("a placeholder text commonly",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Medium',
                                            color: Colors.white,
                                            fontSize: 12.sp)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _currentPage != _numPages - 1
                    ? Container(
                        height: height / 11,
                        color: const Color(0xff5669FF),
                        child: Align(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const Login(),
                                        duration: Duration.zero);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: height / 20,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Center(
                                        child: Text(
                                          'Skip',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: const Color(0xff5669FF),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildPageIndicator()),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _pageController.nextPage(
                                        duration:
                                            const Duration(microseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: height / 20,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Center(
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xff5669FF),
                        height: height / 11,
                        child: Align(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const Login(),
                                        duration: Duration.zero);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: height / 20,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Center(
                                        child: Text(
                                          'Skip',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: const Color(0xff5669FF),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildPageIndicator()),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const Login(),
                                        duration: Duration.zero);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    height: height / 20,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Center(
                                        child: Text(
                                          'Start',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy Medium',
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
