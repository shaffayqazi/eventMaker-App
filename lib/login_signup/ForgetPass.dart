// ignore_for_file: file_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/itextfield.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordsetPage extends StatefulWidget {
  final String? number;
  const PasswordsetPage({Key? key, this.number}) : super(key: key);

  @override
  _PasswordsetPageState createState() => _PasswordsetPageState();
}

class _PasswordsetPageState extends State<PasswordsetPage> {
  late ColorNotifire notifire;
  final auth = FirebaseAuth.instance;

  final fpassword = TextEditingController();
  final spassword = TextEditingController();
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

  bool _obscureText = true;
  bool _obscureText1 = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height / 20),
              Row(
                children: [
                  SizedBox(width: width / 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        color: notifire.getprimerycolor,
                        child: Icon(Icons.arrow_back,
                            color: notifire.getwhitecolor)),
                  ),
                ],
              ),
              SizedBox(height: height / 100),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Resset Password",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getwhitecolor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 100),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please enter your email address to",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getwhitecolor),
                        ),
                        SizedBox(height: height / 400),
                        Text(
                          "request a password reset",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getwhitecolor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Customtextfild2.textField(
                  fpassword,
                  _obscureText,
                  "New Password",
                  Colors.grey,
                  notifire.getwhitecolor,
                  "image/Lock.png",
                  GestureDetector(
                      onTap: () {
                        _toggle();
                      },
                      child: _obscureText
                          ? Image.asset("image/Hide.png", height: 22)
                          : Image.asset("image/Show.png", height: 22)),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Customtextfild2.textField(
                  spassword,
                  _obscureText1,
                  "confirm Password",
                  Colors.grey,
                  notifire.getwhitecolor,
                  "image/Lock.png",
                  GestureDetector(
                      onTap: () {
                        _toggle2();
                      },
                      child: _obscureText1
                          ? Image.asset("image/Hide.png", height: 22)
                          : Image.asset("image/Show.png", height: 22)),
                ),
              ),
              SizedBox(height: height / 20),
              GestureDetector(
                onTap: () {
                  if (fpassword.text.isNotEmpty && spassword.text.isNotEmpty) {
                    print((fpassword.text == spassword.text));
                    if (fpassword.text == spassword.text) {
                      forgetpass();
                    } else {
                      ApiWrapper.showToastMessage("password not match");
                    }
                  } else {
                    ApiWrapper.showToastMessage("Please fill required field!");
                  }
                },
                child: Custombutton.button(
                  notifire.getbuttonscolor,
                  "SEND",
                  SizedBox(width: width / 3.5),
                  SizedBox(width: width / 7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //! user Login Api
  forgetpass() {
    var data = {"mobile": widget.number, "password": fpassword.text};
    print(data);

    ApiWrapper.dataPost(Config.forgetpassword, data).then((val) {
      print(val);
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          FocusScope.of(context).requestFocus(FocusNode());

          Get.to(() => const Login(), duration: Duration.zero);
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
