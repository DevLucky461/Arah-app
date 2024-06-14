import 'dart:math';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'compass.dart';
import 'view_mosque.dart';

class CompassPage extends StatefulWidget {
  double lat, long;

  static double ehoAngle = 255.0;

  // CompassPage(this.lat,this.long);
  @override
  State<StatefulWidget> createState() => _CompassPage();
}

class _CompassPage extends State<CompassPage> with AutomaticKeepAliveClientMixin<CompassPage> {
  bool compassSelected = true;

  @override
  void initState() {
    getCurrentLongLat();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    double screenH = getScreenHeight(context);
    double screenW = getScreenWidth(context);
    double compassR = min(screenH - 182 - screenW * 0.6, screenW);
    return ChangeNotifierProvider<Compass>(
      create: (_) => new Compass(),
      child: Consumer<Compass>(
        builder: (context, compass, child) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Container(
                  color: color_primary,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // setState(() {
                                //   compassSelected = true;
                                // });
                              },
                              child: Text(
                                Languages.of(context).Quran,
                                style: GoogleFonts.lato(
                                    fontSize: compassSelected ? 28 : 18,
                                    color: compassSelected ? Colors.white : arah_white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // SizeArah(0, 30),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       compassSelected = false;
                            //     });
                            //   },
                            //   child: Text(
                            //     Languages.of(context).Mosque,
                            //     textAlign: TextAlign.start,
                            //     style: GoogleFonts.lato(
                            //         fontSize: compassSelected ? 18 : 28,
                            //         color: compassSelected ? arah_white : Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: compassSelected
                  ? Stack(children: [
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        color: Color(0xff99AD99),
                        child: Image.asset(
                          'assets/arah/compass_back.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Center(
                                child: Transform.rotate(
                                  angle: compass.directionangle,
                                  child: Image.asset(
                                    'assets/arah/comp.png',
                                    width: compassR - 20,
                                    height: compassR - 20,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/arah/mekka.png',
                                width: compassR / 2 - 10,
                                height: compassR / 2 - 10,
                              ),
                              Center(
                                child: Transform.rotate(
                                  angle: compass.angle,
                                  child: Image.asset(
                                    'assets/arah/circle.png',
                                    width: compassR * 0.9 - 18,
                                    height: compassR * 0.9 - 18,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                  : ViewMosque(latitude, longitude));
        },
      ),
    );
  }

  double latitude, longitude;

  getCurrentLongLat() async {
    await Geolocator.getCurrentPosition().then((Position position) {
      CompassPage.ehoAngle =
          getOffsetFromNorth(position.latitude, position.longitude, 21.3891, 39.8579);

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }).catchError((e) {
      //print(e);
    });
  }
}
