import 'dart:convert';

import 'package:arah_app/chat/chat_list_row.dart';
import 'package:arah_app/chat/chat_screen.dart';
import 'package:arah_app/chat/options/chat_select_options.dart';
import 'package:arah_app/chat/options/new_options.dart';
import 'package:arah_app/chat/people_page.dart';
import 'package:arah_app/group/create_group.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/landing_page.dart';
import 'package:arah_app/models/chat_msg.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMainBody extends StatefulWidget {
  final LandingPageState state;

  ChatMainBody(this.state);

  @override
  State<StatefulWidget> createState() => ChatMainBodyState();
}

class ChatMainBodyState extends State<ChatMainBody>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<ChatMainBody> {
  bool peoplePage = false;
  bool showOption = false;
  bool showChatOption = false;
  bool showSearch = false;
  bool isSelectedCall = false;
  List<String> selectedUUIDList = [];

  TextEditingController searchController = TextEditingController();

  Future post;
  final key_people = GlobalKey<PeopleListState>();

  Future<void> readChatMsg() async {
    post = getRoom();
  }

  Future<List<ChatMsg>> getRoom() async {
    CallApi api = CallApi();
    String fcmId = await FirebaseMessaging.instance.getToken();
    var data = {'token': await api.getToken(), 'fcm_token': fcmId};
    var res = await api.postData(data, 'view-room', context);
    var body = json.decode(res.body);
    lstSearch.clear();
    if (body['success'] != null && body['success']) {
      List<ChatMsg> lstPeople = [];
      List<dynamic> list = body['room'];
      bool unreadExist = false;
      for (int i = 0; i < list.length; i++) {
        ChatMsg people = ChatMsg.fromJson(list[i]);
        lstPeople.add(people);
        if (people.unread > 0) unreadExist = true;
      }
      widget.state.setUnreadState(unreadExist);
      lstPeople.sort((a, b) => a.name.compareTo(b.name));
      lstPeople.sort((a, b) {
        String aDate = a.last_received == '' ? a.room_created : a.last_received;
        String bDate = b.last_received == '' ? b.room_created : b.last_received;
        return bDate.compareTo(aDate);
      });
      lstSearch.addAll(lstPeople);
      return lstPeople;
    } else {
      return [];
    }
  }

  updateName(People single) {
    for (int i = 0; i < lst.length; i++) {
      if (single.UUID == lst[i].UUID) {
        setState(() => lst[i].name = single.name);
        break;
      }
    }
  }

  onSearchTextChanged(String text) async {
    if (peoplePage) {
      if (key_people.currentState != null) {
        key_people.currentState.onSearchTextChanged(text);
      }

      return;
    }
    lstSearch.clear();
    if (text.isEmpty) {
      lstSearch.clear();
      for (int i = 0; i < lst.length; i++) lstSearch.add(lst[i]);
      setState(() {});
      return;
    }

    lst.forEach((userDetail) {
      if (userDetail.name.toLowerCase().trim().contains(text.toLowerCase().trim()))
        lstSearch.add(userDetail);
    });
    setState(() {});
  }

  Future<void> deleteChat(value) async {
    CallApi api = CallApi();
    var data = {'token': await api.getToken(), 'UUID': value};

    var res = await api.postData(data, 'delete-room', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) readChatMsg();
  }

  bool entered = true;

