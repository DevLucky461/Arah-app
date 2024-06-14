import 'dart:convert';

import 'package:arah_app/chat/list_row_people.dart';
import 'package:arah_app/chat/people_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContact extends StatefulWidget {
  final List<People> peopleList;
  final GlobalKey<PeopleListState> key_people;

  AddContact(this.peopleList, this.key_people);

  @override
  State<StatefulWidget> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  People selectedPeople = null;
  String mobile_no = null;
  bool loading = false;

  final TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: Container(
          color: Colors.white,
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
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Container(
                      child: Text(
                        Languages.of(context).Add_Contact,
                        style: GoogleFonts.lato(
                            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(),
                  ],
                ),
                SizeArah(0, 15),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizeArah(0, 8),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.lato(fontSize: 15),
                      controller: searchController,
                      onChanged: (String text) {
                        mobile_no = text;
                        setState(() {
                          selectedPeople = null;
                        });
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      maxLength: 15,
                      enabled: !loading,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: Languages.of(context).mobile_hint,
                        hintStyle: GoogleFonts.lato(fontSize: 15, color: Color(0xFFDFE4E9)),
                      ),
                      obscureText: false,
                    ),
                  ),
                  mobile_no == null || mobile_no == "" || loading
                      ? const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 30,
                        )
                      : InkWell(
                          onTap: () {
                            if (mobile_no != null) {
                              bool alreadyExist = false;
                              widget.peopleList.forEach((people) {
                                if (people.phone == "+" + mobile_no) {
                                  showToast(Languages.of(context).contact_exist);
                                  alreadyExist = true;
                                  return;
                                }
                              });
                              if (alreadyExist) return;
                              if (user.phone == "+" + mobile_no) {
                                showToast(Languages.of(context).your_number);
                                return;
                              }
                              setState(() {
                                loading = true;
                              });
                              getContact();
                            } else
                              showToast(Languages.of(context).enter_mobile_no);
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                ]),
              ],
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: getScreenWidth(context),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: selectedPeople != null
                    ? InkWell(
                        onTap: () {
                          widget.key_people.currentState.addContact(selectedPeople);
                          showToast(selectedPeople.name + Languages.of(context).added_to_contact);
                          searchController.text = "";
                          setState(() {
                            selectedPeople = null;
                          });
                        },
                        child: ListRowPeople(selectedPeople),
                      )
                    : Text(
                        Languages.of(context).no_contact_found,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
    );
  }

  Future<void> getContact() async {
    selectedPeople = null;
    CallApi api = CallApi();
    var data = {'token': await api.getToken(), 'phone_number': mobile_no};
    var res = await api.postData(data, 'check-token', context);
    var body = json.decode(res.body);

    if (body['success'] != null && body['success']) {
      if (body['user'] != null) selectedPeople = People.fromJson(body['user']);
      setState(() {
        loading = false;
      });
    }
  }
}
