import 'dart:convert';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/user.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterInfo3 extends StatefulWidget {
  Map<String, dynamic> info;

  RegisterInfo3(this.info);

  @override
  State<StatefulWidget> createState() => _RegisterInfo3();
}

enum NU_Member { yes, no }

class _RegisterInfo3 extends State<RegisterInfo3> {
  NU_Member nu_member = NU_Member.yes;

  bool click = false;

  @override
  void initState() {
    super.initState();

    nu_member = user.nu_member == 'no' ? NU_Member.no : NU_Member.yes;
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
                    child: Icon(
                      Icons.arrow_back_sharp,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  alignment: Alignment.topLeft,
                ),
                SizeArah(60, 0),
                Image.asset(
                  'assets/arah/arah_logo.png',
                  alignment: Alignment.topLeft,
                  height: 59,
                  width: 60,
                ),
                Row(
                  children: [
                    Text(
                      'Arah',
                      style: GoogleFonts.lato(
                          fontSize: 25, fontWeight: FontWeight.w900, color: Color(0xFF49B6A9)),
                      textAlign: TextAlign.center,
                    ),
                    SizeArah(0, 5),
                    TextArah(Languages.of(context).Registration_Page),
                  ],
                ),
                SizeArah(30, 0),
                TextArahContent(Languages.of(context).select_one_following),
                ListTile(
                  title: TextArahContent(Languages.of(context).existing_nu_member),
                  leading: Radio<NU_Member>(
                    value: NU_Member.yes,
                    groupValue: nu_member,
                    onChanged: (NU_Member value) {
                      setState(() {
                        nu_member = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: TextArahContent(Languages.of(context).public_member),
                  leading: Radio<NU_Member>(
                    value: NU_Member.no,
                    groupValue: nu_member,
                    onChanged: (NU_Member value) {
                      setState(() {
                        nu_member = value;
                      });
                    },
                  ),
                ),
                SizeArah(30, 0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: click
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  setState(() {
                                    click = true;
                                  });
                                  widget.info['nu_member'] =
                                      nu_member == NU_Member.yes ? 'yes' : 'no';
                                  registerUser();
                                },
                                color: color_primary,
                                textColor: arah_white,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                                child: Text(
                                  Languages.of(context).Submit,
                                  style:
                                      GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
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

  void registerUser() async {
    CallApi api = CallApi();
    widget.info['token'] = await api.getToken();
    var res = await api.postData(widget.info, 'register', context);
    var body = json.decode(res.body);
    setState(() {
      click = false;
    });
    if (body['success'] != null && body['success']) {
      user = User.map(body['user']);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else
      showToast(Languages.of(context).error_occurred);
  }
}
