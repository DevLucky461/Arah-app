import 'package:arah_app/language/languages.dart';
import 'package:arah_app/language/locale_constant.dart';
import 'package:arah_app/register/phone_register.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';

import 'lang_options.dart';
import 'mobile_login.dart';

class GetStarted extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetStarted();
}

class _GetStarted extends State<GetStarted> {
  bool showLang = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color_second, color_primary]),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    showLang = !showLang;
                  });
                },
                child: Image.asset(
                  'assets/arah/world-grid.png',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            Column(
              children: [
                SizeArah(20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/arah/launchscreen-splashfx.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 30),
                        child: Image.asset('assets/arah/arah_splash.png'),
                        height: 160,
                        width: getScreenWidth(context),
                      ),
                      SizeArah(40),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          Languages.of(context).the_worlds_first,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: getScreenWidth(context),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizeArah(10),
                        Text(
                          Languages.of(context).Welcome,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizeArah(30),
                        RaisedGradientButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MobileLogin()));
                          },
                          border: Border.all(color: Colors.transparent),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)],
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              Languages.of(context).GetStarted,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizeArah(24),
                        RaisedGradientButton(
                          onPressed: () {
                            navigateTo(context, PhoneRegister());
                          },
                          border: Border.all(color: Color(0xFF43C0A1)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              Languages.of(context).Create_New_Account,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: Color(0xFF0E9688),
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
            showLang
                ? Positioned(
                    top: 65,
                    right: 10,
                    child: LangOptions((index) {
                      switch (index) {
                        case 0:
                          changeLanguage(context, "en");
                          break;
                        case 1:
                          changeLanguage(context, "id");
                          break;
                      }
                      setState(() {
                        showLang = false;
                      });
                    }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
