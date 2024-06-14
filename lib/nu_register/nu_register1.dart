import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'nu_register2.dart';

class NURegister1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NURegister1();
}

class _NURegister1 extends State<NURegister1> {
  final dataKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  String ErrorName = '';
  String ErrorMobile = '';
  String countryCode = '60';
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
      body: Container(
        height: getScreenHeight(context),
        decoration: BoxDecoration(
          color: color_nu_grey,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/arah/RegistrationPage-bg-top2.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                height: getScreenWidth(context) * 2 / 3,
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
                        Languages.of(context).your_personal_detail,
                        style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: showStep(0, 4),
                          ),
                          Text(
                            Languages.of(context).Step + " 1 " + Languages.of(context).oof + " 4",
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getScreenWidth(context) * 2 / 3),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextArahContent(Languages.of(context).full_name + "*"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: color_light_grey,
                                  fontSize: 16),
                              counterText: '',
                              hintText: 'Hasan Prasetyo',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 16),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            controller: _nameController,
                            maxLength: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                          ],
                        ),
                      ),
                      SizeArah(5),
                      Visibility(
                        visible: ErrorName != "",
                        child: Text(
                          ErrorName,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizeArah(10),
                      TextArahContent(Languages.of(context).phone_number + "*"),
                      SizeArah(5),
                      Row(
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
                                BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                              ],
                            ),
                          ),
                          SizeArah(0, 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    color: color_light_grey,
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
                                  color: Color(0xFF828282),
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
                                  BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: ErrorMobile != "",
                        child: Text(
                          ErrorMobile,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizeArah(35),
                      Align(
                        alignment: Alignment.center,
                        child: click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedGradientButton(
                                onPressed: () {
                                  ErrorName = "";
                                  ErrorMobile = "";
                                  if (_nameController.text.trim().isEmpty) {
                                    setState(
                                        () => ErrorName = Languages.of(context).enter_full_name);
                                  } else if (_numberController.text.trim().isEmpty) {
                                    setState(
                                        () => ErrorMobile = Languages.of(context).enter_mobile_no);
                                  } else if (_numberController.text.trim().isNotEmpty &&
                                      _nameController.text.trim().isNotEmpty) {
                                    setState(() => click = false);
                                    gotoStep2();
                                  }
                                },
                                border: Border.all(color: Colors.transparent, width: 2),
                                gradient:
                                    LinearGradient(colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    Languages.of(context).Continue,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode code) {
    this.countryCode = code.toString();
    print("New Country selected: " + code.toString());
  }

  void gotoStep2() async {
    Map<String, dynamic> info = new Map();
    info['full_name'] = _nameController.text;
    info['phone'] = countryCode + _numberController.text;
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => NURegister2(info)));
    // else {
    //   CallApi api = CallApi();

    // var data = {
    //   'token': await api.getToken(),
    //   'email': _emailController.text,
    // };

    //   var res = await api.postData(data, 'check-token', context);
    //   var body = json.decode(res.body);
    //   setState(() {
    //     click = false;
    //   });
    //   if (body['success'] != null && body['success']) {
    //     if (body['user'] != null)
    //       setState(() => ErrorEmail = Languages.of(context)!.registered_email);
    //     else
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => NURegister2(info)));
    //   } else
    //     showToast(Languages.of(context)!.error_occurred);
    // }
  }
}
