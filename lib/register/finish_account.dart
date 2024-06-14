import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/register/finish_profile.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class FinishAccount extends StatefulWidget {
  final String Mobile;
  FinishAccount(this.Mobile);
  @override
  State<StatefulWidget> createState() => _FinishAccount();
}

class _FinishAccount extends State<FinishAccount> {
  final dataKey = new GlobalKey();
  String errorEmail = '';
  String errorName = '';
  String errorPassword = '';
  RegExp reg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String otp = "";
  String phone = '';
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
      resizeToAvoidBottomInset: true,
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
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.topCenter,
                        child: Text(
                          Languages.of(context).Finish_Account,
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
                        Text(
                          Languages.of(context).provide_email_or_name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: color_light_grey,
                          ),
                        ),
                        SizeArah(20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
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
                                hintText: Languages.of(context).name,
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
                                hintText: Languages.of(context).email,
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
                              controller: _emailController,
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
                        Visibility(
                          visible: errorName != "",
                          child: Text(
                            errorName,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.red,
                            ),
                          ),
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
                          visible: errorPassword != "",
                          child: Text(
                            errorPassword,
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
                                  // navigateTo(context, FinishProfile());
                                  errorEmail = "";
                                  errorName = "";
                                  errorPassword = "";
                                  if (_nameController.text.trim().isNotEmpty &&
                                      _emailController.text.trim().isNotEmpty &&
                                      _passwordController.text.trim().isNotEmpty &&
                                      reg.hasMatch(_emailController.text)) {
                                    setState(() => click = false);
                                    phone = widget.Mobile;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => FinishProfile(
                                                phone,
                                                _nameController.text,
                                                _emailController.text,
                                                _passwordController.text)));
                                  } else if (_nameController.text.trim().isEmpty) {
                                    setState(
                                        () => errorName = Languages.of(context).enter_full_name);
                                  } else if (_emailController.text.trim().isEmpty ||
                                      !reg.hasMatch(_emailController.text)) {
                                    setState(() => errorEmail = Languages.of(context).enter_email);
                                  } else if (_passwordController.text.trim().isEmpty) {
                                    setState(() =>
                                        errorPassword = Languages.of(context).enter_password_no);
                                  }
                                },
                                gradient:
                                    LinearGradient(colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    Languages.of(context).Next,
                                    style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
