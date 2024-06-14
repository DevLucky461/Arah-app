import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/nu_register/nu_register4.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

enum Gender { male, female }

class NURegister3 extends StatefulWidget {
  Map<String, dynamic> info;

  NURegister3(this.info);
  @override
  State<StatefulWidget> createState() => _NURegister3();
}

class _NURegister3 extends State<NURegister3> {
  final dataKey = GlobalKey();
  TextEditingController _idController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  Gender gender = Gender.male;
  String ErrorNric = '';
  String ErrorDob = '';
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
                        Languages.of(context).package_detail,
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
                            children: showStep(2, 4),
                          ),
                          Text(
                            Languages.of(context).Step + " 3 " + Languages.of(context).oof + " 4",
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
                      TextArahContent(Languages.of(context).id_number + "*"),
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
                              hintText: '44515244643',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 18),
                            keyboardType: TextInputType.number,
                            controller: _idController,
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
                        visible: ErrorNric != "",
                        child: Text(
                          ErrorNric,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizeArah(10),
                      TextArahContent(Languages.of(context).date_of_birth + "*"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectDate();
                            },
                            child: IgnorePointer(
                              child: TextFormField(
                                  key: dataKey,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      color: color_light_grey,
                                      fontSize: 16,
                                    ),
                                    counterText: '',
                                    hintText: '1990-01-01',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize: 18,
                                  ),
                                  controller: _dobController,
                                  maxLength: 30),
                            )),
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
                        visible: ErrorDob != "",
                        child: Text(
                          ErrorDob,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizeArah(10),
                      TextArahContent(Languages.of(context).gender + "*"),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: ListTile(
                              title: TextArahContent(Languages.of(context).male),
                              leading: Radio<Gender>(
                                value: Gender.male,
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: ListTile(
                              title: TextArahContent(Languages.of(context).female),
                              leading: Radio<Gender>(
                                value: Gender.female,
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizeArah(30),
                      Text(
                        Languages.of(context).for_verification,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: color_dark_grey,
                          fontSize: 12,
                        ),
                      ),
                      SizeArah(10),
                      Align(
                        alignment: Alignment.center,
                        child: click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedGradientButton(
                                onPressed: () {
                                  bool hasError = false;
                                  ErrorNric = "";
                                  ErrorDob = "";
                                  if (_idController.text.trim().isEmpty) {
                                    hasError = true;
                                    ErrorNric = Languages.of(context).enter_nric;
                                  }
                                  if (_dobController.text.trim().isEmpty) {
                                    hasError = true;
                                    ErrorDob = Languages.of(context).select_dob;
                                  }
                                  if (!hasError) {
                                    setState(() => click = false);
                                    gotoStep4();
                                  } else
                                    setState(() {});
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

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dobController.text.trim().isEmpty
            ? DateTime.now()
            : DateTime.parse(_dobController.text.trim()),
        firstDate: new DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) setState(() => _dobController.text = picked.toString().substring(0, 10));
  }

  void gotoStep4() async {
    Map<String, dynamic> info = new Map();
    info['full_name'] = widget.info['full_name'];
    info['phone'] = widget.info['phone'];
    info['user_name'] = widget.info['user_name'];
    info['email'] = widget.info['email'];
    info['password'] = widget.info['password'];
    info['id'] = _idController.text;
    info['dob'] = _dobController.text;
    info['gender'] = this.gender == Gender.male ? "male" : "female";
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => NURegister4(info)));
    // if (_dobController.text == user.email) {
    //   setState(() {
    //     click = false;
    //   });
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => NURegister3(info)));
    // } else {
    //   CallApi api = CallApi();

    //   var data = {
    //     'token': await api.getToken(),
    //     'email': _dobController.text,
    //   };

    //   var res = await api.postData(data, 'check-token', context);
    //   var body = json.decode(res.body);
    //   setState(() {
    //     click = false;
    //   });
    //   if (body['success'] != null && body['success']) {
    //     if (body['user'] != null)
    //       setState(() => ErrorDob = Languages.of(context)!.registered_email);
    //     else
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => NURegister3(info)));
    //   } else
    //     showToast(Languages.of(context)!.error_occurred);
    // }
  }
}
