import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/profile_me/register_info3.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterInfo2 extends StatefulWidget {
  Map<String, dynamic> info;

  RegisterInfo2(this.info);

  @override
  State<StatefulWidget> createState() => _RegisterInfo2();
}

class _RegisterInfo2 extends State<RegisterInfo2> {
  String occupation = occupationList[0];
  String income = incomeList[0];
  String state = stateList[0];

  @override
  void initState() {
    super.initState();

    occupation = user.occupation != null && occupationList.contains(user.occupation)
        ? user.occupation
        : occupationList[0];
    income = user.income != null && incomeList.contains(user.income) ? user.income : incomeList[0];
    state = user.state != null && stateList.contains(user.state) ? user.state : stateList[0];
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
                TextArahContent(
                    Languages.of(context).occupation + "(" + Languages.of(context).optional + ")"),
                DropdownButton(
                  value: occupation,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(fontSize: 22, color: Colors.black87),
                  underline: Container(height: 3, color: Color(0xFFDEDEDE)),
                  onChanged: (value) {
                    setState(() {
                      occupation = value;
                    });
                  },
                  items: occupationList.map<DropdownMenuItem>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizeArah(15, 0),
                TextArahContent(Languages.of(context).estimate_income + " (Rupiah)"),
                DropdownButton(
                  value: income,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(fontSize: 22, color: Colors.black87),
                  underline: Container(height: 3, color: Color(0xFFDEDEDE)),
                  onChanged: (value) {
                    setState(() {
                      income = value;
                    });
                  },
                  items: incomeList.map<DropdownMenuItem>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizeArah(15, 0),
                TextArahContent(Languages.of(context).state_of_residency +
                    "(" +
                    Languages.of(context).optional +
                    ")"),
                DropdownButton(
                  value: state,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(fontSize: 22, color: Colors.black87),
                  underline: Container(height: 3, color: Color(0xFFDEDEDE)),
                  onChanged: (value) {
                    setState(() {
                      state = value;
                    });
                  },
                  items: stateList.map<DropdownMenuItem>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                            widget.info['occupation'] = occupation;
                            widget.info['income'] = income;
                            widget.info['state'] = state;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => RegisterInfo3(widget.info)));
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
}