  @override
  void initState() {
    super.initState();
    entered = true;

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        print('Initial Chat Page FCM!');
        print(message.messageId);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print('Chat Page FCM!');
        if (entered) readChatMsg();
        // if (user.name != data['name']) {
        //   flutterLocalNotificationsPlugin.show(
        //       notification.hashCode,
        //       notification.title,
        //       notification.body,
        //       NotificationDetails(
        //         android: AndroidNotificationDetails(
        //           notificationChannel.id,
        //           notificationChannel.name,
        //           notificationChannel.description,
        //           // TODO add a proper drawable resource to android, for now using
        //           //      one that already exists in example app.
        //           icon: 'notification_icon',
        //         ),
        //       ));
        // }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.messageId);
    });

    readChatMsg();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) readChatMsg();
  }

  @override
  void dispose() {
    entered = false;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<ChatMsg> lst = [];
  List<ChatMsg> lstSearch = [];

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      isSelectedCall
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reset();
                                        });
                                      },
                                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      selectedUUIDList.length.toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(Icons.push_pin_outlined, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // set up the buttons
                                        // ignore: deprecated_member_use
                                        Widget cancelBtn = FlatButton(
                                          child: Text(Languages.of(context).cancel),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                        // ignore: deprecated_member_use
                                        Widget okBtn = FlatButton(
                                          child: Text(Languages.of(context).ok),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectedUUIDList.map((e) => deleteChat(e));

                                            setState(() {
                                              isSelectedCall = false;
                                            });
                                          },
                                        );

                                        // set up the AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          content: Text(Languages.of(context).delete_chat_history),
                                          actions: [
                                            cancelBtn,
                                            okBtn,
                                          ],
                                        );

                                        // show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                      child: Icon(Icons.delete_outline, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child:
                                          Icon(Icons.file_download_outlined, color: Colors.white),
                                    ),
                                    selectedUUIDList.length == 1
                                        ? SizedBox(
                                            width: 10,
                                          )
                                        : Container(),
                                    selectedUUIDList.length == 1
                                        ? InkWell(
                                            onTap: () {},
                                            child: Icon(Icons.notifications_off_outlined,
                                                color: Colors.white),
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showChatOption = true;
                                        });
                                      },
                                      child: Icon(Icons.more_vert_outlined, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          peoplePage = false;
                                        });
                                      },
                                      child: Text(
                                        Languages.of(context).Messages,
                                        style: GoogleFonts.lato(
                                            fontSize: 28,
                                            color: peoplePage ? arah_white : Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // SizeArah(0, 30),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       peoplePage = true;
                                    //     });
                                    //   },
                                    //   child: Text(
                                    //     Languages.of(context).People,
                                    //     style: GoogleFonts.lato(
                                    //         fontSize: peoplePage ? 28 : 18,
                                    //         color: peoplePage
                                    //             ? Colors.white
                                    //             : arah_white,
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    // ),
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
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showOption = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.more_vert_outlined,
                                      color: arah_white,
                                    ),
                                  )
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
              // peoplePage
              //     ? Expanded(
              //         //PeoplePage
              //         child: Container(
              //           height: getScreenHeight(context) - 100 - 190,
              //           child: PeopleList(key_people, this),
              //         ),
              //       )
              //     :
              Expanded(
                //ChatHomeScreen
                child: FutureBuilder<List<ChatMsg>>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      lst = snapshot.data;

                      return RefreshIndicator(
                          onRefresh: readChatMsg,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    People single = People(
                                        name: lstSearch[index].name,
                                        UUID: lstSearch[index].UUID,
                                        phone: lstSearch[index].phone,
                                        image: lstSearch[index].image);

                                    setState(() {
                                      reset();

                                      lstSearch[index].unread = 0;
                                      lst[lst.indexOf(lstSearch[index])].unread = 0;
                                      bool unreadExist = false;
                                      for (int i = 0; i < lst.length; i++)
                                        if (lst[i].unread > 0) {
                                          unreadExist = true;
                                          break;
                                        }
                                      widget.state.setUnreadState(unreadExist);
                                      searchController.text = "";
                                    });
                                    getUserId(index, single);
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      lstSearch[index].selected = !lstSearch[index].selected;
                                      lstSearch[index].selected
                                          ? (selectedUUIDList.add(lstSearch[index].UUID))
                                          : (selectedUUIDList.remove(lstSearch[index].UUID));
                                      isSelectedCall = true;
                                    });
                                    if (selectedUUIDList.length == 0) {
                                      reset();
                                    }
                                  },
                                  child: ListRow(lstSearch[index]));
                            },
                            itemCount: lstSearch.length,
                          ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          showOption
              ? Positioned(
                  right: 20,
                  top: 35,
                  child: NewOptions(peoplePage, (int optionIndex) {
                    if (optionIndex == 0) {
                      navigateTo(context, PeopleList(key_people, this));
                    } else if (optionIndex == 1) {
                      navigateTo(context, CreateGroup(true, this));
                    } else if (optionIndex == 2) {
                      navigateTo(context, CreateGroup(false, this));
                    }
                    // else if (optionIndex == 3) {
                    //   navigateTo(
                    //       context, AddContact(key_people.currentState.lstPeople, key_people));
                    //   // showToast("Coming Soon");
                    // }
                    else if (optionIndex == 4) {
                      key_people.currentState.readContacts();
                    }

                    setState(() {
                      showOption = false;
                    });
                  }))
              : Container(),
          showChatOption
              ? Positioned(
                  right: 20,
                  top: 35,
                  child: ChatSelectOptions((int optionIndex) {
                    if (optionIndex == 0) {
                      showToast("Mark as unread");
                    } else if (optionIndex == 1) {
                      showToast("Read All");
                    } else if (optionIndex == 2) {
                      showToast("Delete");
                    } else if (optionIndex == 3) {
                      selectAll();
                      showToast("Select All");
                    } else if (optionIndex == 4) {
                      showToast("Export Chat");
                    } else if (optionIndex == 5) {
                      showToast("Exit Group");
                    }

                    setState(() {
                      showChatOption = false;
                    });
                  }))
              : Container(),
        ],
      ),
    );
  }

  getUserId(int index, People single) {
    entered = false;
    bool isAdmin = false;
    if (lstSearch[index].type == "community" && lstSearch[index].user_id == user.id) isAdmin = true;
    print(single);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatScreen(single, lstSearch[index].UUID, lstSearch[index].type, isAdmin, this)));
  }

  void reset() {
    for (int i = 0; i < lstSearch.length; i++) lstSearch[i].selected = false;
    selectedUUIDList = [];

    isSelectedCall = false;
  }

  void selectAll() {
    for (int i = 0; i < lstSearch.length; i++) {
      lstSearch[i].selected = true;
      selectedUUIDList.add(lstSearch[i].UUID);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
