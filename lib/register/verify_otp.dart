import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/register/finish_account.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class RegisterVerifyOTP extends StatefulWidget {
  final String Mobile;
  bool isExistingUser;

  String OTP;
  var body;

  RegisterVerifyOTP(this.isExistingUser, this.Mobile, this.OTP, this.body);
  @override
  State<StatefulWidget> createState() => _RegisterVerifyOTP();
}

class _RegisterVerifyOTP extends State<RegisterVerifyOTP> {
  final dataKey = new GlobalKey();
  TextEditingController _numberController = TextEditingController();
  String errorPhone = '';

  String otp = "";
  bool click = false;

  bool entered = true;
  bool timerExceed = false;
  int _start = 0;
  Timer _timer;
  bool otpfield = false;
  String enteredOTP = '';

  void startTimer() {
    if (_timer != null) _timer.cancel();
    _start = 20;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          errorPhone = Languages.of(context).Resend_Code;
          timerExceed = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && entered) Scrollable.ensureVisible(dataKey.currentContext);
    });

    super.initState();
    entered = true;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    entered = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        // height: getScreenHeight(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color_second, color_primary]),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                height: getScreenWidth(context) / 2,
                width: getScreenWidth(context),
                child: Stack(
                  children: [
                    InkWell(
                      child: Image.asset(
                        'assets/arah/icon-back.png',
                        color: Colors.white,
                        height: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.topCenter,
                      child: Text(
                        Languages.of(context).verify_phone,
                        style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Image.asset('assets/arah/launchscreen-splashfx.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: getScreenWidth(context) / 2.5),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/arah/login-page-bg.png"),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.transparent,
                  ),
                  height: double.infinity,
                  padding: const EdgeInsets.only(top: 80),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Languages.of(context).SMS_send,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: color_light_grey,
                          ),
                        ),
                        SizeArah(20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 50, 30, 5),
                          child: OTPTextField(
                            length: 5,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 60,
                            style: TextStyle(fontSize: 18),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) {
                              print("Completed: " + pin);
                              if (pin == widget.OTP) {
                                // Go to next page
                                this.otp = pin;
                                showToast("Verify Success");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FinishAccount(widget.Mobile)));
                              }
                            },
                          ),
                        ),
                        timerExceed
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    timerExceed = false;
                                    callgetPhone();
                                  });
                                },
                                child: Text(
                                  errorPhone,
                                  style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Text(
                                Languages.of(context).Resend_Code_in +
                                    '00:' +
                                    '$_start'.padLeft(2, '0'),
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.left,
                              ),
                        SizeArah(30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getScreenWidth(context) / 2 - 100),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/arah/login-page-frame.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/arah/phone-verify.png',
                  ),
                  height: 130,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callgetPhone() async {
    var data = {
      'phone_number': widget.Mobile,
    };

    CallApi api = CallApi();
    var res = await api.postData(data, 'get-phone', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      widget.OTP = body['OTP'];
      print("OTP_________ " + widget.OTP);

      bool isExistingUser = false;

      if (body['user'].toString() != '[]') isExistingUser = true;

      widget.isExistingUser = isExistingUser;
      widget.body = body;
      setState(() {
        startTimer();
      });
    } else
      showToast(Languages.of(context).error_occurred);
  }
}
