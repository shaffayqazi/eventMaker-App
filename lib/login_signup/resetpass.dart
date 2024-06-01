// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/login_signup/verification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/media.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  late ColorNotifire notifire;
  final number = TextEditingController();
  String? _selectedCountryCode = '+91';
  final x = Get.put(AuthController());
  bool isLoading = false;

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

  String? vID = "";

  verifyPhone(String mobilenumber) async {
    var mcheck = {"mobile": number.text};

    ApiWrapper.dataPost(Config.mobilecheck, mcheck).then((val) async {
      setState(() {});
      isLoading = true;
      if ((val != null) && (val.isNotEmpty)) {
        if (val["Result"] != "true") {
          log(val.toString(), name: "Mobile Chake ");
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobilenumber,
            timeout: const Duration(seconds: 30),
            verificationCompleted: (PhoneAuthCredential credential) {
              ApiWrapper.showToastMessage("Auth Completed!");
            },
            verificationFailed: (FirebaseAuthException e) {
              ApiWrapper.showToastMessage("Auth Failed!");
            },
            codeSent: (String verificationId, int? resendToken) {
              ApiWrapper.showToastMessage("OTP Sent!");
              setState(() {});

              isLoading = false;
              Get.to(() => Verification(
                  verID: verificationId, number: number.text, type: "Reset"));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              ApiWrapper.showToastMessage("Timeout!");
            },
          );
        } else {
          setState(() {});
          isLoading = false;
          ApiWrapper.showToastMessage(
              "Unable to process request. Please retry.");
        }
      }
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Ink(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade200)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 12),
                              Image.asset("image/Call1.png", scale: 3.5),
                              cpicker(),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: SizedBox(
                          width: Get.width * 0.60,
                          child: Customtextfild.textField(
                            controller: number,
                            name1: "Enter Number",
                            labelclr: Colors.grey,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            textcolor: notifire.getwhitecolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height / 20),
              !isLoading
                  ? GestureDetector(
                      onTap: () {
                        if (number.text.isNotEmpty) {
                          verifyPhone(
                              "${_selectedCountryCode}" "${number.text}");
                        } else {
                          ApiWrapper.showToastMessage(
                              "Please fill required field!");
                        }
                      },
                      child: Custombutton.button(
                        notifire.getbuttonscolor,
                        "SEND",
                        SizedBox(width: width / 3.5),
                        SizedBox(width: width / 7),
                      ),
                    )
                  : CircularProgressIndicator(color: notifire.getbuttonscolor),
            ],
          ),
        ),
      ),
    );
  }

  cpicker() {
    var countryDropDown = Ink(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              value: _selectedCountryCode,
              items: x.countryCode.map((value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.grey)));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountryCode = value;
                });
              },
              style: Theme.of(context).textTheme.headline6),
        ),
      ),
    );
    return countryDropDown;
  }
}
