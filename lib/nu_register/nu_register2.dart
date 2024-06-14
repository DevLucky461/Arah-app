import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'nu_register3.dart';

class NURegister2 extends StatefulWidget {
  @override
  Map<String, dynamic> info;

  NURegister2(this.info);
  State<StatefulWidget> createState() => _NURegister2();
}

class _NURegister2 extends State<NURegister2> {
  final dataKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  RegExp emailRegExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String ErrorName = '';
  String ErrorEmail = '';
  String ErrorPassword = '';
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
                            children: showStep(1, 4),
                          ),
                          Text(
                            Languages.of(context).Step + " 2 " + Languages.of(context).oof + " 4",
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
                      TextArahContent(Languages.of(context).name + "*"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                                fontSize: 16,
                              ),
                              counterText: '',
                              hintText: 'Username',
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
                      TextArahContent(Languages.of(context).email),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                                fontSize: 16,
                              ),
                              counterText: '',
                              hintText: 'example@gmail.com',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize: 16,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
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
                        visible: ErrorEmail != "",
                        child: Text(
                          ErrorEmail,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizeArah(10),
                      TextArahContent(Languages.of(context).password + "*"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                            key: dataKey,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                                fontSize: 16,
                              ),
                              counterText: '',
                              hintText: 'Password',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize: 16,
                            ),
                            controller: _passwordController,
                            obscureText: true,
                            maxLength: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ErrorPassword != "",
                        child: Text(
                          ErrorPassword,
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
                                  bool hasError = false;
                                  ErrorName = "";
                                  ErrorEmail = "";
                                  ErrorPassword = '';
                                  if (_nameController.text.trim().isEmpty) {
                                    hasError = true;
                                    setState(() {
                                      ErrorName = Languages.of(context).enter_full_name;
                                    });
                                  }
                                  if (_emailController.text.trim().isNotEmpty) {
                                    if (!emailRegExp.hasMatch(_emailController.text.trim())) {
                                      hasError = true;
                                      setState(() {
                                        ErrorEmail = Languages.of(context).enter_email;
                                      });
                                    }
                                  }
                                  if (_passwordController.text.trim().isEmpty) {
                                    hasError = true;
                                    setState(() {
                                      ErrorPassword = Languages.of(context).enter_mobile_no;
                                    });
                                  }
                                  if (!hasError) {
                                    setState(() => click = true);
                                    gotoStep3();
                                    setState(() => click = false);
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

  void gotoStep3() async {
    Map<String, dynamic> info = new Map();
    info['user_name'] = _nameController.text;
    info['email'] = _emailController.text;
    info['password'] = _passwordController.text;
    info['full_name'] = widget.info['full_name'];
    info['phone'] = widget.info['phone'];
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => NURegister3(info)));
    // if (_emailController.text == user.email) {
    //   setState(() {
    //     click = false;
    //   });
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => NURegister2(info)));
    // } else {
    //   CallApi api = CallApi();

    //   var data = {
    //     'token': await api.getToken(),
    //     'email': _emailController.text,
    //   };

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
