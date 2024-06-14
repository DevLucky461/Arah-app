import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:arah_app/chat/chat_detail.dart';
import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
// import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  final People single;
  final String UUID;
  final String type;
  final bool isAdmin;
  final ChatMainBodyState state;

  ChatScreen(this.single, this.UUID, this.type, this.isAdmin, this.state);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool scheduledMsg = false;

  bool btnClick = false;

  bool _focused = false;

  bool emojiShowing = false;

  bool showDetailOption = false;

  FocusNode _node;

  final TextEditingController _scheduleController = TextEditingController();

  final TextEditingController _msgController = TextEditingController();

  final keyChatDetail = new GlobalKey<ChatDetailState>();

  List<ChatView> lst = [];

  List<int> selectedMessageIDList = [];

  Future messages;

  Database _database;

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'arah.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  static void _createDb(Database db) async {
    await db.execute(
        'CREATE TABLE messages(id INTEGER PRIMARY KEY, UUID TEXT, message TEXT, message_type TEXT, message_datetime TEXT,  created_at TEXT, sender_name TEXT, phone TEXT, user_image TEXT, user_id INTEGER)');
    print("database created");
  }

  void _insertMessage(Map<String, dynamic> data) async {
    await _database.insert(
      'messages',
      {
        'id': data['id'],
        'UUID': data['UUID'],
        'message': data['message'],
        'message_type': data['message_type'],
        'message_datetime': data['message_datetime'],
        'created_at': data['created_at'],
        'sender_name': data['sender_name'],
        'phone': data['phone'],
        'user_image': data['image'],
        'user_id': data['user_id'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> viewMessage(bool isFirst) async {
    _database = await database();
    List<Map> message_list =
        await _database.rawQuery('SELECT * from messages WHERE UUID="' + widget.UUID + '"');
    print('From database ===> ');
    print(message_list);
    if (message_list.length == 0) {
      CallApi api = CallApi();
      var data = {'token': await api.getToken(), 'UUID': widget.UUID, 'isFirst': isFirst};
      var res = await api.postData(data, 'view-message', this.context);
      var body = json.decode(res.body);
      if (body['success'] != null && body['success']) {
        List<ChatView> lstPeople = [];
        List<dynamic> list = body['message'];
        for (int i = 0; i < list.length; i++) {
          print(list[i]);
          await _insertMessage(list[i]);
          lstPeople.add(ChatView.fromJson(list[i]));
        }
        lstPeople.sort((a, b) => a.name.compareTo(b.name));
        lstPeople.sort((a, b) => a.created_at.compareTo(b.created_at));

        return {"unread_time": body['unread_time'], "messages": lstPeople};
      } else
        return {"unread_time": null, "messages": []};
    } else {
      List<ChatView> lstPeople = [];
      for (int i = 0; i < message_list.length; i++) {
        print(message_list[i]);
        lstPeople.add(ChatView.fromJson(message_list[i]));
      }
      lstPeople.sort((a, b) => a.name.compareTo(b.name));
      lstPeople.sort((a, b) => a.created_at.compareTo(b.created_at));

      return {"unread_time": null, "messages": lstPeople};
    }
  }

  @override
  void initState() {
    messages = viewMessage(true);
    init();

    super.initState();
    _node = FocusNode(debugLabel: 'Type Message');
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _focused) {
      setState(() {
        _focused = _node.hasFocus;
        emojiShowing = false;
      });
    }
  }

  // Socket socket;

  void init() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print('Chat Screen FCM!');
        if (this.mounted) {
          if (widget.UUID == data['UUID']) {
            lst.add(ChatView(
              message: data['message'],
              phone: data['phone'],
              message_type: data['type'],
              name: data['name'],
              UUID: data['UUID'],
              image: data['image'],
              showImg: false,
              isFound: false,
              created_at: data['created_at'],
              isSelected: false,
            ));
            print("data === >");

            Map<String, dynamic> insert_data = {
              'id': data['id'],
              'UUID': data['UUID'],
              'message': data['message'],
              'message_type': data['type'],
              'message_datetime': getDatabaseDateTime(data['updated_at']),
              'created_at': getDatabaseDateTime(data['created_at']),
              'sender_name': data['name'],
              'phone': data['phone'],
              'image': data['image'],
              'user_id': data['user_id']
            };
            print(insert_data);
            //insert new message to local database
            _insertMessage(insert_data);
            if (user.name != data['name']) {
              messages = viewMessage(false).then((value) {
                keyChatDetail.currentState.getMobile(false);
                widget.state.readChatMsg();
              });
            } else {
              keyChatDetail.currentState.getMobile(false);
              widget.state.readChatMsg();
            }
          } else
            widget.state.readChatMsg();
        }
      }
    });

    // socket = io(channel, OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());
    // socket.connect();
    //
    // socket.onConnectError((data) => print('error connecting socket ' + data.toString()));
    //
    // socket.on("socket_message", (data) {
    //   print('socket_message ' + data.toString());
    //
    //   if (this.mounted) {
    //     if (widget.UUID == data['UUID']) {
    //       lst.add(ChatView(
    //         message: data['message'],
    //         phone: data['user_phone'],
    //         message_type: data['message_type'],
    //         name: data['sender_name'],
    //         UUID: data['UUID'],
    //         image: data['user_image'],
    //         showImg: false,
    //         isFound: false,
    //         created_at: data['created_at'],
    //       ));
    //
    //       if (user.name != data['sender_name']) {
    //         messages = viewMessage(false).then((value) {
    //           keyChatDetail.currentState.getMobile(false);
    //           widget.state.readChatMsg();
    //         });
    //       } else {
    //         keyChatDetail.currentState.getMobile(false);
    //         widget.state.readChatMsg();
    //       }
    //     } else
    //       widget.state.readChatMsg();
    //   }
    // });
    //
    // socket.onConnect((_) {
    //   print('******************Socket Connected');
    //   var user = [
    //     widget.UUID,
    //     widget.single.name,
    //   ];
    //   //print(user.toString());
    //   socket.emit("user_connected", (user));
    // });
  }

  @override
  void dispose() {
    // try {
    //   socket.close();
    // } catch (e) {
    //   //print(e);
    // }
    widget.state.entered = true;
    _node.removeListener(_handleFocusChange);
    // The attachment will automatically be detached in dispose().
    _node.dispose();
    super.dispose();
  }

  void showOption() {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: this.context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle),
                    child: scheduledMsg
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(children: [
                              Container(
                                width: getScreenWidth(context),
                                height: 100,
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  controller: _scheduleController,
                                  maxLines: double.maxFinite.floor(),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: Languages.of(context).Type_message,
                                    contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 15.0),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xffBCBCBC))),
                                  ),
                                ),
                              ),
                              SizeArah(9, 0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RaisedButton(
                                      padding: EdgeInsets.all(12),
                                      onPressed: () {
                                        if (_scheduleController.text.isNotEmpty) {
                                          Navigator.pop(context);
                                          selectTime();
                                        } else {
                                          showToast(Languages.of(context).enter_message);
                                        }
                                      },
                                      color: color_primary,
                                      textColor: arah_white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(60)),
                                      child: Text(
                                        Languages.of(context).Schedule_Message,
                                        style: GoogleFonts.lato(
                                            fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          )
                        : Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  cameraConnect();
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: getScreenWidth(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      Languages.of(context).Photo_Video,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context),
                                height: 1,
                                color: Colors.grey,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    scheduledMsg = true;
                                    showOption();
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: getScreenWidth(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      Languages.of(context).Schedule_Message,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context),
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                  ),
                  Container(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _scheduleController.text = "";
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle),
                      width: getScreenWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          Languages.of(context).Cancel,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onEmojiSelected(Emoji emoji) {
    _msgController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(TextPosition(offset: _msgController.text.length));
  }

  _onBackspacePressed() {
    _msgController
      ..text = _msgController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(TextPosition(offset: _msgController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar:
          // selectedMessageIDList.length > 0
          //     ? AppBar(
          //         leading: new IconButton(
          //           icon: new Icon(
          //             Icons.arrow_back_ios,
          //             color: Colors.white,
          //           ),
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //         ),
          //         titleSpacing: 0,
          //         title: Text(
          //           selectedMessageIDList.length.toString(),
          //           style: TextStyle(
          //             color: Colors.white,
          //           ),
          //         ),
          //       )
          //     :
          AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: widget.single.image == null
                      ? AssetImage('assets/arah/Icon-Avatar.png')
                      : NetworkImage(BASEURL + widget.single.image),
                  maxRadius: 20,
                ),
                Positioned(
                  top: 30,
                  left: 30,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor:
                        true ? Color(0xFF66d046) : (false ? Color(0xFFffb400) : Color(0xFFacacac)),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.single.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color_primary, color_second],
            ),
          ),
        ),
        // actions: [
        //   InkWell(
        //     child: const Icon(
        //       Icons.videocam_outlined,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   SizedBox(width: 20),
        //   InkWell(
        //     child: const Icon(
        //       Icons.local_phone_outlined,
        //       color: Colors.white,
        //       size: 25,
        //     ),
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   // widget.type == "personal"
        //   //     ?
        //   PopupMenuButton(
        //     color: Colors.white,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //     onSelected: (value) {
        //       switch (value) {
        //         case '1':
        //           print("Pressed 1");
        //           break;
        //         case '2':
        //           print("Pressed 2");
        //           break;
        //         case '3':
        //           print("Pressed 3");
        //           break;
        //         case '4':
        //           print("Pressed 4");
        //           break;
        //         case '5':
        //           print("Pressed 5");
        //           break;
        //         default:
        //           break;
        //       }
        //     },
        //     icon: Icon(
        //       Icons.more_vert_outlined,
        //       color: Colors.white,
        //       size: 25,
        //     ),
        //     itemBuilder: (BuildContext context) {
        //       var list = <PopupMenuEntry<Object>>[];
        //       list.add(PopupMenuItem<String>(
        //         value: '1',
        //         child: Text(Languages.of(context).ViewContact),
        //       ));
        //       list.add(
        //         PopupMenuDivider(
        //           height: 0.5,
        //         ),
        //       );
        //       list.add(
        //         PopupMenuItem<String>(
        //           value: '2',
        //           child: Text(Languages.of(context).Mark_as_Read),
        //         ),
        //       );
        //       list.add(
        //         PopupMenuDivider(
        //           height: 0.5,
        //         ),
        //       );
        //       list.add(
        //         PopupMenuItem<String>(
        //           value: '3',
        //           child: Text(Languages.of(context).Mark_as_Unread),
        //         ),
        //       );
        //       list.add(
        //         PopupMenuDivider(
        //           height: 0.5,
        //         ),
        //       );
        //       list.add(
        //         PopupMenuItem<String>(
        //           value: '4',
        //           child: Text(Languages.of(context).Mute),
        //         ),
        //       );
        //       list.add(
        //         PopupMenuDivider(
        //           height: 0.5,
        //         ),
        //       );
        //       list.add(
        //         PopupMenuItem<String>(
        //           value: '5',
        //           child: Text(Languages.of(context).delete),
        //         ),
        //       );
        //       return list;
        //     },
        //   )
        //   // : Padding(
        //   //     padding: const EdgeInsets.all(15.0),
        //   //     child: InkWell(
        //   //       onTap: () {
        //   //         navigateTo(
        //   //             context,
        //   //             GroupDetails(widget.state, widget.isAdmin, widget.UUID, widget.type,
        //   //                 (String groupName) {
        //   //               setState(() {
        //   //                 widget.single.name = groupName;
        //   //               });
        //   //               widget.state.updateName(widget.single);
        //   //             }, lst, widget.single));
        //   //       },
        //   //       child: const Icon(
        //   //         Icons.more_vert_outlined,
        //   //         color: Colors.white,
        //   //         size: 25,
        //   //       ),
        //   //     ),
        //   //   ),
        // ],
      ),
      // PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: Stack(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //             colors: [color_primary, color_second],
      //           ),
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.only(top: 30),
      //           child: Row(
      //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
      //                 child: InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: const Icon(
      //                     Icons.arrow_back_ios,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //               Stack(
      //                 children: [
      //                   CircleAvatar(
      //                     backgroundImage: widget.single.image == null
      //                         ? AssetImage('assets/arah/Icon-Avatar.png')
      //                         : NetworkImage(BASEURL + widget.single.image),
      //                     maxRadius: 20,
      //                   ),
      //                   Positioned(
      //                     top: 30,
      //                     left: 30,
      //                     child: CircleAvatar(
      //                       radius: 5,
      //                       backgroundColor: true
      //                           ? Color(0xFF66d046)
      //                           : (false ? Color(0xFFffb400) : Color(0xFFacacac)),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 width: 12,
      //               ),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: <Widget>[
      //                     Text(
      //                       widget.single.name,
      //                       style: TextStyle(
      //                         fontSize: 18,
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               InkWell(
      //                 child: const Icon(
      //                   Icons.videocam_outlined,
      //                   color: Colors.white,
      //                   size: 30,
      //                 ),
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //               SizedBox(width: 20),
      //               InkWell(
      //                 child: const Icon(
      //                   Icons.local_phone_outlined,
      //                   color: Colors.white,
      //                   size: 25,
      //                 ),
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //               widget.type == "personal"
      //                   ? Padding(
      //                       padding: const EdgeInsets.all(15.0),
      //                       child: InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             showDetailOption = true;
      //                           });
      //                         },
      //                         child: const Icon(
      //                           Icons.more_vert_outlined,
      //                           color: Colors.white,
      //                           size: 25,
      //                         ),
      //                       ),
      //                     )
      //                   : Padding(
      //                       padding: const EdgeInsets.all(15.0),
      //                       child: InkWell(
      //                         onTap: () {
      //                           navigateTo(
      //                               context,
      //                               GroupDetails(
      //                                   widget.state, widget.isAdmin, widget.UUID, widget.type,
      //                                   (String groupName) {
      //                                 setState(() {
      //                                   widget.single.name = groupName;
      //                                 });
      //                                 widget.state.updateName(widget.single);
      //                               }, lst, widget.single));
      //                         },
      //                         child: const Icon(
      //                           Icons.more_vert_outlined,
      //                           color: Colors.white,
      //                           size: 25,
      //                         ),
      //                       ),
      //                     ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _focused = false;
          });
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.only(top: 82),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            // shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 35.0,
                          maxHeight: getScreenHeight(context),
                        ),
                        child: FutureBuilder(
                          future: messages,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              lst = snapshot.data['messages'];
                              return ChatDetail(
                                keyChatDetail,
                                widget.single,
                                lst,
                                "",
                                snapshot.data['unread_time'],
                                selectedMessageIDList,
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  ((widget.type == "community") && (!widget.isAdmin))
                      ? Container()
                      : Container(
                          height: 70,
                          color: color_background,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: getScreenWidth(context) / 5 * 4,
                                    // padding: EdgeInsets.all(8),
                                    alignment: AlignmentDirectional.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              emojiShowing = true;
                                            });
                                            _node.unfocus();
                                          },
                                          child: Container(
                                            width: getScreenWidth(context) / 13,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.mood,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: getScreenWidth(context) / 5 * 3,
                                          alignment: AlignmentDirectional.center,
                                          child: new SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            reverse: true,
                                            child: TextFormField(
                                              // key: GlobalKey(),
                                              controller: _msgController,
                                              keyboardType: TextInputType.multiline,
                                              textInputAction: TextInputAction.newline,
                                              maxLines: null,
                                              focusNode: _node,
                                              textCapitalization: TextCapitalization.sentences,
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 16),
                                                hintText: Languages.of(context).Type_message,
                                                // contentPadding:
                                                //     EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 15.0),
                                                // border: InputBorder.none,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            scheduledMsg = false;
                                            showOption();
                                          },
                                          child: Container(
                                            width: getScreenWidth(context) / 13,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 10, bottom: 5),
                                              child: Transform.rotate(
                                                angle: 315,
                                                child: Icon(
                                                  Icons.attach_file_outlined,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _focused
                                      ? InkWell(
                                          onTap: () {
                                            String data = _msgController.text;
                                            if (data.isNotEmpty) {
                                              sendMsg(data);
                                              setState(() {
                                                _msgController.text = "";
                                              });
                                            } else
                                              showToast(Languages.of(context).enter_message);
                                          },
                                          child: Container(
                                            width: getScreenWidth(context) / 7,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Image.asset("assets/arah/Button-Send.png"),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showToast("Coming Soon");
                                          },
                                          child: Container(
                                            width: getScreenWidth(context) / 7,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child:
                                                  Image.asset("assets/arah/Button-VoiceChat.png"),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                          onEmojiSelected: (Category category, Emoji emoji) {
                            _onEmojiSelected(emoji);
                          },
                          onBackspacePressed: _onBackspacePressed,
                          config: const Config(
                              columns: 7,
                              emojiSizeMax: 32.0,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              initCategory: Category.RECENT,
                              bgColor: Color(0xFFF2F2F2),
                              indicatorColor: Colors.blue,
                              iconColor: Colors.grey,
                              iconColorSelected: Colors.blue,
                              progressIndicatorColor: Colors.blue,
                              backspaceColor: Colors.blue,
                              showRecentsTab: true,
                              recentsLimit: 28,
                              noRecentsText: 'No Recents',
                              noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
                              categoryIcons: CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMsg(String msg) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'UUID': widget.UUID,
      'receiver_phone': widget.single.phone,
      'message': msg,
      'message_type': 'text',
    };
    // Map<String, dynamic> insert_data = {
    //   'id': data['id'],
    //   'UUID': data['UUID'],
    //   'message': data['message'],
    //   'message_type': data['type'],
    //   'message_datetime': getDatabaseDateTime(data['updated_at']),
    //   'created_at': getDatabaseDateTime(data['created_at']),
    //   'sender_name': data['name'],
    //   'phone': data['phone'],
    //   'image': data['image'],
    //   'user_id': data['user_id']
    // };
    // print(insert_data);
    // //insert new message to local database
    // _insertMessage(insert_data);
    var res = await api.postData(data, 'send-message', this.context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      // showToast('msg send');

    } else {
      // showToast('not send');
    }
  }

  Future<void> cameraConnect() async {
    PickedFile _image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 60);

    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(CallApi.BASEAPIURL + "send-message"));

    request.fields["token"] = await CallApi().getToken();
    request.fields["UUID"] = widget.UUID;
    request.fields["receiver_phone"] = widget.single.phone;
    // 1. text
    // 2. image
    // 3. file
    request.fields["message_type"] = 'image';
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("message", _image.path);
      request.files.add(pic);
    }
    var response = await request.send();

    //Get the response from the server
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    var body = json.decode(responseString);
  }

  //Bottom sheet for Schedule message
  selectTime() {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    DateTime scheduleTime = now.add(Duration(minutes: 1));
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: this.context,
        builder: (context) => Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).copyWith().size.height / 6,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: now.add(Duration(minutes: 1)),
                                onDateTimeChanged: (DateTime time) {
                                  setState(() {
                                    scheduleTime = time;
                                  });
                                },
                                use24hFormat: false,
                                minimumDate: now,
                                maximumDate: now.add(Duration(days: 365)),
                                minuteInterval: 1,
                                mode: CupertinoDatePickerMode.dateAndTime,
                              )),
                          SizeArah(5, 0),
                          btnClick
                              ? Center(child: CircularProgressIndicator())
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: RaisedButton(
                                        padding: EdgeInsets.all(12),
                                        onPressed: () {
                                          if (DateTime.now().isBefore(scheduleTime)) {
                                            scheduleMessageCall(scheduleTime.toString());

                                            setState(() {
                                              btnClick = true;
                                            });

                                            Navigator.pop(context);
                                          } else
                                            showToast(
                                                Languages.of(context).schedule_time_validation);
                                        },
                                        color: color_primary,
                                        textColor: arah_white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(60)),
                                        child: Text(
                                          Languages.of(context).set_time,
                                          style: GoogleFonts.lato(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                      color: Colors.transparent,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _scheduleController.text = "";
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle),
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).Cancel,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> scheduleMessageCall(String time) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'UUID': widget.UUID,
      'message': _scheduleController.text,
      'message_type': 'schedule_text',
      'datetime': getScheduleGMT(time),
    };
// Map<String, dynamic> insert_data = {
    //   'id': data['id'],
    //   'UUID': data['UUID'],
    //   'message': data['message'],
    //   'message_type': data['type'],
    //   'message_datetime': getDatabaseDateTime(data['updated_at']),
    //   'created_at': getDatabaseDateTime(data['created_at']),
    //   'sender_name': data['name'],
    //   'phone': data['phone'],
    //   'image': data['image'],
    //   'user_id': data['user_id']
    // };
    // print(insert_data);
    // //insert new message to local database
    // _insertMessage(insert_data);
    var res = await api.postData(data, 'schedule-message', this.context);
    var body = json.decode(res.body);
    setState(() {
      _scheduleController.text = "";
      btnClick = false;
    });

    if (body['success'] != null && body['success']) {
      showToast(body['message']);
    }
  }
}

typedef void OnBackCall(String name);
typedef void OnSearch();
