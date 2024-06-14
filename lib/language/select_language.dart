import 'package:arah_app/language/languages.dart';
import 'package:arah_app/language/locale_constant.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectLanguageState();
}

class SelectLanguageState extends State<SelectLanguage> {
  String languageCode = "id";

  checkOldLang() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "id";
    setState(() {});
  }

  @override
  void initState() {
    checkOldLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 30),
          color: color_primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Container(
                color: color_primary,
                child: Text(
                  Languages.of(context).change_language,
                  style: GoogleFonts.lato(
                      fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Languages.of(context).
                setState(() {
                  changeLanguage(context, "en");
                  languageCode = "en";
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(languageCode == "en" ? Icons.radio_button_on : Icons.radio_button_off),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Languages.of(context).english,
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: languageCode == "en" ? FontWeight.w800 : FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  changeLanguage(context, "id");
                  languageCode = "id";
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(languageCode == "en" ? Icons.radio_button_off : Icons.radio_button_on),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Languages.of(context).indonesian,
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: languageCode == "en" ? FontWeight.w400 : FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
