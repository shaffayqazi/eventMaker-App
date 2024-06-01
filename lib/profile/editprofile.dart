// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/botton.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/wtextfield.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late ColorNotifire notifire;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();

  String? path;
  var userdata;
  String? networkimage;
  String? base64Image;
  final ImagePicker imgpicker = ImagePicker();
  PickedFile? imageFile;
  List imageList = [];
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

    getData.read("UserLogin") != null
        ? setState(() {
            name.text = getData.read("UserLogin")["name"] ?? "";
            number.text = getData.read("UserLogin")["mobile"] ?? "";
            email.text = getData.read("UserLogin")["email"] ?? "";
            password.text = getData.read("UserLogin")["password"] ?? "";
            networkimage = getData.read("UserLogin")["pro_pic"] ?? "";
            getData.read("UserLogin")["pro_pic"] != "null"
                ? setState(() {
                    networkimageconvert();
                  })
                : const SizedBox();
          })
        : null;
  }

//! network base64Image
  networkimageconvert() {
    (() async {
      http.Response response = await http
          .get(Uri.parse(Config.imageURLPath + networkimage.toString()));
      if (mounted) {
        print(response.bodyBytes);
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
          // _bytesImage = Base64Decoder().convert(_imgString);
          print(base64Image);
        });
      }
    })();
  }

//!  ------- String value convert to map -------
  jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: notifire.getprimerycolor,
        floatingActionButton: SizedBox(
          height: 45.h,
          width: 410.w,
          child: FloatingActionButton(
            onPressed: () {
              if ((RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email.text))) {
                saveProfile();
              } else {
                ApiWrapper.showToastMessage('Please enter valid email address');
              }
            },
            child: Custombutton.button(notifire.getbuttonscolor, "SAVE",
                SizedBox(width: width / 3.5), SizedBox(width: width / 7)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: height / 20),
            Row(
              children: [
                SizedBox(width: width / 20),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
                SizedBox(width: width / 80),
                Text("Edit Profile",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.getdarkscolor)),
                // const Spacer(),
                // Icon(Icons.more_vert, color: notifire.getdarkscolor),
                // SizedBox(width: width / 30),
              ],
            ),
            SizedBox(height: height / 25),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    _openGallery(context);
                  },
                  child: SizedBox(
                    height: Get.height * 0.146,
                    width: Get.width * 0.34,
                    child: path == null
                        ? networkimage != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.network(
                                    Config.imageURLPath + networkimage!,
                                    fit: BoxFit.cover),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: height / 17,
                                child: Image.asset("image/user.png",
                                    fit: BoxFit.cover))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.file(File(path.toString()),
                                width: width, fit: BoxFit.cover),
                          ),
                  ),
                ),
                // Center(
                //     child: Image.asset("image/p2.png", height: height / 9)),

                Positioned(
                  right: 0,
                  bottom: 4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _openGallery(context);
                      });
                    },
                    child: Container(
                      height: height / 19,
                      width: width / 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: darktextColor,
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(width / 50),
                          child: Image.asset("image/camera.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height / 60),
                    Customtextfild3.textField(
                        name,
                        notifire.getwhitecolor,
                        "Name",
                        width,
                        TextInputType.name,
                        50,
                        TextAlign.start,
                        false),
                    SizedBox(height: height / 60),
                    Customtextfild3.textField(
                        email,
                        notifire.getwhitecolor,
                        "Email",
                        width,
                        TextInputType.name,
                        50,
                        TextAlign.start,
                        false),
                    SizedBox(height: height / 60),
                    Customtextfild3.textField(
                        number,
                        notifire.getwhitecolor,
                        "Number",
                        width,
                        TextInputType.name,
                        50,
                        TextAlign.start,
                        true),
                    SizedBox(height: height / 60),
                    Customtextfild3.textField(
                        password,
                        notifire.getwhitecolor,
                        "password",
                        width,
                        TextInputType.name,
                        50,
                        TextAlign.start,
                        false),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      setState(() {});
      File imageFile = File(path.toString());

      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      log(base64Image.toString());
      imageupload(base64Image);
    }
  }

  imageupload(String? base64image) async {
    var uid = uID;
    var request =
        http.Request('POST', Uri.parse(Config.baseurl + Config.profileedit));
    request.body = '''{"uid": "$uid", "img": "$base64image"}''';
    request.headers.addAll(ApiWrapper.headers);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      ApiWrapper.showToastMessage("Profile Image Upload Successfully!!");
    } else {}
  }

  saveProfile() {
    var body = {
      "name": name.text.toString(),
      "password": password.text.toString(),
      "uid": uID,
      "email": email.text.toString()
    };

    log(body.toString(), name: "Save Update ======== >>>>> ");
    ApiWrapper.dataPost(Config.profil, body).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          save("UserLogin", jsonStringToMap(val["UserLogin"].toString()));
          log(val["UserLogin"].toString());

          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
