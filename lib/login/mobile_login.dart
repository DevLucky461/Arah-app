import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/forgot_password/phone_recovery.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/email_login.dart';
import 'package:arah_app/login/landing_page.dart';
import 'package:arah_app/login/otp_login.dart';
import 'package:arah_app/login/verify_otp.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MobileLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobileLogin();
}

class _MobileLogin extends State<MobileLogin> {
  final dataKey = new GlobalKey();
  final passwordKey = new GlobalKey();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorPhone = '';
  String noPassword = '';
  String countryCode = '60';

  String otp = "";
  bool click = false;

  bool entered = true;

  @override
  void initState() {
    entered = true;

    KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && entered) Scrollable.ensureVisible(dataKey.currentContext);
    });

    super.initState();
  }

  @override
  void dispose() {
    entered = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: getScreenHeight(context),
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
                          Languages.of(context).Log_In_Phone,
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
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: Languages.of(context).Welcome_to,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' Arah',
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: color_primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 50, 30, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: CountryCodePicker(
                                      onChanged: _onCountryChange,
                                      initialSelection: 'MY',
                                      showDropDownButton: false,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: color_shadow, spreadRadius: 0.3),
                                      ],
                                    ),
                                  ),
                                  SizeArah(0, 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        key: dataKey,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                            fontFamily: 'MontserratSemiBold',
                                            color: Colors.grey,
                                          ),
                                          counterText: '',
                                          hintText: Languages.of(context).phone_number,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'MontserratSemiBold',
                                          color: color_light_grey,
                                        ),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.phone,
                                        controller: _numberController,
                                        maxLength: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(color: color_shadow, spreadRadius: 0.3),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              key: passwordKey,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: Colors.grey,
                                ),
                                counterText: '',
                                hintText: Languages.of(context).password,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                              ),
                              obscureText: true,
                              controller: _passwordController,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: color_shadow, spreadRadius: 0.3),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                navigateTo(context, PhoneRecovery());
                              },
                              child: Text(
                                Languages.of(context).forgot_password + "   |",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: color_light_grey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                errorPhone = "";
                                setState(() => click = false);
                                navigateTo(context, OTPLogin());
                              },
                              child: Text(
                                Languages.of(context).login_via_otp,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: color_light_grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: errorPhone != "",
                          child: Text(
                            errorPhone,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: noPassword != "",
                          child: Text(
                            noPassword,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizeArah(30),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: click
                              ? Center(child: CircularProgressIndicator())
                              : RaisedGradientButton(
                                  onPressed: () {
                                    errorPhone = "";
                                    noPassword = '';
                                    if (_numberController.text.trim().isNotEmpty &&
                                        _passwordController.text.trim().isNotEmpty) {
                                      setState(() => click = true);
                                      loginWithPassword(countryCode + _numberController.text,
                                          _passwordController.text);
                                    } else if (_numberController.text.trim().isEmpty) {
                                      setState(
                                          () => errorPhone = Languages.of(context).enter_mobile_no);
                                    } else
                                      setState(() =>
                                          noPassword = Languages.of(context).enter_password_no);
                                  },
                                  gradient: LinearGradient(
                                      colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text(
                                      Languages.of(context).Log_In,
                                      style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateTo(context, EmailLogin());
                          },
                          child: Text(
                            Languages.of(context).Log_using_Email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: color_dark_grey,
                            ),
                          ),
                        )
                      ],
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
                    padding: EdgeInsets.only(top: 15, bottom: 28),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/arah/arah_getstarted.png',
                    ),
                    height: 130,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode code) {
    this.countryCode = code.toString().replaceAll("+", "");
    print("New Country selected: " + code.toString().replaceAll("+", ""));
  }

  void loginWithPassword(String phone, String password) async {
    var data = {'phone_number': phone, 'password': password};
    CallApi api = CallApi();
    var res = await api.postData(data, 'phone-login', context);
    var body = json.decode(res.body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      CallApi().storeToken(body['token']);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LandingPage()));
    } else {
      if (body['message'].toString() == '21211')
        setState(() => errorPhone = Languages.of(context).invalid_mobile_no);
      else
        showToast(Languages.of(context).error_occurred);
    }
  }

  void getCode(String phone) async {
    var data = {'phone_number': phone};

    CallApi api = CallApi();
    var res = await api.postData(data, 'get-phone', context);
    var body = json.decode(res.body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      otp = body['OTP'];

      print("OTP_________ " + otp);
      print("User = = > " + body['user']);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  LoginVerifyOTP(body['user'] != null, phone, otp, body)));
    } else {
      if (body['message'].toString() == '21211')
        setState(() => errorPhone = Languages.of(context).invalid_mobile_no);
      else
        showToast(Languages.of(context).error_occurred);
    }
  }
}
