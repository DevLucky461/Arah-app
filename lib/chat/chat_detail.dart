import 'dart:async';

import 'package:arah_app/chat/photo_detail.dart';
import 'package:arah_app/chat/web_url_view.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/nu_register/nu_landing.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatDetail extends StatefulWidget {
  final People singlePeople;
  final List<ChatView> lst;
  final GlobalKey key;
  final String searchQry;
  final String unread_time;
  final List<int> selectedMessageIDList;

  ChatDetail(
    this.key,
    this.singlePeople,
    this.lst,
    this.searchQry,
    this.unread_time,
    this.selectedMessageIDList,
  );

  @override
  State<StatefulWidget> createState() => ChatDetailState(key);
}

class ChatDetailState extends State<ChatDetail> with AutomaticKeepAliveClientMixin<ChatDetail> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  bool get wantKeepAlive => true;

  GlobalKey<State<StatefulWidget>> key;

  String date = "";

  bool showShortcut = false;
  int unread = 0;

  ChatDetailState(this.key);

  scrollTo(int index) {
    itemScrollController.scrollTo(index: index, duration: Duration(milliseconds: 50));
  }

  getMobile(bool isFirst) {
    unread = 0;
    // String chatName = "";
    for (int i = 0; i < widget.lst.length; i++) {
      if (isFirst &&
          widget.unread_time != null &&
          widget.lst[i].created_at.compareTo(widget.unread_time) >= 0) unread++;
      // if (user.name != widget.lst[i].name) {
      //   if (chatName == "") {
      //     widget.lst[i].showImg = true;
      //     chatName = widget.lst[i].name;
      //   } else if (chatName == widget.lst[i].name) {
      //     widget.lst[i].showImg = false;
      //   } else {
      //     chatName = widget.lst[i].name;
      //     widget.lst[i].showImg = true;
      //   }
      // } else
      //   chatName = widget.lst[i].name;
    }
    setState(() {});
    if (widget.lst.length > 0) {
      Timer(Duration(milliseconds: 100), () {
        if (unread > 0)
          scrollTo(widget.lst.length - unread);
        else
          scrollTo(widget.lst.length - 1);
      });
    }
  }

  @override
  void initState() {
    getMobile(true);
    itemPositionsListener.itemPositions.addListener(() => setState(() {
          showShortcut =
              widget.lst.length - itemPositionsListener.itemPositions.value.last.index > 1;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: widget.lst.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  Languages.of(context).No_chat,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: Colors.black),
                ),
              ),
            )
          : Stack(children: [
              ScrollablePositionedList.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: widget.lst.length,
                reverse: false,
                itemBuilder: (context, index) {
                  if (user.name == "") {
                    return CircularProgressIndicator();
                  } else {
                    bool showDate = false;
                    if (index == 0 ||
                        getDateFromGMT(widget.lst[index - 1].created_at) !=
                            getDateFromGMT(widget.lst[index].created_at)) {
                      showDate = true;
                    }
                    return Column(
                      children: [
                        index + unread == widget.lst.length
                            ? Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    )),
                                    Text(
                                      Languages.of(context).Unread_Messages,
                                      style: GoogleFonts.lato(
                                          decoration: TextDecoration.none, color: Colors.black),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    )),
                                  ],
                                ))
                            : SizedBox(),
                        showDate
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    shape: BoxShape.rectangle),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  child: Text(
                                    getDateFromGMT(widget.lst[index].created_at),
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.lato(
                                      decoration: TextDecoration.none,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.lst[index].message_type == "schedule_text"
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: color_primary,
                                      borderRadius: BorderRadius.circular(20),
                                      shape: BoxShape.rectangle),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Text(
                                      Languages.of(context).Scheduled_for +
                                          getDateFromGMT(widget.lst[index].message_datetime),
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.lato(
                                          decoration: TextDecoration.none, color: color_primary),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.lst[index].message_type == "notification"
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: color_primary,
                                      borderRadius: BorderRadius.circular(20),
                                      shape: BoxShape.rectangle),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Text(
                                      widget.lst[index].message + Languages.of(context).joined_grp,
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.lato(
                                          decoration: TextDecoration.none, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : user.name == widget.lst[index].name
                                ? Row(
                                    //me
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: getScreenWidth(context) - 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  getTimeFromGMT(widget.lst[index].created_at),
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13,
                                                      color: widget.lst[index].message_type ==
                                                              "schedule_text"
                                                          ? color_primary
                                                          : Colors.grey[400]),
                                                ),
                                              ),
                                              Flexible(
                                                child: widget.lst[index].message_type == "image"
                                                    ? InkWell(
                                                        onTap: () {
                                                          navigateTo(context,
                                                              PhotoDetail([widget.lst[index]], 0));
                                                        },
                                                        child: Container(
                                                          height: 200,
                                                          child: Image.network(
                                                            getImage(widget.lst[index].message),
                                                            fit: BoxFit.contain,
                                                            alignment: Alignment.centerRight,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: widget.lst[index].isSelected
                                                                ? color_dark_grey
                                                                : widget.lst[index].message_type ==
                                                                        "schedule_text"
                                                                    ? color_second
                                                                    : color_primary,
                                                            borderRadius: BorderRadius.circular(10),
                                                            shape: BoxShape.rectangle),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              if (checkForLink(
                                                                  widget.lst[index].message)) {
                                                                launchBrowser(
                                                                    widget.lst[index].message);
                                                              }
                                                            },
                                                            onLongPress: () {
                                                              // print("long press!!!");
                                                              // print(widget.lst[index].message);
                                                              // widget.lst[index].isSelected =
                                                              //     !widget.lst[index].isSelected;
                                                              // if (widget.lst[index].isSelected) {
                                                              //   widget.selectedMessageIDList
                                                              //       .add(widget.lst[index].id);
                                                              // } else {
                                                              //   widget.selectedMessageIDList
                                                              //       .remove(widget.lst[index].id);
                                                              // }
                                                              // if (checkForLink(
                                                              //     widget.lst[index].message)) {
                                                              //   launchBrowser(
                                                              //       widget.lst[index].message);
                                                              // }
                                                            },
                                                            child: getSpan(
                                                                widget.lst[index].isFound,
                                                                widget.lst[index].message,
                                                                true),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    //other
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: getScreenWidth(context) - 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(2.0),
                                                      child: Text(
                                                        widget.lst[index].name != null
                                                            ? widget.lst[index].name
                                                            : "",
                                                        overflow: TextOverflow.clip,
                                                        style: GoogleFonts.lato(
                                                            color: Color(0xff818181),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(2.0),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Color(0xffC5E2DF),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: widget.lst[index].image == null ||
                                                                widget.lst[index].image == ""
                                                            ? Image.asset(
                                                                'assets/arah/Icon-Avatar.png')
                                                            : Image.network(
                                                                BASEURL + widget.lst[index].image),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Flexible(
                                                child: widget.lst[index].message_type == "image"
                                                    ? InkWell(
                                                        onTap: () {
                                                          navigateTo(context,
                                                              PhotoDetail([widget.lst[index]], 0));
                                                        },
                                                        child: Container(
                                                          height: 200,
                                                          child: Image.network(
                                                            getImage(widget.lst[index].message),
                                                            fit: BoxFit.contain,
                                                            alignment: Alignment.bottomLeft,
                                                          ),
                                                        ))
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(0xffF1F1F4),
                                                            borderRadius: BorderRadius.circular(10),
                                                            shape: BoxShape.rectangle),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              if (checkForLink(
                                                                  widget.lst[index].message)) {
                                                                launchBrowser(
                                                                    widget.lst[index].message);
                                                              }
                                                            },
                                                            child: getSpan(
                                                                widget.lst[index].isFound,
                                                                widget.lst[index].message,
                                                                false),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  getTimeFromGMT(widget.lst[index].created_at),
                                                  style: GoogleFonts.lato(
                                                      fontSize: 13, color: Colors.grey[400]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                      ],
                    );
                  }
                },
              ),
              showShortcut
                  ? Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          scrollTo(widget.lst.length - 1);
                        },
                        child: Container(
                          width: 50,
                          child: Image.asset('assets/arah/Button-ToLatest.png'),
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
    );
  }

  getSpan(bool found, String msg, bool itsMe) {
    if (found) {
      return RichText(
        text: TextSpan(children: getSpansTree(widget.searchQry, msg, itsMe)),
      );
    } else {
      if (checkForLink(msg)) {
        return RichText(
          text: TextSpan(children: getUnderLineSpansTree(msg, itsMe)),
        );
      } else {
        return Text(
          msg,
          overflow: TextOverflow.clip,
          style: GoogleFonts.lato(
              decoration: TextDecoration.none, color: itsMe ? Colors.white : Colors.black87),
        );
      }
    }
  }

  getSpansTree(String searchQry, String msg, bool itsMe) {
    List<String> msgList = msg.split(" ");
    List<TextSpan> widList = [];

    for (int i = 0; i < msgList.length; i++) {
      if (msgList[i] == searchQry) {
        widList.add(
          TextSpan(
              text: msgList[i] + ' ',
              style: TextStyle(
                  color: itsMe ? Colors.white : Colors.black87,
                  backgroundColor: Color(0xff00cc99))),
        );
      } else {
        widList.add(
          TextSpan(
              text: msgList[i] + ' ',
              style: TextStyle(color: itsMe ? Colors.white : Colors.black87)),
        );
      }
    }
    return widList;
  }

  getUnderLineSpansTree(String message, bool itsMe) {
    List<String> lst;
    List<String> splitmsg;
    if (message.contains('https://')) {
      lst = message.split('https://');
      splitmsg = lst[1].split(' ');
      message = splitmsg[0];
      message = "https://" + message;
    } else if (message.contains('http://')) {
      lst = message.split('http://');
      splitmsg = lst[1].split(' ');
      message = splitmsg[0];
      message = "http://" + message;
    } else if (message.contains('www.')) {
      lst = message.split('www.');
      splitmsg = lst[1].split(' ');
      message = splitmsg[0];
      message = "www." + splitmsg[0];
    }
    message = Uri.encodeFull(message);

    List<TextSpan> widList = [];

    if (lst[0].isNotEmpty) {
      widList.add(
        TextSpan(
            text: lst[0] + ' ',
            style: TextStyle(
              color: itsMe ? Colors.white : Colors.black87,
            )),
      );
    }

    widList.add(
      TextSpan(
          text: message + ' ',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: itsMe ? Colors.white : Colors.black87,
          )),
    );

    for (int i = 1; i < splitmsg.length; i++) {
      widList.add(
        TextSpan(
            text: splitmsg[i] + ' ',
            style: TextStyle(color: itsMe ? Colors.white : Colors.black87)),
      );
    }
    return widList;
  }

  launchBrowser(String message) async {
    if (message.contains('https://')) {
      List<String> lst = message.split('https://');
      List<String> splitmsg = lst[1].split(' ');
      message = "https://" + splitmsg[0];
    } else if (message.contains('http://')) {
      List<String> lst = message.split('http://');
      List<String> splitmsg = lst[1].split(' ');
      message = "http://" + splitmsg[0];
    } else if (message.contains('www.')) {
      List<String> lst = message.split('www.');
      List<String> splitmsg = lst[1].split(' ');
      message = "https://www." + splitmsg[0];
    }
    message = Uri.encodeFull(message);
    if (message == "https://arahglobal.com/register") {
      navigateTo(context, NULanding());
    } else {
      navigateTo(context, WebUrlView(message));
    }
  }
}
