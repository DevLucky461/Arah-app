import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/landing_page.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FetchData {
  String token;
  int id;
  String image;
  String name;

  FetchData({this.name, this.token, this.id, this.image});

  factory FetchData.fromJson(Map<String, dynamic> json) {
    return FetchData(
        token: json['token'], id: json['id'], image: json['image'], name: json['name']);
  }
}

class InputName extends StatefulWidget {
  String Phone;

  InputName(this.Phone);

  @override
  State<StatefulWidget> createState() => _InputName();
}

class _InputName extends State<InputName> {
  final dataKey = new GlobalKey();
  TextEditingController txtcontroller = TextEditingController();
  File _image;
  bool btnClick = false;

  bool entered = true;

  @override
  void initState() {
    super.initState();

    entered = true;

    KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible && entered) Scrollable.ensureVisible(dataKey.currentContext);
    });
  }

  @override
  void dispose() {
    entered = false;
    super.dispose();
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_sharp,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                SizeArah(50, 0),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      cameraConnect();
                    },
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFF44D9B2),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 150,
                                height: 150,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xffE3FFF8),
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Text(Languages.of(context).Add_photo,
                                  style: GoogleFonts.lato(color: Colors.black, fontSize: 13))),
                    ),
                  ),
                ),
                SizeArah(10, 0),
                TextArah(Languages.of(context).Here_we_go),
                SizeArah(30, 0),
                TextArahContent(Languages.of(context).provide_name_photo),
                SizeArah(40, 0),
                TextField(
                  key: dataKey,
                  controller: txtcontroller,
                  maxLength: 50,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: Languages.of(context).name,
                    hintStyle: GoogleFonts.lato(color: Color(0xFFDFE4E9), fontSize: 22),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: btnClick
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  if (txtcontroller.text.isEmpty) {
                                    showToast(Languages.of(context).enter_full_name);
                                  } else {
                                    setState(() {
                                      btnClick = true;
                                    });
                                    registerUserAPI(txtcontroller.text);
                                  }
                                },
                                color: color_primary,
                                textColor: arah_white,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                                child: Text(
                                  Languages.of(context).Complete,
                                  style: GoogleFonts.lato(fontSize: 20),
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

  cameraConnect() async {
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      _image = File(img.path);
    });
  }

  void registerUserAPI(String name) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(CallApi.BASEAPIURL + "get-phone-name-image"));
    request.fields["name"] = name;
    request.fields["phone_number"] = widget.Phone;
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("image", _image.path);
      request.files.add(pic);
    }

    var response = await request.send();

    //Get the response from the server
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);
    setState(() {
      btnClick = false;
    });
    var body = json.decode(responseString);
    if (body['success'] != null && body['success']) {
      CallApi().storeToken(body['token']);

      user.name = txtcontroller.text;
      user.phone = widget.Phone;
      user.image = body['user']['image'];
      user.id = body['user']['id'];

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LandingPage()),
          ModalRoute.withName('/'));
    } else {}
  }
}
