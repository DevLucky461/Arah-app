import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/profile_me/mobile_register.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterLanding extends StatelessWidget {
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
                TextArahContent(Languages.of(context).welcome_to_registration),
                SizeArah(40, 0),
                TextArahContent(Languages.of(context).registration_disclaimer),
                SizeArah(40, 0),
                TextArahContent(Languages.of(context).registration_note),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => MobileRegister()));
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
