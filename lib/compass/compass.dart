import 'dart:math';

import 'package:arah_app/compass/compass_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Compass with ChangeNotifier {
  static const ehoAngle = 255.0;

  double _angle = 0;

  double get angle => _angle;

  double _directionangle = 0;

  double get directionangle => _directionangle;

  Compass() {
    FlutterCompass.events.listen((value) {
      _angle = pi * (CompassPage.ehoAngle - value.heading) / 180;
      _directionangle = -pi * value.heading / 180;
      notifyListeners();
    });
  }
}
