import 'dart:convert';

import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/chat/chat_screen.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_row_people.dart';

class PeopleList extends StatefulWidget {
  final GlobalKey<State<StatefulWidget>> key;
  final ChatMainBodyState state;

  PeopleList(this.key, this.state);

  @override
  State<StatefulWidget> createState() => PeopleListState(key);
}

class PeopleListState extends State<PeopleList> {
  String name;
  String image;
  String phone;
  bool showOption = false;
  bool showChatOption = false;
  bool showSearch = false;

  TextEditingController searchController = TextEditingController();

  List<People> lstPeople = [];
  GlobalKey<State<StatefulWidget>> key;

  PeopleListState(this.key);

  bool loadingContacts = true;

  bool isLoading = false;

  List<People> lstSearch = [];

  Future<void> addContact(People people) async {
    lstPeople.add(people);
    List<String> contactList = [];
    contactList = lstPeople.map((e) => e.toString()).toList();
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setStringList("contacts", contactList);
    widget.state.searchController.text = "";
    onSearchTextChanged("");
  }

  onSearchTextChanged(String text) async {
    lstSearch.clear();
    if (text.isEmpty) {
      lstSearch.addAll(lstPeople);
      setState(() {});
      return;
    }

    lstPeople.forEach((userDetail) {
      if (userDetail.name.toLowerCase().trim().contains(text.toLowerCase().trim()))
        lstSearch.add(userDetail);
    });
    setState(() {});
  }

  double percentage = 0;

  checkContacts() async {
    print('Read Contacts');
    lstPeople.clear();
    lstSearch.clear();
    SharedPreferences shared = await SharedPreferences.getInstance();
    List<String> contactList = shared.getStringList("contacts");
    if (contactList != null && contactList.length > 0) {
      for (int i = 0; i < contactList.length; i++) {
        People people = People.fromJsonString(contactList[i]);
        lstPeople.add(people);
      }
      lstSearch.addAll(lstPeople);
    } else {
      readContacts();
      shared.setStringList("contacts", []);
    }

    setState(() {
      loadingContacts = false;
      isLoading = false;
    });
  }

  Future<void> readContacts() async {
    print("readContacts");
    lstPeople.clear();
    lstSearch.clear();
    setState(() {
      loadingContacts = true;
      isLoading = false;
    });
    //Get Phone Contact List
    List<String> phoneList = [];
    final PermissionStatus permissionStatus = await getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final contacts = Contacts.listContacts(withThumbnails: false);

      final total = await contacts.length;

      if (total > 0) {
        int curCount = 0;
        percentage = 0;
        await Contacts.streamContacts(withThumbnails: false).forEach((contact) {
          try {
            if (contact.phones.length > 0) {
              String dataPhone = contact.phones[0].value.replaceAll(" ", "");
              dataPhone = dataPhone.replaceAll("+", "");
              dataPhone = dataPhone.replaceAll("-", "");
              dataPhone = dataPhone.replaceAll("(", "");
              dataPhone = dataPhone.replaceAll(")", "");
              if (dataPhone.length > 5 && !phoneList.contains(dataPhone)) phoneList.add(dataPhone);
              curCount = curCount + 1;
              checkPercentage(total, curCount);
            }
          } catch (e) {
            print(e);
          }
        });
      }
      // else {
      //   phoneList = [
      //     '6594881645',
      //     '60122892559',
      //     '6584484990',
      //     '628128647964',
      //     '6281299116878',
      //     '6281399392090',
      //     '6281363326768',
      //     '6285355404978',
      //     '6285896333729',
      //     '6285716936676',
      //     '6281383335516',
      //     '6281249413400',
      //     '6285320579642',
      //     '6281227094757',
      //   ];
      //
      //   for (int i = 0; i < phoneList.length; i++) {
      //     Contact contact = new Contact(
      //         phones: [Item(value: phoneList[i], label: 'mobile')],
      //         familyName: "bbb" + i.toString(),
      //         givenName: "aaa" + i.toString());
      //     await Contacts.addContact(contact);
      //   }
      // }
    } else {
      print("Permission not ok");
    }

    try {
      setState(() {
        loadingContacts = false;
        isLoading = true;
      });

      //Get List of People from server
      if (phoneList.length > 0) {
        CallApi api = CallApi();
        var data = {
          'token': await api.getToken(),
          'phone_number': phoneList,
        };
        var res = await api.postData(data, 'add-contact', context);
        var body = json.decode(res.body);
        if (body['success'] != null && body['success']) {
          api.storeContactDetail(res.body.toString());

          List<dynamic> list = body['contact'];
          for (int i = 0; i < list.length; i++) {
            People people = People.fromJson(list[i]);
            if (people.phone != user.phone) lstPeople.add(people);
          }
          lstSearch.addAll(lstPeople);
        }
      }
      List<String> contactList = [];
      contactList = lstPeople.map((e) => e.toString()).toList();
      SharedPreferences shared = await SharedPreferences.getInstance();
      shared.setStringList("contacts", contactList);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void checkPercentage(int totalContact, int listLength) {
    if (totalContact != 0) {
      setState(() {
        percentage = (listLength / totalContact) * 100;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadingContacts = true;
    isLoading = false;

    checkContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color_primary, color_second]),
                    boxShadow: [
                      BoxShadow(color: color_shadow, spreadRadius: 3),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Text(
                                  Languages.of(context).Contacts,
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showSearch = !showSearch;
                                  });
                                },
                                child: Icon(
                                  Icons.search_outlined,
                                  color: arah_white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       showOption = true;
                              //     });
                              //   },
                              //   child: Icon(
                              //     Icons.more_vert_outlined,
                              //     color: arah_white,
                              //   ),
                              // )
                            ]),
                          ],
                        ),
                        SizeArah(10, 0),
                        Visibility(
                          visible: showSearch,
                          child: Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 30,
                                ),
                                hintText: Languages.of(context).Search,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              controller: searchController,
                              onChanged: onSearchTextChanged,
                              style: GoogleFonts.lato(color: Colors.black),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: color_shadow, spreadRadius: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  //PeoplePage
                  child: Container(
                    height: getScreenHeight(context) - 100 - 190,
                    child: loadingContacts
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 10.0,
                                percent: percentage / 100,
                                center: new Text(percentage.toStringAsFixed(2) + "%"),
                                progressColor: color_primary,
                                backgroundColor: Colors.grey,
                              ),
                              SizeArah(10, 0),
                              Text(Languages.of(context).Reading_contacts)
                            ],
                          )
                        : isLoading
                            ? Center(child: CircularProgressIndicator())
                            : lstSearch.length > 0
                                ? ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            callAPICreateRoomTwo(lstSearch[index]);
                                          },
                                          child: ListRowPeople(lstSearch[index]));
                                    },
                                    itemCount: lstSearch.length,
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(left: 2.0, top: 20.0, right: 2.0),
                                    child: Text(Languages.of(context).no_contact_found),
                                  ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void callAPICreateRoomTwo(People singlePeople) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'receiver_phone': singlePeople.phone,
      'group_type': 'personal',
    };
    var res = await api.postData(data, 'create-room-for-two', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      widget.state.readChatMsg();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChatScreen(singlePeople, body['UUID'], "personal", false, widget.state)));
    } else
      showToast(Languages.of(context).error_occurred);
  }
}
