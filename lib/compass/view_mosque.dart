import 'dart:convert';

import 'package:arah_app/compass/compass_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/mosque.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ViewMosque extends StatefulWidget {
  double latitude, longitude;

  ViewMosque(this.latitude, this.longitude);

  @override
  State<StatefulWidget> createState() => ViewMosqueState();
}

class ViewMosqueState extends State<ViewMosque> {
  Future post;

  getCurrentLongLat() async {
    await Geolocator.getCurrentPosition().then((Position position) {
      CompassPage.ehoAngle =
          getOffsetFromNorth(position.latitude, position.longitude, 21.3891, 39.8579);
      //print(CompassPage.ehoAngle);

      setState(() {
        widget.latitude = position.latitude;
        widget.longitude = position.longitude;
        post = getMosque();
      });
    }).catchError((e) {
      //print(e);
    });
  }

  Future<List<Mosques>> getMosque() async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'latitude': widget.latitude.toString(),
      'longitude': widget.longitude.toString(),
    };
    var res = await api.postData(data, 'view-mosque', context);
    var body = json.decode(res.body);

    if (body['success'] != null && body['success']) {
      List<dynamic> list = body['mosque'];
      if (list.isEmpty) {
        return [];
      } else {
        List<Mosques> Mosqlist = [];
        for (int i = 0; i < list.length; i++) {
          Mosqlist.add(Mosques.fromJson(list[i]));
        }
        return Mosqlist;
      }
    }
  }

  @override
  void initState() {
    if (widget.latitude == null) {
      getCurrentLongLat();
    } else {
      post = getMosque();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Mosques>>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Mosques> mosqList = snapshot.data;
            if (mosqList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Languages.of(context).No_mosque,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(color: Colors.black, fontSize: 18),
                      )),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: mosqList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      MapsLauncher.launchCoordinates(mosqList[index].latitude,
                          mosqList[index].longitude, mosqList[index].mosque_name);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              // CircleAvatar(
                              //   radius: 40,
                              //   backgroundColor: Color(0xffC5E2DF),
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(100),
                              //     child: mosqList[index].mosque_image == null
                              //         ? Container()
                              //         : getImage(mosqList[index].mosque_image) == null
                              //             ? Container()
                              //             : Image.network(
                              //                 getImage(mosqList[index].mosque_image),
                              //                 width: 90,
                              //                 height: 90,
                              //                 fit: BoxFit.cover,
                              //               ),
                              //   ),
                              // ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mosqList[index].mosque_name,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.lato(
                                            fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            Languages.of(context).Distance +
                                                ": " +
                                                (double.parse((mosqList[index].distance)
                                                        .toStringAsFixed(2)))
                                                    .toString() +
                                                " KM",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.lato(
                                                fontSize: 13, fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 0.5,
                          width: double.infinity,
                          color: color_grey_divider,
                        )
                      ],
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
