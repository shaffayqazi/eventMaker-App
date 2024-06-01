// ignore_for_file: prefer_final_fields, body_might_complete_normally_nullable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/login_signup/login.dart';
import 'package:goevent2/login_signup/verification.dart';
import 'package:goevent2/utils/AppWidget.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';
import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/ctextfield.dart';
import '../utils/itextfield.dart';
import '../utils/media.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool status = false;
  final auth = FirebaseAuth.instance;
  late ColorNotifire notifire;
  final name = TextEditingController();
  final number = TextEditingController();
  final email = TextEditingController();
  final fpassword = TextEditingController();
  final spassword = TextEditingController();
  final referral = TextEditingController();
  String? _selectedCountryCode = '+91';
  List<String> _countryCodes = ['+91', '+23'];

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  bool _obscureText = true;
  bool obscureText_ = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void toggle() {
    setState(() {
      obscureText_ = !obscureText_;
    });
  }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: height / 20),
              Row(
                children: [
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
              SizedBox(height: height / 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy Medium',
                                  color: notifire.getwhitecolor),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 40),
                        Customtextfild.textField(
                          controller: name,
                          name1: "Name",
                          labelclr: Colors.grey,
                          textcolor: notifire.getwhitecolor,
                          prefixIcon:
                              Image.asset("image/Profile.png", scale: 3.5),
                        ),
                        SizedBox(height: height / 40),
                        Customtextfild.textField(
                          controller: email,
                          name1: "Email",
                          labelclr: Colors.grey,
                          textcolor: notifire.getwhitecolor,
                          prefixIcon:
                              Image.asset("image/Message.png", scale: 3.5),
                        ),
                        SizedBox(height: height / 40),
                        Ink(
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
                                          width: 1,
                                          color: Colors.grey.shade200)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 12),
                                      Image.asset("image/Call1.png",
                                          scale: 3.5),
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
                                    name1: "Mobile number",
                                    keyboardType: TextInputType.number,
                                    labelclr: Colors.grey,
                                    textcolor: notifire.getwhitecolor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height / 40),
                        Customtextfild2.textField(
                          fpassword,
                          _obscureText,
                          "Your password",
                          Colors.grey,
                          notifire.getwhitecolor,
                          "image/Lock.png",
                          GestureDetector(
                              onTap: () {
                                _toggle();
                              },
                              child: _obscureText
                                  ? Image.asset("image/Hide.png", scale: 3.5)
                                  : Image.asset("image/Show.png", scale: 3.5)),
                        ),
                        SizedBox(height: height / 40),
                        Customtextfild2.textField(
                          spassword,
                          obscureText_,
                          "Confirm password",
                          Colors.grey,
                          notifire.getwhitecolor,
                          "image/Lock.png",
                          GestureDetector(
                              onTap: () {
                                toggle();
                              },
                              child: obscureText_
                                  ? Image.asset("image/Hide.png", height: 22)
                                  : Image.asset("image/Show.png", height: 22)),
                        ),
                        SizedBox(height: height / 40),
                        Customtextfild.textField(
                          controller: referral,
                          name1: "Referral code",
                          labelclr: Colors.grey,
                          textcolor: notifire.getwhitecolor,
                          keyboardType: TextInputType.number,
                          prefixIcon:
                              Image.asset("image/Discount-1.png", scale: 3.5),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Row(
                          children: [
                            Ink(
                              width: Get.width * 0.12,
                              child: Transform.scale(
                                scale: 0.7,
                                child: CupertinoSwitch(
                                  activeColor: notifire.getbuttonscolor,
                                  value: status,
                                  onChanged: (value) {
                                    setState(() {});
                                    status = value;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.015),
                            //By continuing, you agree to GoEvent's Terms of Use and Privacy Policy.
                            Center(
                              child: RichText(
                                text: TextSpan(
                                    text: "By continuing, ",
                                    style: TextStyle(
                                        color: notifire.getwhitecolor,
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: "You agree to GoEvent's \n"),
                                      TextSpan(
                                          text: 'Terms of Use ',
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2.5),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchInBrowser(Uri.parse(
                                                  "https://pub.dev/"));
                                            }),
                                      const TextSpan(text: "and "),
                                      TextSpan(
                                          text: 'Privacy Policy.',
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2.5),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchInBrowser(Uri.parse(
                                                  "https://pub.dev/"));
                                            }),
                                    ]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: Get.height * 0.10),
                        GestureDetector(
                          onTap: () {
                            authSignUp();
                          },
                          child: Custombutton.button(
                            notifire.getbuttonscolor,
                            "SIGN UP",
                            SizedBox(width: width / 4),
                            SizedBox(width: width / 5),
                          ),
                        ),
                        SizedBox(height: Get.height / 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  color: notifire.getwhitecolor,
                                  fontSize: 14.sp,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const Login(),
                                    duration: Duration.zero);
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Color(0xff5669FF),
                                    fontFamily: 'Gilroy Medium'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget log(clr, name, img, clr2) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.to(() => const Home(), duration: Duration.zero);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: clr),
          height: height / 15,
          width: width / 1.5,
          child: Row(
            children: [
              SizedBox(width: width / 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Image.asset(img)),
              SizedBox(width: width / 20),
              Text(
                name,
                style: TextStyle(
                    color: clr2,
                    fontFamily: 'Gilroy Medium',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400),
              ),
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
              items: _countryCodes.map((String value) {
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

//
  authSignUp() {
    FocusScope.of(context).requestFocus(FocusNode());

    var mcheck = {"mobile": number.text};

    if (name.text.isNotEmpty &&
            email.text.isNotEmpty &&
            number.text.isNotEmpty &&
            fpassword.text.isNotEmpty &&
            spassword.text.isNotEmpty
        // &&        referral.text.isNotEmpty
        ) {
      if ((RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
          .hasMatch(email.text))) {
        if (fpassword.text == spassword.text) {
          if (status == true) {
            ApiWrapper.dataPost(Config.mobilecheck, mcheck).then((val) {
              if ((val != null) && (val.isNotEmpty)) {
                if (val["Result"] == "true") {
                  var register = {
                    "UserName": name.text.trim(),
                    "Usernumber": number.text.trim(),
                    "UserEmail": email.text.trim(),
                    "Ccode": _selectedCountryCode,
                    "FPassword": fpassword.text.trim(),
                    "SPassword": spassword.text.trim(),
                    "ReferralCode": referral.text.trim(),
                  };
                  save("User", register);

                  // Get.to(() => Verification(verID: '', number: number.text));
                  verifyPhone("${_selectedCountryCode}" "${number.text}");
                } else {
                  ApiWrapper.showToastMessage(val['ResponseMsg']);
                }
              }
            });
          } else {
            ApiWrapper.showToastMessage("Accept terms & Condition is required");
          }
        } else {
          ApiWrapper.showToastMessage("password not match");
        }
      } else {
        ApiWrapper.showToastMessage('Please enter valid email address');
      }
    } else {
      ApiWrapper.showToastMessage("Please fill required field!");
    }
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
        // verID = verificationId;
        Get.to(() => Verification(verID: verificationId, number: number));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }
}
