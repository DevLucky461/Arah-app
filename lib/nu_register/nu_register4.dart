import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NURegister4 extends StatefulWidget {
  Map<String, dynamic> info;

  NURegister4(this.info);
  @override
  State<StatefulWidget> createState() => _NURegister4();
}

class _NURegister4 extends State<NURegister4> {
  final dataKey = GlobalKey();

  String occupation = occupationList[0];
  String income = incomeList[0];
  String state = stateList[0];

  bool click = false;

  bool entered = true;

  @override
  void initState() {
    entered = true;

    occupation = user.occupation != null && occupationList.contains(user.occupation)
        ? user.occupation
        : occupationList[0];
    income = user.income != null && incomeList.contains(user.income) ? user.income : incomeList[0];
    state = user.state != null && stateList.contains(user.state) ? user.state : stateList[0];
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
                        Languages.of(context).finish_registration,
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
                            children: showStep(3, 4),
                          ),
                          Text(
                            Languages.of(context).Step + " 4 " + Languages.of(context).oof + " 4",
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
                      TextArahContent(Languages.of(context).occupation),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton(
                          value: occupation,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: const TextStyle(fontSize: 16, color: color_light_grey),
                          underline: Container(height: 0, color: Color(0xFFDEDEDE)),
                          onChanged: (value) {
                            setState(() {
                              occupation = value.toString();
                            });
                          },
                          items: occupationList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                          ],
                        ),
                      ),
                      SizeArah(15),
                      TextArahContent(Languages.of(context).estimate_income + " (Rupiah)"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton(
                          value: income,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: const TextStyle(fontSize: 16, color: color_light_grey),
                          underline: Container(height: 0, color: Color(0xFFDEDEDE)),
                          onChanged: (value) {
                            setState(() {
                              income = value.toString();
                            });
                          },
                          items: incomeList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                          ],
                        ),
                      ),
                      SizeArah(15),
                      TextArahContent(Languages.of(context).state_of_residency +
                          "(" +
                          Languages.of(context).optional +
                          ")"),
                      SizeArah(5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton(
                          value: state,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: const TextStyle(fontSize: 16, color: color_light_grey),
                          underline: Container(height: 0, color: Color(0xFFDEDEDE)),
                          onChanged: (value) {
                            setState(() {
                              state = value.toString();
                            });
                          },
                          items: stateList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                          ],
                        ),
                      ),
                      SizeArah(30),
                      Align(
                        alignment: Alignment.center,
                        child: click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedGradientButton(
                                onPressed: () {
                                  bool hasError = false;
                                  if (!hasError) {
                                    setState(() => click = true);
                                    finishRegister();
                                  }
                                },
                                border: Border.all(color: Colors.transparent, width: 2),
                                gradient:
                                    LinearGradient(colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    Languages.of(context).Complete,
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

  void finishRegister() async {
    Map<String, dynamic> info = new Map();
    info['full_name'] = widget.info['full_name'];
    info['phone'] = widget.info['phone'];
    info['user_name'] = widget.info['user_name'];
    info['email'] = widget.info['email'];
    info['password'] = widget.info['password'];
    info['id_number'] = widget.info['id'];
    info['dob'] = widget.info['dob'];
    info['gender'] = widget.info['gender'];
    info['occupation'] = this.occupation;
    info['income'] = this.income;
    info['state'] = this.state;
    info['nu_member'] = 'yes';

    CallApi api = CallApi();
    var token = await api.getToken();
    info['token'] = token;
    print(info);
    var res = await api.postData(info, 'register', context);
    var body = json.decode(res.body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      showToast(body['message']);
      setState(() => click = false);
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 5);
    } else {
      showToast(Languages.of(context).error_occurred);
    }
  }
}
