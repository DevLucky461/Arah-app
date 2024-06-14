import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/profile_me/register_info1.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobileRegister();
}

class _MobileRegister extends State<MobileRegister> {
  final dataKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  RegExp emailRegExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String ErrorName = '';
  String ErrorEmail = '';
  bool click = false;

  bool entered = true;

  @override
  void initState() {
    super.initState();

    _nameController.text = user.full_name;
    _emailController.text = user.email;
    _numberController.text = user.phone;

    entered = true;

    KeyboardVisibilityController keyboardVisibilityController =
        KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && entered) Scrollable.ensureVisible(dataKey.currentContext);
    });
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
          image: DecorationImage(
              image: AssetImage('assets/arah/splash_back_grey.png'),
              fit: BoxFit.fill),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back_sharp,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  alignment: Alignment.topLeft,
                ),
                SizeArah(60, 0),
                Image.asset(
                  'assets/arah/arah_logo.png',
                  alignment: Alignment.topLeft,
                  height: 59,
                  width: 60,
                ),
                Row(
                  children: [
                    Text(
                      'Arah',
                      style: GoogleFonts.lato(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF49B6A9)),
                      textAlign: TextAlign.center,
                    ),
                    SizeArah(0, 5),
                    TextArah(Languages.of(context).Registration_Page),
                  ],
                ),
                SizeArah(30, 0),
                TextArahContent(Languages.of(context).full_name + "*"),
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.lato(
                            color: Color(0xFFDFE4E9), fontSize: 22),
                        counterText: '',
                        hintText: 'Hasan Prasetyo',
                      ),
                      style: GoogleFonts.lato(fontSize: 22),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      maxLength: 30),
                ),
                SizeArah(5, 0),
                Visibility(
                  visible: ErrorName != "",
                  child: Text(
                    ErrorName,
                    style: GoogleFonts.lato(color: Colors.red),
                  ),
                ),
                SizeArah(10, 0),
                TextArahContent(Languages.of(context).email + "*"),
                Container(
                  child: TextFormField(
                      key: dataKey,
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.lato(
                            color: Color(0xFFDFE4E9), fontSize: 22),
                        counterText: '',
                        hintText: 'example@gmail.com',
                      ),
                      style: GoogleFonts.lato(fontSize: 22),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      maxLength: 30),
                ),
                SizeArah(5, 0),
                Visibility(
                  visible: ErrorEmail != "",
                  child: Text(
                    ErrorEmail,
                    style: GoogleFonts.lato(color: Colors.red),
                  ),
                ),
                SizeArah(10, 0),
                TextArahContent(Languages.of(context).phone_number + "*"),
                Container(
                  child: TextFormField(
                      enabled: false,
                      style: GoogleFonts.lato(fontSize: 22),
                      controller: _numberController),
                ),
                SizeArah(35, 0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  bool hasError = false;
                                  ErrorName = "";
                                  ErrorEmail = "";
                                  if (_nameController.text.trim().isEmpty) {
                                    hasError = true;
                                    ErrorName =
                                        Languages.of(context).enter_full_name;
                                  }
                                  if (_emailController.text.trim().isEmpty ||
                                      !emailRegExp.hasMatch(
                                          _emailController.text.trim())) {
                                    hasError = true;
                                    ErrorEmail =
                                        Languages.of(context).enter_email;
                                  }
                                  if (!hasError) {
                                    setState(() => click = true);
                                    checkEmail();
                                  } else
                                    setState(() {});
                                },
                                color: color_primary,
                                textColor: arah_white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                child: Text(
                                  Languages.of(context).Continue,
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkEmail() async {
    Map<String, dynamic> info = new Map();
    info['full_name'] = _nameController.text;
    info['email'] = _emailController.text;
    if (_emailController.text == user.email) {
      setState(() {
        click = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterInfo1(info)));
    } else {
      CallApi api = CallApi();

      var data = {
        'token': await api.getToken(),
        'email': _emailController.text,
      };

      var res = await api.postData(data, 'check-token', context);
      var body = json.decode(res.body);
      setState(() {
        click = false;
      });
      if (body['success'] != null && body['success']) {
        if (body['user'] != null)
          setState(() => ErrorEmail = Languages.of(context).registered_email);
        else
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RegisterInfo1(info)));
      } else
        showToast(Languages.of(context).error_occurred);
    }
  }
}
