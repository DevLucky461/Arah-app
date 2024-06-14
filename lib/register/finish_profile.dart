import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/landing_page.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FinishProfile extends StatefulWidget {
  String Mobile;
  String UserName;
  String Email;
  String Password;

  FinishProfile(this.Mobile, this.UserName, this.Email, this.Password);
  @override
  State<StatefulWidget> createState() => _FinishProfile();
}

class _FinishProfile extends State<FinishProfile> {
  final dataKey = new GlobalKey();
  TextEditingController _pnameController = TextEditingController();
  String errorPName = '';

  String otp = "";
  bool click = false;

  bool entered = true;
  File _image;

  @override
  void initState() {
    entered = true;

    KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && entered) Scrollable.ensureVisible(dataKey.currentContext);
    });

    super.initState();
  }

  @override
  void dispose() {
    entered = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: getScreenHeight(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color_second, color_primary]),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                  height: getScreenWidth(context) / 2,
                  width: getScreenWidth(context),
                  child: Stack(
                    children: [
                      InkWell(
                        child: Image.asset(
                          'assets/arah/icon-back.png',
                          color: Colors.white,
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
                          Languages.of(context).Finish_Profile,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Image.asset('assets/arah/launchscreen-splashfx.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getScreenWidth(context) / 2.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/arah/login-page-bg.png"),
                        fit: BoxFit.fill,
                      ),
                      color: Colors.transparent,
                    ),
                    height: double.infinity,
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            Languages.of(context).provide_name_photo,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              color: color_light_grey,
                            ),
                          ),
                          SizeArah(20),
                          Container(
                            padding: const EdgeInsets.only(left: 30),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Languages.of(context).preferred_name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: color_light_grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    color: Colors.grey,
                                  ),
                                  counterText: '',
                                  hintText: Languages.of(context).name_example,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: color_light_grey,
                                ),
                                controller: _pnameController,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: color_shadow, spreadRadius: 0.3),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: errorPName != "",
                            child: Text(
                              errorPName,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizeArah(30),
                          click
                              ? Center(child: CircularProgressIndicator())
                              : RaisedGradientButton(
                                  onPressed: () {
                                    errorPName = "";
                                    if (_pnameController.text.trim().isNotEmpty) {
                                      print(widget.Mobile +
                                          widget.UserName +
                                          widget.Email +
                                          widget.Password +
                                          _pnameController.text);
                                      setState(() => click = true);
                                      //Add Finish Account api calling
                                      // showToast("Coming Soon");
                                      setState(() => click = false);
                                      register(_pnameController.text);
                                    } else
                                      setState(
                                          () => errorPName = Languages.of(context).enter_pname);
                                  },
                                  gradient: LinearGradient(
                                      colors: [Color(0xFF37AFB1), Color(0xFF43C0A1)]),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text(
                                      Languages.of(context).save,
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: getScreenWidth(context) / 2 - 100),
                  child: GestureDetector(
                    onTap: () {
                      print("clicked image");
                      cameraConnect();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/arah/login-page-frame.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                _image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Image.asset(
                              'assets/arah/login-avatar-default.png',
                            ),
                      height: 130,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  cameraConnect() async {
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      _image = File(img.path);
    });
  }

  void register(String pName) async {
    var request = http.MultipartRequest("POST", Uri.parse(CallApi.BASEAPIURL + "create-user"));
    request.fields["name"] = pName;
    request.fields["phone_number"] = widget.Mobile;
    request.fields["full_name"] = widget.UserName;
    request.fields["email"] = widget.Email;
    request.fields["password"] = widget.Password;
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("image", _image.path);
      request.files.add(pic);
    }

    var response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);
    print(responseString);
    var body = json.decode(responseString);
    print(body);
    setState(() => click = false);
    if (body['success'] != null && body['success']) {
      CallApi().storeToken(body['token']);

      user.name = pName;
      user.phone = widget.Mobile;
      user.image = body['user']['image'];
      user.id = body['user']['id'];

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LandingPage()),
          ModalRoute.withName('/'));
    } else {}
  }
}
