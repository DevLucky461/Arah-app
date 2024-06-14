import 'dart:async';
import 'dart:convert';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/landing_page.dart';
import 'package:arah_app/models/user.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';

import 'get_started.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  checkForToken() async {
    final newVersion = NewVersion(
      iOSId: 'com.arah.app',
      androidId: 'com.arahglobal.app',
    );
    final status = await newVersion.getVersionStatus();
    print(status.localVersion);
    print(status.storeVersion);
    print(status.appStoreLink);
    if (status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dismissButtonText: "Close",
        dismissAction: () => SystemNavigator.pop(),
      );
    } else {
      CallApi api = CallApi();
      String token = await api.getToken();
      if (token != "") {
        var data = {
          'token': token,
        };
        var res = await api.postData(data, 'check-token', context);
        var body = json.decode(res.body);

        if (body['success'] != null && body['success']) {
          user = User.map(body['user']);
          api.storeToken(token);

          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          });
        } else {
          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => GetStarted()));
          });
        }
      } else {
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => GetStarted()));
        });
      }
    }
  }

  @override
  void initState() {
    checkForToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/arah/launchscreen-bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/arah/launchscreen-splashfx.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset('assets/arah/arah_splash.png'),
                  height: 160,
                  width: getScreenWidth(context),
                ),
                SizeArah(30),
                Text(
                  Languages.of(context).certified_by,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Text(
              Languages.of(context).Version + " 1.0.19",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
