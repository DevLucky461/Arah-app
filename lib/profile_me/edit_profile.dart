import 'dart:convert';
import 'dart:typed_data';

import 'package:arah_app/chat/web_url_view.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/language/locale_constant.dart';
import 'package:arah_app/language/select_language.dart';
import 'package:arah_app/models/option.dart';
import 'package:arah_app/profile_me/register_landing.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  List<Option> options = [];

  int screenToShow = 0;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    screenToShow = 0;
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    TextEditingController _edtControllerName = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(5),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                    child: Column(
                      children: [
                        Text(Languages.of(context).edit_name,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _edtControllerName,
                          style: GoogleFonts.lato(color: Colors.black),
                          maxLength: 30,
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            filled: true,
                            counterText: "",
                            hintText: Languages.of(context).type_here,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            labelStyle: GoogleFonts.lato(color: Colors.white),
                            hintStyle: GoogleFonts.lato(
                                fontSize: 17, color: Colors.white),
                          ),
                          obscureText: false,
                        ),
                        SizeArah(20, 0),
                        Container(
                            width: double.infinity,
                            height: 0.5,
                            color: Colors.grey),
                        SizeArah(25, 0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(Languages.of(context).Cancel,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (_edtControllerName.text
                                      .trim()
                                      .isNotEmpty) {
                                    updateName(_edtControllerName.text.trim());
                                  } else {}
                                },
                                child: Text(Languages.of(context).ok,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Color(0xff00CC99),
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void updateName(String name) async {
    CallApi api = CallApi();
    //print('Update Na0me');
    var data = {
      'token': await api.getToken(),
      'profile_name': name,
    };
    //print(data);

    var res = await api.postData(data, 'edit-profile-name', context);

    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      setState(() {
        user.name = name;
      });
    } else {
      showToast(Languages.of(context).error_occurred);
    }
  }

  void showOption() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showAlertDialog(context);
                      },
                      child: Container(
                        color: Colors.white,
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).edit_name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: getScreenWidth(context),
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        cameraConnect();
                      },
                      child: Container(
                        color: Colors.white,
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).change_photo,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: getScreenWidth(context),
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                color: Colors.transparent,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle),
                  width: getScreenWidth(context),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      Languages.of(context).Cancel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    options.clear();
    if (user.full_name == null || user.full_name.isEmpty)
      options.add(Option(0, 'assets/settings/envelope.png',
          Languages.of(context).ARAH_Profile));
    options.add(Option(
        1, 'assets/settings/settings.png', Languages.of(context).Settings));
    // options.add(Option(1, 'assets/settings/wallet.png', Languages.of(context).E_Wallet));
    // options.add(Option(2, 'assets/settings/photo-camera.png', Languages.of(context).Moment));
    // options.add(Option(3, 'assets/settings/server.png', Languages.of(context).Investment));
    // options.add(Option(4, 'assets/settings/hospital.png', Languages.of(context).Health));
    // options.add(Option(5, 'assets/settings/envelope.png', Languages.of(context).Mail));
    return screenToShow == 0
        ? Scaffold(
            body: Container(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                SizeArah(15, 0),
                Align(
                  child: InkWell(
                    onTap: () {
                      showOption();
                    },
                    child: Text(
                      Languages.of(context).edit,
                      style:
                          GoogleFonts.lato(color: color_primary, fontSize: 16),
                    ),
                  ),
                  alignment: Alignment.topRight,
                ),
                SizeArah(20, 0),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      // cameraConnect();
                    },
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: color_background,
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: user.image == null || user.image == ""
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    getImage(user.image),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                    ),
                  ),
                ),
                SizeArah(22, 0),
                Align(
                  child: Text(
                    user?.name,
                    style: GoogleFonts.lato(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
                SizeArah(10, 0),
                Text(
                  user?.phone,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w400, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizeArah(25, 0),
                Column(
                  children: getRows(options),
                ),
              ],
            ),
          ))
        : Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: color_primary,
                  height: 90,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              screenToShow = 0;
                            });
                            // Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          Languages.of(context).Settings,
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 22),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
                SizeArah(7, 0),
                Container(
                  // height: getScreenHeight(context) - 100,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          navigateTo(context, SelectLanguage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Languages.of(context).language,
                                style: GoogleFonts.lato(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                Languages.of(context).language == "Bahasa"
                                    ? Languages.of(context).indonesian
                                    : Languages.of(context).english,
                                style: GoogleFonts.lato(
                                    color: Color(0xFFBCBCBC),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                      divider(),
                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: Text(
                      //     Languages.of(context).Notification,
                      //     style: GoogleFonts.lato(
                      //         fontSize: 18, fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      // SizeArah(5, 0),
                      Divider(
                        color: Color(0xFFBCBCBC),
                        thickness: 1,
                      ),
                      SizeArah(5, 0),
                      // InkWell(
                      //   onTap: () {
                      //     navigateTo(
                      //         context,
                      //         WebUrlView(
                      //             "https://www.arahglobal.com/coin-tnc"));
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8),
                      //     child: Text(
                      //       Languages.of(context).Terms_Condition_ARAH_App,
                      //       style: GoogleFonts.lato(
                      //           fontSize: 18, fontWeight: FontWeight.w400),
                      //     ),
                      //   ),
                      // ),
                      // divider(),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              WebUrlView(
                                  "https://www.arahglobal.com/coin-tnc"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Languages.of(context).Terms_Condition_ARAH_Coin,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      divider(),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              WebUrlView(
                                  "https://www.arahglobal.com/privacy-policy"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Languages.of(context).Privacy_Policy,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      divider(),
                      InkWell(
                        onTap: () {
                          clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                Languages.of(context).logout,
                                style: GoogleFonts.lato(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  cameraConnect() async {
    PickedFile file = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 60);
    var request = http.MultipartRequest(
        "POST", Uri.parse(CallApi.BASEAPIURL + "edit-profile-photo"));

    request.fields["token"] = await CallApi().getToken();

    try {
      if (file != null) {
        var pic = await http.MultipartFile.fromPath("profile_photo", file.path);
        request.files.add(pic);
      } else {}
    } catch (e) {
      // print(e);
    }
    var response = await request.send();

    //Get the response from the server
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);
    var body = json.decode(responseString);
    if (body['success'] != null && body['success']) {
      setState(() {
        user.image = body['image'];
      });
    } else
      showToast(Languages.of(context).error_occurred);
  }

  void clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String lang = preferences.getString(prefSelectedLanguageCode);
    await preferences.clear();
    changeLanguage(context, lang);
    await FirebaseMessaging.instance.deleteToken();

    Phoenix.rebirth(context);
  }

  getRows(List<Option> options) {
    List<Widget> lst = [];
    for (int i = 0; i < options.length; i++) {
      lst.add(InkWell(
        onTap: () {
          switch (options[i].index) {
            case 0:
              navigateTo(context, RegisterLanding());
              break;

            case 1:
              setState(() {
                screenToShow = 1;
              });
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Image.asset(
                options[i].image,
                height: 32,
                width: 32,
              ),
              SizeArah(0, 17),
              Text(
                options[i]?.optionName,
                style: GoogleFonts.lato(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ));
      lst.add(divider());
    }
    return lst;
  }
}

typedef void updateDetails();
