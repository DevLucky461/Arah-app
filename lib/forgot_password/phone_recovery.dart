import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/forgot_password/email_recovery.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class PhoneRecovery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneRecovery();
}

class _PhoneRecovery extends State<PhoneRecovery> {
  final dataKey = new GlobalKey();
  TextEditingController _numberController = TextEditingController();
  String errorPhone = '';
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
                          Languages.of(context).forgot_password_title,
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
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            Languages.of(context).provide_mobile,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: color_light_grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 70, 30, 5),
                            child: Row(
                              children: [
                                Container(
                                  child: CountryCodePicker(
                                    onChanged: _onCountryChange,
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: 'MY',
                                    showDropDownButton: false,
                                    flagDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: color_shadow, spreadRadius: 0.3),
                                    ],
                                  ),
                                ),
                                SizeArah(0, 5),
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
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, EmailRecovery());
                            },
                            child: Text(
                              Languages.of(context).reset_via_email,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                              ),
                            ),
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
                          SizeArah(30),
                          click
                              ? Center(child: CircularProgressIndicator())
                              : RaisedGradientButton(
                                  onPressed: () {
                                    errorPhone = "";
                                    if (_numberController.text.trim().isNotEmpty) {
                                      setState(() => click = true);
                                      getCode(countryCode + _numberController.text);
                                    } else
                                      setState(
                                          () => errorPhone = Languages.of(context).enter_mobile_no);
                                  },
                                  gradient: LinearGradient(
                                      colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text(
                                      Languages.of(context).send,
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
    print("New Country selected: " + code.toString());
  }

  void getCode(String phone) async {
    var data = {
      'phone_number': phone,
    };

    CallApi api = CallApi();
    var res = await api.postData(data, 'forgot-password-phone', context);
    var body = json.decode(res.body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      showToast('Please check SMS');
    } else {
      if (body['message'].toString() == '21211')
        setState(() => errorPhone = Languages.of(context).invalid_mobile_no);
      else
        showToast(Languages.of(context).error_occurred);
    }
  }
}
