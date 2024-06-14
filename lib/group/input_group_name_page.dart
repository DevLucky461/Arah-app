import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/chat/chat_screen.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
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
        token: json['token'],
        id: json['id'],
        image: json['image'],
        name: json['name']);
  }
}

class InputGroupName extends StatefulWidget {
  final List<People> lstGrpSelectedPeople;
  final bool isForGroup;
  final ChatMainBodyState state;

  InputGroupName(this.lstGrpSelectedPeople, this.isForGroup, this.state);

  @override
  _InputGroupNameState createState() => _InputGroupNameState();
}

class _InputGroupNameState extends State<InputGroupName> {
  TextEditingController txtcontroller = TextEditingController();
  File _image;
  bool isGrpName = false;
  bool btnClick = false;
  bool showIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/arah/rightarrow.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isForGroup
                                ? Languages.of(context).New_Group
                                : Languages.of(context).New_Community,
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    showIndicator
                        ? Center(child: CircularProgressIndicator())
                        : !isGrpName
                            ? Text(
                                Languages.of(context).Create,
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.grey[300],
                                    fontWeight: FontWeight.normal),
                              )
                            : InkWell(
                                onTap: () {
                                  callAPICreateGroupRoom(_image);
                                },
                                child: Text(
                                  Languages.of(context).Create,
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Color(0xFF44D9B2),
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizeArah(20, 0),
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
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 13))),
                  ),
                ),
              ),
              SizeArah(10, 0),
              TextField(
                controller: txtcontroller,
                onChanged: (va) {
                  setState(() {
                    if (va.isNotEmpty)
                      isGrpName = true;
                    else
                      isGrpName = false;
                  });
                },
                maxLength: 30,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: widget.isForGroup
                      ? Languages.of(context).Group_Name
                      : Languages.of(context).Community_Name,
                  hintStyle:
                      GoogleFonts.lato(color: Color(0xFFDFE4E9), fontSize: 19),
                ),
              ),
              SizeArah(30, 0),
              Text(
                widget.isForGroup
                    ? Languages.of(context).provide_photo_grp
                    : Languages.of(context).provide_photo_comm,
                style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: color_light_grey),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }

  cameraConnect() async {
    PickedFile img = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      _image = File(img.path);
    });
  }

  callAPICreateGroupRoom(File file) async {
    setState(() {
      showIndicator = true;
    });
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST", Uri.parse(CallApi.BASEAPIURL + "create-group-room"));

    String Phone = "";
    for (int i = 0; i < widget.lstGrpSelectedPeople.length; i++) {
      if (Phone.isEmpty) {
        Phone = widget.lstGrpSelectedPeople[i].phone;
      } else {
        Phone = Phone + "," + widget.lstGrpSelectedPeople[i].phone;
      }
    }
    request.fields["token"] = await CallApi().getToken();
    request.fields["group_name"] = txtcontroller.text;
    request.fields["group_type"] = widget.isForGroup ? "group" : "community";
    request.fields["phone_number"] = Phone;
    if (file != null) {
      var pic = await http.MultipartFile.fromPath("group_image", file.path);
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
      widget.state.readChatMsg();
      Navigator.pop(context);
      Navigator.pop(context);
      widget.state.entered = false;
      People single = People(
          name: txtcontroller.text, UUID: body['UUID'], phone: user.phone);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ChatScreen(
                  single,
                  body['UUID'],
                  widget.isForGroup ? "group" : "community",
                  true,
                  widget.state)));
    } else {
      setState(() {
        showIndicator = false;
      });
    }
  }
}
