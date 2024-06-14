import 'package:arah_app/chat/chat_detail.dart';
import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchGrpChat extends StatefulWidget {
  final People single;

  final ChatMainBodyState state;

  final List<ChatView> lst;

  SearchGrpChat(this.single, this.state, this.lst);

  @override
  _SearchGrpChatState createState() => _SearchGrpChatState();
}

class _SearchGrpChatState extends State<SearchGrpChat> {
  int highlightIndex = -1;

  final keyChatDetail = new GlobalKey<ChatDetailState>();

  TextEditingController _searchController = TextEditingController();

  List<int> foundIndexList = [];

  onSearchTextChanged(String text) async {
    highlightIndex = -1;
    foundIndexList.clear();
    widget.lst.forEach((userDetail) {
      userDetail.isFound = false;
    });
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    int index = 0;
    widget.lst.forEach((userDetail) {
      if (userDetail.message.toLowerCase().trim().contains(text.toLowerCase().trim())) {
        userDetail.isFound = true;
        foundIndexList.add(index);
      }
      index++;
    });
    setState(() {});
    if (foundIndexList.length > 0) nextIndex();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: Container(
          height: 120,
          color: color_primary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 8,
                      child: TextField(
                        controller: _searchController,
                        onChanged: onSearchTextChanged,
                        style: GoogleFonts.lato(color: arah_white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff0A7E72),
                          border: InputBorder.none,
                          hintText: Languages.of(context).Search,
                          labelStyle: GoogleFonts.lato(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.search,
                            color: arah_white,
                          ),
                          hintStyle: GoogleFonts.lato(fontSize: 17, color: arah_white),
                        ),
                        obscureText: false,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            Languages.of(context).Cancel,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                                fontSize: 20, color: arah_white, fontWeight: FontWeight.normal),
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
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          // shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 35.0,
                  maxHeight: getScreenHeight(context) - 170,
                ),
                child: ChatDetail(
                    keyChatDetail, widget.single, widget.lst, _searchController.text, null, []),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              height: 80,
              color: color_background,
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Image.asset(
                        'assets/arah/arrow_up.png',
                        height: 25,
                        width: 25,
                      ),
                      onTap: () {
                        prevIndex();
                      }, //arrow up
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        nextIndex();
                      }, //arrow down
                      child: Image.asset(
                        'assets/arah/arrow_down.png',
                        height: 25,
                        width: 25,
                      ),
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

  void nextIndex() {
    setState(() {
      if (foundIndexList.length - 1 > highlightIndex) {
        highlightIndex = highlightIndex + 1;
        keyChatDetail.currentState.scrollTo(foundIndexList[highlightIndex]);
      }
    });
  }

  void prevIndex() {
    setState(() {
      if (highlightIndex > 0) {
        highlightIndex = highlightIndex - 1;
        keyChatDetail.currentState.scrollTo(foundIndexList[highlightIndex]);
      }
    });
  }
}
