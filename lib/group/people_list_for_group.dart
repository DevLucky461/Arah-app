import 'package:arah_app/models/people.dart';
import 'package:arah_app/models/room_member.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_group.dart';

class PeopleListForGroup extends StatefulWidget {
  final onPeopleSelected callback;
  final GlobalKey key;
  final List<RoomMember> lst;

  PeopleListForGroup(
    this.key,
    this.lst,
    this.callback,
  );

  @override
  State<StatefulWidget> createState() => PeopleListForGroupState(key);
}

class PeopleListForGroupState extends State<PeopleListForGroup> {
  GlobalKey<State<StatefulWidget>> key;

  PeopleListForGroupState(this.key);

  List<People> lstPeople = [];
  List<People> lstSearch = [];

  onSearchTextChanged(String text) async {
    lstSearch.clear();
    if (text.isEmpty) {
      lstSearch.clear();
      for (int i = 0; i < lstPeople.length; i++) {
        lstSearch.add(lstPeople[i]);
      }
      setState(() {});
      return;
    }

    lstPeople.forEach((userDetail) {
      if (userDetail.name.toLowerCase().trim().contains(text.toLowerCase().trim())) {
        lstSearch.add(userDetail);
      } else {}
    });
    setState(() {});
  }

  checkContacts() async {
    lstPeople.clear();
    lstSearch.clear();
    SharedPreferences shared = await SharedPreferences.getInstance();
    List<String> contactList = shared.getStringList("contacts");
    if (contactList != null && contactList.length > 0) {
      for (int i = 0; i < contactList.length; i++) {
        People people = People.fromJsonString(contactList[i]);
        bool alreadyExist = false;
        for (int i = 0; i < widget.lst.length; i++)
          if (widget.lst[i].id == people.id) {
            alreadyExist = true;
            break;
          }

        if (!alreadyExist && people.phone != user.phone) lstPeople.add(people);
      }
      lstSearch.addAll(lstPeople);
      setState(() {});
    }
  }

  @override
  void initState() {
    checkContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: null != lstSearch
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        if (lstSearch[index].selected) {
                          lstSearch[index].selected = false;
                          widget.callback.call(false, lstSearch[index]);
                        } else {
                          lstSearch[index].selected = true;
                          widget.callback.call(true, lstSearch[index]);
                        }
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Color(0xffC5E2DF),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: lstSearch[index].image == null ||
                                                lstSearch[index].image == ""
                                            ? Container()
                                            : Image.network(
                                                getImage(lstSearch[index].image),
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lstSearch[index].name,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.lato(
                                                  fontSize: 15, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(
                                    lstSearch[index].selected ? Icons.check_circle : Icons.circle,
                                    color: lstSearch[index].selected
                                        ? Color(0xff00CC99)
                                        : Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70, right: 20),
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              color: color_grey_divider,
                            ),
                          )
                        ],
                      ));
                },
                itemCount: lstSearch.length,
              )
            : Center(child: CircularProgressIndicator()));
  }
}
