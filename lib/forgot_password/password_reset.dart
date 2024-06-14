import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class PasswordReset extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordReset> {
  final dataKey = new GlobalKey();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  String noPassword = '';
  String confirmPassword = '';
  String noMatch = '';

  String otp = "";
  bool click = false;

  bool entered = true;

  @override
  void initState() {
    entered = true;

    KeyboardVisibilityController keyboardVisibilityController =
        KeyboardVisibilityController();

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
      body: Container(
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
                        Languages.of(context).Create_New_Password,
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
                padding: EdgeInsets.only(top: getScreenWidth(context) / 2),
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
                      children: [
                        Text(
                          Languages.of(context).new_password_rule,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: color_light_grey,
                          ),
                        ),
                        SizeArah(20),
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
                                hintText: Languages.of(context).new_password,
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
                                BoxShadow(
                                    color: color_shadow, spreadRadius: 0.3),
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
                                hintText:
                                    Languages.of(context).confirm_password,
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
                              controller: _confirmController,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey, spreadRadius: 0.3),
                              ],
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
                        Visibility(
                          visible: confirmPassword != "",
                          child: Text(
                            confirmPassword,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: noMatch != "",
                          child: Text(
                            noMatch,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizeArah(30),
                        click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedGradientButton(
                                onPressed: () {
                                  noPassword = "";
                                  confirmPassword = "";
                                  if (_passwordController.text
                                          .trim()
                                          .isNotEmpty &&
                                      _confirmController.text
                                          .trim()
                                          .isNotEmpty &&
                                      _passwordController.text ==
                                          _confirmController.text) {
                                    setState(() => click = true);
                                    resetPassword(_passwordController.text);
                                    // getCode(_passwordController.text);
                                  } else if (_passwordController.text
                                      .trim()
                                      .isEmpty) {
                                    setState(() => noPassword =
                                        Languages.of(context)
                                            .enter_password_no);
                                  } else if (_confirmController.text
                                      .trim()
                                      .isEmpty) {
                                    setState(() => confirmPassword =
                                        Languages.of(context).enter_confirm_no);
                                  } else if (_passwordController.text !=
                                      _confirmController.text) {
                                    setState(() => noMatch =
                                        Languages.of(context)
                                            .no_match_password);
                                  }
                                },
                                gradient: LinearGradient(colors: [
                                  Color(0xFF37AFB1),
                                  Color(0xFF43C0A1)
                                ]),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    Languages.of(context).save,
                                    style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getScreenWidth(context) / 2 - 70),
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
                  height: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String new_password) {
    var data = {'new_password': new_password};

    showToast("Password Reset");

    setState(() {
      click = false;
    });
  }
}
