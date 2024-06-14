import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';

import 'nu_register1.dart';

class NULanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF006B8E), Color(0xFF38B9A1)]),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/arah/RegistrationPage-bg-top1.png'),
                  fit: BoxFit.fill,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              height: getScreenWidth(context) / 2,
              width: getScreenWidth(context),
              child: Stack(
                children: [
                  InkWell(
                    child: Image.asset(
                      'assets/arah/icon-back.png',
                      color: Color(0xFF006B8E),
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
                      Languages.of(context).arah_member_registration,
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 18,
                        color: Color(0xFF006B8E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: getScreenWidth(context),
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/arah/launchscreen-splashfx.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: getScreenWidth(context) / 2),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      Languages.of(context).welcome_to_registration,
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        color: Colors.white,
                      ),
                    ),
                    SizeArah(30),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white12,
                            Colors.white12,
                            Colors.white12,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      width: 240,
                      child: Text(
                        Languages.of(context).disclaimer,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      Languages.of(context).registration_disclaimer,
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        color: Colors.white,
                      ),
                    ),
                    SizeArah(30),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white12,
                            Colors.white12,
                            Colors.white12,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      width: 240,
                      child: Text(
                        Languages.of(context).note,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      Languages.of(context).registration_note,
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        color: Colors.white,
                      ),
                    ),
                    SizeArah(36),
                    RaisedGradientButton(
                      onPressed: () {
                        navigateTo(context, NURegister1());
                      },
                      border: Border.all(color: Colors.transparent, width: 2),
                      gradient: LinearGradient(colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
