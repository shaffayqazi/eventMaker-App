// ignore_for_file: avoid_print, unused_catch_clause

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/login_signup/ForgetPass.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

class Verification extends StatefulWidget {
  final String? type;
  final String? number;
  final String? verID;
  const Verification({Key? key, this.verID, this.number, this.type})
      : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  final x = Get.put(AuthController());

  bool resendotp = false;
  String otpPin = " ";

  late ColorNotifire notifire;
  String? vID = "";

  Timer? _timer;
  int _start = 20;

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
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

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            resendotp = true;
            timer.cancel();
          });
        } else {
          setState(() {});
          _start--;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    startTimer();
    vID = widget.verID;
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }



  Future<void> verifyOTP(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verID!, smsCode: otpController.text);
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        if (widget.type == "Reset") {
          Get.to(() => PasswordsetPage(number: widget.number));
        } else {
          x.userRegister();
        }
        ApiWrapper.showToastMessage("Auth Completed!");
      } else {
        ApiWrapper.showToastMessage("Auth Failed!");
      }
    } on FirebaseAuthException catch (e) {
      ApiWrapper.showToastMessage("Auth Failed! ");
      print(e);
    }
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
                      "Verification",
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
                          "We've send you the verification",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getwhitecolor),
                        ),
                        SizedBox(height: height / 400),
                        Text(
                          "code on ${widget.number ?? ""}",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getwhitecolor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 30),
              animatedBorders(),
              SizedBox(height: height / 30),
              SizedBox(height: height / 30),
              GestureDetector(
                onTap: () {
                  verifyOTP(context);
                },
                child: Custombutton.button(
                  notifire.getbuttonscolor,
                  "CONTINUE",
                  SizedBox(width: width / 5),
                  SizedBox(width: width / 7),
                ),
              ),
              SizedBox(height: height / 30),
              resendotp
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            otpController.clear();

                          },
                          child: Text(
                            "Re-send OTP",
                            style: TextStyle(
                                color: notifire.getwhitecolor,
                                fontSize: 12.sp,
                                fontFamily: 'Gilroy Bold'),
                          ),
                        )
                      ],
                    )
                  : SizedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Re-send code in ",
                          style: TextStyle(
                              color: notifire.getwhitecolor,
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy Medium'),
                        ),
                        Text(
                          durationToString(_start).toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget animatedBorders() {
    return Container(
      color: notifire.getprimerycolor,
      height: Get.height * 0.06,
      width: Get.width * 0.90,
      child: PinPut(
          controller: otpController,
          onSubmit: (val) {},
          onChanged: (val) {
            // otpval = val;
          },
          textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy_Bold',
              fontSize: height / 40),
          fieldsCount: 6,
          eachFieldWidth: Get.width * 0.13,
          withCursor: false,
          submittedFieldDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey)),
          selectedFieldDecoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade200)),
          disabledDecoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.grey),
          followingFieldDecoration: BoxDecoration(
            backgroundBlendMode: BlendMode.color,
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          )),
    );
  }

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        ApiWrapper.showToastMessage("OTP Sent!");
        vID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }
}
