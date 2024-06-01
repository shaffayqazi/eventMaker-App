// ignore_for_file: file_names, avoid_print

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AppController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/payment/InputFormater.dart';
import 'package:goevent2/payment/PayPal.dart';
import 'package:goevent2/payment/Payment_card.dart';
import 'package:goevent2/payment/StripeWeb.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/ctextfield.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWalletPage extends StatefulWidget {
  final String? amount;
  const AddWalletPage({Key? key, this.amount}) : super(key: key);

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  late Razorpay _razorpay;
  final pData = Get.put(HomeDataContro());

  final addAmount = TextEditingController();
  late ColorNotifire notifire;
  List walletitem = [];
  String? totalAmount = "0";
  int amount = 0;
  //! payment var
  String? selectidpay = "1";
  int _groupValue = 0;
  String? paymenttital;
  String ticketType = "";

  String typeid = "";
  String razorpaykey = "";

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    pData.paymentgateway();
    getdarkmodepreviousstate();
    super.initState();
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

  walletupdate() async {
    var data = {"uid": uID, "wallet": addAmount.text};

    ApiWrapper.dataPost(Config.walletup, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          Get.back();
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    walletupdate();
    // buyNoworder(response.paymentId);
    ApiWrapper.showToastMessage("Payment Successfully");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Error Response: ${"ERROR: " + response.code.toString() + " - " + response.message!}');
    ApiWrapper.showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ApiWrapper.showToastMessage(response.walletName!);
  }

  @override
  Widget build(BuildContext context) {
    print(pData.paymentList.length);
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      floatingActionButton: SizedBox(
        height: 45.h,
        width: 410.w,
        child: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (addAmount.text.isNotEmpty) {
              paymentSheet();
            } else {
              ApiWrapper.showToastMessage("please enter amount");
            }
          },
          child: Custombutton.button(
              notifire.getbuttonscolor,
              "Add".toUpperCase(),
              SizedBox(width: width / 3.5),
              SizedBox(width: width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          //! ------- AppBar -------

          Row(
            children: [
              SizedBox(width: width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: notifire.getdarkscolor),
                    SizedBox(width: width / 80),
                    Text(
                      "Add Wallet",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getdarkscolor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.03),
            child: Container(
              height: Get.height * 0.20,
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/walletTop.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mainData["currency"]}${widget.amount}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getdarkscolor),
                    ),
                    Text(
                      "Your current Balance ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: notifire.getdarkscolor),
                    ),
                    Container(height: Get.height * 0.04)
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Add Amount",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.getdarkscolor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.02),
                Customtextfild.textField(
                  controller: addAmount,
                  name1: "Amount",
                  labelclr: Colors.grey,
                  textcolor: notifire.getwhitecolor,
                  keyboardType: TextInputType.number,
                  prefixIcon: InkWell(
                    child: Image.asset("image/wallet.png",
                        scale: 3.5, color: notifire.getdarkscolor),
                    onTap: () {
                      setState(() {
                        amount = amount + 10;
                      });
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Wrap(
                  children: [
                    amountRow(
                      title: "100",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "100";
                      },
                    ),
                    amountRow(
                      title: "200",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "200";
                      },
                    ),
                    amountRow(
                      title: "300",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "300";
                      },
                    ),
                    amountRow(
                      title: "400",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "400";
                      },
                    ),
                    amountRow(
                      title: "500",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "500";
                      },
                    ),
                    amountRow(
                      title: "600",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "600";
                      },
                    ),
                    amountRow(
                      title: "700",
                      onTap: () {
                        setState(() {});

                        addAmount.text = "700";
                      },
                    ),
                    amountRow(
                      title: "800",
                      onTap: () {
                        setState(() {});
                        addAmount.text = "800";
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  amountRow({Function()? onTap, String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Get.height * 0.045,
          width: Get.width * 0.20,
          decoration: BoxDecoration(
              color: notifire.getcardcolor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300, width: 1)),
          child: Center(
            child: Text(
              title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor),
            ),
          ),
        ),
      ),
    );
  }
  //!--------------- payment --------------------

  Future paymentSheet() {
    return showModalBottomSheet(
      backgroundColor: notifire.getprimerycolor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  SizedBox(height: height / 40),
                  Center(
                    child: Container(
                      height: height / 80,
                      width: width / 5,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  SizedBox(height: height / 50),
                  Row(
                    children: [
                      SizedBox(width: width / 14),
                      Text("Select Payment Method",
                          style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: height / 40,
                              fontFamily: 'Gilroy_Bold')),
                    ],
                  ),
                  SizedBox(height: height / 50),
                  //! --------- List view paymente ----------
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: pData.paymentList.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: sugestlocationtype(
                          borderColor: selectidpay == pData.paymentList[i]["id"]
                              ? buttonColor
                              : const Color(0xffD6D6D6),
                          title: pData.paymentList[i]["title"],
                          titleColor: notifire.getdarkscolor,
                          val: 0,
                          image:
                              Config.imageURLPath + pData.paymentList[i]["img"],
                          adress: pData.paymentList[i]["subtitle"],
                          ontap: () async {
                            setState(() {
                              razorpaykey = pData.paymentList[i]["attributes"];
                              paymenttital = pData.paymentList[i]["title"];
                              selectidpay = pData.paymentList[i]["id"];
                              _groupValue = i;
                            });
                          },
                          radio: Radio(
                            activeColor: buttonColor,
                            value: i,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {});
                              // _groupValue = i;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: height / 30),
                  InkWell(
                      onTap: () {
                        //!---- Stripe Payment ------

                        if (paymenttital == "Stripe") {
                          Get.back();
                          stripePayment();
                        } else if (paymenttital == "Paypal") {
                          //!---- PayPal Payment ------
                          Get.to(() =>
                                  PayPalPayment(totalAmount: addAmount.text))!
                              .then((otid) {
                            if (otid != null) {
                              walletupdate();
                              // buyNoworder(otid);
                              ApiWrapper.showToastMessage(
                                  "Payment Successfully");
                            } else {
                              Get.back();
                            }
                          });
                        } else if (paymenttital == "Razorpay") {
                          //!---- Razorpay Payment ------
                          Get.back();
                          openCheckout();
                        }
                      },
                      child: paynowbutton()),
                  SizedBox(height: Get.height * 0.04),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget paynowbutton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: height / 16,
        width: width / 1.1,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
              "PAY NOW | "
              "${mainData["currency"]}${addAmount.text}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy_Medium')),
        ),
      ),
    );
  }

  //!--------------------------- payment Widget --------------------
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCard();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Ink(
                child: Column(
                  children: [
                    SizedBox(height: height / 45),
                    Center(
                      child: Container(
                        height: height / 85,
                        width: width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          const Text('Add Your payment information',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                          SizedBox(height: height * 0.02),
                          Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(
                                                _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6),
                                                  child: CardUtils.getCardIcon(
                                                      _paymentCard.type))),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          focusedBorder:
                                              OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                          hintText: 'What number is written on card?',
                                          labelStyle: TextStyle(color: buttonColor),
                                          labelText: 'Number')),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/card_cvv.png',
                                                          width: 6,
                                                          color: buttonColor))),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'Number behind the card',
                                              labelStyle: TextStyle(color: buttonColor),
                                              labelText: 'CVV'),
                                          validator: CardUtils.validateCVV,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            _paymentCard.cvv =
                                                int.parse(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: Get.width * 0.03),
                                      Flexible(
                                        flex: 4,
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            CardMonthInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 14),
                                                      child: Image.asset(
                                                          'image/calender.png',
                                                          width: 10,
                                                          color: buttonColor))),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: buttonColor)),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(color: buttonColor)),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                              hintText: 'MM/YY',
                                              labelStyle: TextStyle(color: buttonColor),
                                              labelText: 'Expiry Date'),
                                          validator: CardUtils.validateDate,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            List<int> expiryDate =
                                                CardUtils.getExpiryDate(value!);
                                            _paymentCard.month = expiryDate[0];
                                            _paymentCard.year = expiryDate[1];
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                      alignment: Alignment.center,
                                      child: _getPayButton()),
                                  SizedBox(height: Get.height * 0.065),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = addAmount.text;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          log(otid.toString(), name: "StripePaymentWeb irder id :: ");
          //! Api Call Payment Success
          walletupdate();
        }
      });

      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    return SizedBox(
      width: Get.width,
      child: CupertinoButton(
          onPressed: _validateInputs,
          color: buttonColor,
          child: Text("Pay ${mainData["currency"]}${addAmount.text}",
              style: const TextStyle(fontSize: 17.0))),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), duration: const Duration(seconds: 3)));
  }

  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["mobile"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(addAmount.text) * 100).toString(),
      'name': username,
      'description': ticketType,
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
}
