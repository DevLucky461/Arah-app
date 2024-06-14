import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/forgot_password/email_recovery.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/mobile_login.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'landing_page.dart';

class EmailLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailLogin();
}

class _EmailLogin extends State<EmailLogin> {
  final dataKey = new GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorEmail = '';
  String noPassword = '';

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
                          Languages.of(context).Log_In_Email,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: Colors.grey,
                                ),
                                counterText: '',
                                hintText: Languages.of(context).Username_email,
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
                              controller: _nameController,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
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
                                navigateTo(context, EmailRecovery());
                              },
                              child: Text(
                                Languages.of(context).forgot_password,
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
                          visible: errorEmail != "",
                          child: Text(
                            errorEmail,
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
                                    errorEmail = "";
                                    noPassword = '';
                                    if (_nameController.text.trim().isNotEmpty &&
                                        _passwordController.text.trim().isNotEmpty) {
                                      setState(() => click = true);
                                      loginWithEmail(
                                          _nameController.text, _passwordController.text);
                                    } else if (_nameController.text.trim().isEmpty) {
                                      setState(
                                          () => errorEmail = Languages.of(context).enter_email);
                                    } else if (_passwordController.text.trim().isEmpty) {
                                      setState(() =>
                                          noPassword = Languages.of(context).enter_password_no);
                                    }
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
                            navigateTo(context, MobileLogin());
                          },
                          child: Text(
                            Languages.of(context).Log_using_Phone,
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

  void loginWithEmail(String email, String password) async {
    var data = {'email': email, 'password': password};
    CallApi api = CallApi();
    var res = await api.postData(data, 'email-login', context);
    var body = json.decode(res.body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      CallApi().storeToken(body['token']);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LandingPage()));
    } else {
      if (body['message'].toString() == '21211')
        setState(() => errorEmail = Languages.of(context).enter_email);
      else
        showToast(Languages.of(context).error_occurred);
    }
  }
}
