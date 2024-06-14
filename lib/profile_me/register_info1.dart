import 'dart:async';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/profile_me/register_info2.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterInfo1 extends StatefulWidget {
  Map<String, dynamic> info;

  RegisterInfo1(this.info);

  @override
  State<StatefulWidget> createState() => _RegisterInfo1();
}

enum Gender { male, female }

class _RegisterInfo1 extends State<RegisterInfo1> {
  final dataKey = GlobalKey();
  TextEditingController _nricController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  Gender gender = Gender.male;

  String ErrorNric = '';
  String ErrorDob = '';

  bool entered = true;

  @override
  void initState() {
    super.initState();

    _nricController.text = user.nric;
    _dobController.text = user.dob;
    gender = user.gender == 'female' ? Gender.female : Gender.male;

    entered = true;

    KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

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
              image: AssetImage('assets/arah/splash_back_grey.png'), fit: BoxFit.fill),
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
                          fontSize: 25, fontWeight: FontWeight.w900, color: Color(0xFF49B6A9)),
                      textAlign: TextAlign.center,
                    ),
                    SizeArah(0, 5),
                    TextArah(Languages.of(context).Registration_Page),
                  ],
                ),
                SizeArah(30, 0),
                TextArahContent(Languages.of(context).id_number + "*"),
                TextArahDescription(Languages.of(context).for_verification),
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.lato(color: Color(0xFFDFE4E9), fontSize: 22),
                        counterText: '',
                        hintText: '',
                      ),
                      style: GoogleFonts.lato(fontSize: 22),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _nricController,
                      maxLength: 20),
                ),
                SizeArah(5, 0),
                Visibility(
                  visible: ErrorNric != "",
                  child: Text(
                    ErrorNric,
                    style: GoogleFonts.lato(color: Colors.red),
                  ),
                ),
                SizeArah(10, 0),
                TextArahContent(Languages.of(context).date_of_birth + "*"),
                TextArahDescription(Languages.of(context).for_verification),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate();
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                        decoration: InputDecoration(
                          hintStyle: GoogleFonts.lato(color: Color(0xFFDFE4E9), fontSize: 22),
                          counterText: '',
                          hintText: '2000-01-10',
                        ),
                        style: GoogleFonts.lato(fontSize: 22),
                        controller: _dobController),
                  ),
                ),
                SizeArah(5, 0),
                Visibility(
                  visible: ErrorDob != "",
                  child: Text(
                    ErrorDob,
                    style: GoogleFonts.lato(color: Colors.red),
                  ),
                ),
                SizeArah(10, 0),
                TextArahContent(Languages.of(context).gender),
                Row(
                  key: dataKey,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: TextArahContent(Languages.of(context).male),
                        leading: Radio<Gender>(
                          value: Gender.male,
                          groupValue: gender,
                          onChanged: (Gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: TextArahContent(Languages.of(context).female),
                        leading: Radio<Gender>(
                          value: Gender.female,
                          groupValue: gender,
                          onChanged: (Gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizeArah(30, 0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: RaisedButton(
                          padding: EdgeInsets.all(15),
                          onPressed: () {
                            bool hasError = false;
                            ErrorNric = "";
                            ErrorDob = "";
                            if (_nricController.text.trim().isEmpty) {
                              hasError = true;
                              ErrorNric = Languages.of(context).enter_nric;
                            }
                            if (_dobController.text.trim().isEmpty) {
                              hasError = true;
                              ErrorDob = Languages.of(context).select_dob;
                            }
                            setState(() {});
                            if (!hasError) {
                              widget.info['id_number'] = _nricController.text.trim();
                              widget.info['dob'] = _dobController.text.trim();
                              widget.info['gender'] = gender == Gender.male ? 'male' : 'female';
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterInfo2(widget.info)));
                            }
                          },
                          color: color_primary,
                          textColor: arah_white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                          child: Text(
                            Languages.of(context).Continue,
                            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
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
}
