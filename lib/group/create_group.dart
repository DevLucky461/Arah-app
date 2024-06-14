import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/group/input_group_name_page.dart';
import 'package:arah_app/group/people_list_for_group.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroup extends StatefulWidget {
  final bool isForGroup;
  final ChatMainBodyState state;

  CreateGroup(this.isForGroup, this.state);

  @override
  State<StatefulWidget> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<People> lstGrpSelectedPeople = [];
  final key_people = GlobalKey<PeopleListForGroupState>();

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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isForGroup
                                ? Languages.of(context).New_Group
                                : Languages.of(context).New_Community,
                            style: GoogleFonts.lato(
                                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    lstGrpSelectedPeople.length > 0
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => InputGroupName(
                                          lstGrpSelectedPeople, widget.isForGroup, widget.state)));
                            },
                            child: Text(
                              Languages.of(context).Next,
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Color(0xFF44D9B2),
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : Text(
                            Languages.of(context).Next,
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.normal),
                          ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                TextField(
                  style: GoogleFonts.lato(),
                  onChanged: (String text) {
                    key_people.currentState.onSearchTextChanged(text);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEDEEEF),
                    border: InputBorder.none,
                    hintText: Languages.of(context).Search,
                    labelStyle: GoogleFonts.lato(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintStyle: GoogleFonts.lato(fontSize: 15, color: Colors.black),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: PeopleListForGroup(key_people, [], (bool selected, People single) {
              setState(() {
                if (selected) {
                  lstGrpSelectedPeople.add(single);
                } else {
                  lstGrpSelectedPeople.remove(single);
                }
              });
            }),
          ),
          Container(
            height: 100,
            alignment: AlignmentDirectional.centerStart,
            color: Color(0xffEDEEEF),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: lstGrpSelectedPeople.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: lstGrpSelectedPeople[index].image == null
                                  ? Container(
                                      width: 70,
                                      height: 70,
                                      color: Color(0xffC5E2DF),
                                    )
                                  : Image.network(
                                      getImage(lstGrpSelectedPeople[index].image),
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                try {
                                  setState(() {
                                    key_people.currentState.setState(() {
                                      lstGrpSelectedPeople[index].selected = false;
                                    });

                                    lstGrpSelectedPeople.remove(lstGrpSelectedPeople[index]);
                                  });
                                } catch (e) {
                                  // print(e);
                                }
                              },
                              child: Image.asset(
                                'assets/arah/cross.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      lstGrpSelectedPeople[index].name,
                      style: GoogleFonts.lato(
                          fontSize: 11, color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}

typedef void onPeopleSelected(bool selected, People single);
