import 'dart:convert';
import 'dart:typed_data';

import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/chat/chat_screen.dart';
import 'package:arah_app/chat/group_photos.dart';
import 'package:arah_app/chat/link_detail.dart';
import 'package:arah_app/group/invite_page.dart';
import 'package:arah_app/group/search_chat_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/models/people.dart';
import 'package:arah_app/models/room_member.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GroupDetails extends StatefulWidget {
  final String UUID;
  final String type;
  final OnBackCall callback;
  final bool isAdmin;
  final ChatMainBodyState state;
  final List<ChatView> lst;
  final People single;

  GroupDetails(this.state, this.isAdmin, this.UUID, this.type, this.callback,
      this.lst, this.single);

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  bool btnChangeImg = false;
  String GroupName = "";
  String GroupDesc = "";
  String GroupImg = "";
  bool isMuted = false;
  bool exiting = false;

  Future<List<RoomMember>> getGroupInfo() async {
    CallApi api = CallApi();
    var data = {'token': await api.getToken(), 'UUID': widget.UUID};
    var res = await api.postData(data, 'view-group-details', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      setState(() {
        GroupName = body['room_details']['group_name'];
        GroupDesc = body['room_details']['group_description'];
        if (GroupDesc == null) GroupDesc = "";
        GroupImg = body['room_details']['group_image'];
      });

      List<RoomMember> lst_room_member = [];
      List<dynamic> lst = body['room_member'];
      for (int i = 0; i < lst.length; i++) {
        lst_room_member.add(RoomMember.fromJson(lst[i]));
        if (lst_room_member[i].id == user.id)
          isMuted = lst_room_member[i].isMuted;
      }

      return lst_room_member;
    }
  }

  Future<void> cameraConnect() async {
    PickedFile _image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 60);
    if (_image == null) return;

    //create multipart request for POST or PATCH method
    setState(() {
      btnChangeImg = true;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse(CallApi.BASEAPIURL + "edit-group-photo"));

    request.fields["token"] = await CallApi().getToken();
    request.fields["UUID"] = widget.UUID;

    try {
      var pic = await http.MultipartFile.fromPath("group_photo", _image.path);
      request.files.add(pic);
    } catch (e) {
      // print(e);
    }
    var response = await request.send();

    //Get the response from the server
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    var body = json.decode(responseString);
    if (body['success'] != null && body['success']) {
      showToast(body['message']);
      post = getGroupInfo();
      widget.state.readChatMsg();
    } else
      showToast(Languages.of(context).error_occurred);

    setState(() {
      btnChangeImg = false;
    });
  }

  void showPhotoOrVideo() {
    List<ChatView> photoList = [];
    widget.lst.forEach((item) {
      if (item.message_type == 'image') photoList.add(item);
    });
    navigateTo(context, GroupPhotos(photoList, GroupName));
  }

  void showLinks() {
    List<ChatView> linkList = [];
    widget.lst.forEach((item) {
      if (checkForLink(item.message)) linkList.add(item);
    });
    navigateTo(context, LinkDetail(linkList));
  }

  void updateName(String name) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'group_name': name,
      'UUID': widget.UUID,
    };

    var res = await api.postData(data, 'edit-group-name', context);

    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      showToast(body['message']);
      setState(() {
        post = getGroupInfo();
      });
      widget.state.readChatMsg();
    } else
      showToast(Languages.of(context).error_occurred);
  }

  void updateDesc(String Desc) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'group_description': Desc,
      'UUID': widget.UUID,
    };

    var res = await api.postData(data, 'edit-group-description', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      showToast(body['message']);
      setState(() {
        post = getGroupInfo();
      });
      widget.state.readChatMsg();
    } else
      showToast(Languages.of(context).error_occurred);
  }

  Future post;

  @override
  void initState() {
    post = getGroupInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.callback.call(GroupName);
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            // color: Colors.white,
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
                          widget.callback.call(GroupName);
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.type == "group"
                                  ? Languages.of(context).Group
                                  : Languages.of(context).Community,
                              style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ((widget.type == "community") && (!widget.isAdmin))
                          ? Container()
                          : InkWell(
                              onTap: () {
                                showOption();
                              },
                              child: Text(
                                Languages.of(context).edit,
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Color(0xFF44D9B2),
                                    fontWeight: FontWeight.normal),
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                SizeArah(20, 0),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFF44D9B2),
                    child: btnChangeImg
                        ? Center(child: CircularProgressIndicator())
                        : GroupImg != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  getImage(GroupImg),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xffE3FFF8),
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Text(Languages.of(context).No_photo,
                                    style: GoogleFonts.lato(
                                        color: Colors.black, fontSize: 13))),
                  ),
                ),
                SizeArah(20, 0),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    GroupName,
                    style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizeArah(10, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(context,
                            SearchGrpChat(widget.single, null, widget.lst));
                        // Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xffE3FFF8),
                            child: Image.asset(
                              'assets/arah/search.png',
                              width: 100,
                              height: 100,
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // set up the buttons
                        Widget cancelBtn = FlatButton(
                          child: Text(Languages.of(context).cancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget okBtn = FlatButton(
                          child: Text(Languages.of(context).ok),
                          onPressed: () {
                            Navigator.pop(context);
                            changeNotificationSetting();
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          content: Text(isMuted
                              ? Languages.of(context).turn_on_notification
                              : Languages.of(context).turn_off_notification),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xffE3FFF8),
                            child: Image.asset(
                              isMuted
                                  ? 'assets/arah/bell_off.png'
                                  : 'assets/arah/bell.png',
                              width: 100,
                              height: 100,
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // set up the buttons
                        Widget cancelBtn = FlatButton(
                          child: Text(Languages.of(context).cancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget okBtn = FlatButton(
                          child: Text(Languages.of(context).ok),
                          onPressed: () {
                            Navigator.pop(context);
                            exitGroup();
                            setState(() {
                              exiting = true;
                            });
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          content: Text(widget.type == "group"
                              ? Languages.of(context).leave_group
                              : Languages.of(context).leave_community),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xffE3FFF8),
                            child: exiting
                                ? CircularProgressIndicator()
                                : Image.asset(
                                    'assets/arah/exit.png',
                                    width: 100,
                                    height: 100,
                                  )),
                      ),
                    ),
                  ],
                ),
                SizeArah(15, 0),
                Text(
                  GroupDesc == ""
                      ? (widget.type == "group"
                          ? Languages.of(context).No_grp_desc
                          : Languages.of(context).No_cmt_desc)
                      : GroupDesc,
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: GroupDesc == "" ? Colors.grey : Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizeArah(30, 0),
                Divider(),
                SizeArah(5, 0),
                InkWell(
                  onTap: () {
                    showPhotoOrVideo();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      Languages.of(context).Photo_Video,
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizeArah(5, 0),
                Divider(),
                SizeArah(5, 0),
                InkWell(
                  onTap: () {
                    showLinks();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      Languages.of(context).Links,
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizeArah(5, 0),
                Divider(),
                SizeArah(10, 0),
                Text(
                  widget.type == "group"
                      ? Languages.of(context).Group_Members
                      : Languages.of(context).Comm_Members,
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<RoomMember> lst = snapshot.data;
                      return Column(children: getChilds(lst));
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getChilds(List<RoomMember> lst) {
    List<Widget> list = [];
    list.add(((widget.type == "community") && (!widget.isAdmin))
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () {
                navigateTo(context, CreateInvite(widget.UUID, lst));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xffC5E2DF),
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Languages.of(context).Invite_Member,
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
            ),
          ));
    for (int i = 0; i < lst.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.all(6.0),
        child: InkWell(
          onTap: () {
            if (lst[i].id != user.id) callAPICreateRoomTwo(lst[i]);
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xffC5E2DF),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: lst[i].image == null || lst[i].image == ""
                      ? Container()
                      : Image.network(
                          getImage(lst[i].image),
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
                        lst[i].name,
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
        ),
      ));
    }
    return list;
  }

  void callAPICreateRoomTwo(RoomMember roomMember) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'receiver_phone': "",
      'receiver_id': roomMember.id,
      'group_type': 'personal',
    };
    var res = await api.postData(data, 'create-room-for-two', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      People people = new People(
        id: roomMember.id,
        name: roomMember.name,
        image: roomMember.image,
        phone: body['phone'],
        selected: false,
        UUID: body['UUID'],
      );
      widget.state.readChatMsg();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ChatScreen(
                  people, body['UUID'], "personal", false, widget.state)));
    } else
      showToast(Languages.of(context).error_occurred);
  }

  void showOption() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showAlertDialog(context);
                      },
                      child: Container(
                        color: Colors.white,
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).edit_group_name,
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
                        showAlertDialogGroupDesc(context);
                      },
                      child: Container(
                        color: Colors.white,
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).edit_group_desc,
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
                        cameraConnect();
                      },
                      child: Container(
                        color: Colors.white,
                        width: getScreenWidth(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            Languages.of(context).change_grp_photo,
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
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    TextEditingController _edtControllerName = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(5),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                    child: Column(
                      children: [
                        Text(Languages.of(context).edit_group_name,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _edtControllerName,
                          style: GoogleFonts.lato(color: Colors.black),
                          maxLength: 30,
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            filled: true,
                            counterText: "",
                            hintText: Languages.of(context).type_here,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            labelStyle: GoogleFonts.lato(color: Colors.white),
                            hintStyle: GoogleFonts.lato(
                                fontSize: 17, color: Colors.white),
                          ),
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            height: 0.5,
                            color: Colors.grey),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(Languages.of(context).Cancel,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (_edtControllerName.text
                                      .trim()
                                      .isNotEmpty) {
                                    updateName(_edtControllerName.text.trim());
                                  } else {}
                                },
                                child: Text(Languages.of(context).ok,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Color(0xff00CC99),
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  showAlertDialogGroupDesc(BuildContext context) {
    TextEditingController _edtControllerName = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(5),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                    child: Column(
                      children: [
                        Text(Languages.of(context).edit_group_desc,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8.0, 15, 8.0),
                          child: TextField(
                            controller: _edtControllerName,
                            style: GoogleFonts.lato(color: Colors.black),
                            maxLines: 4,
                            minLines: 4,
                            maxLength: 50,
                            decoration: InputDecoration(
                              filled: true,
                              counterText: "",
                              hintText: Languages.of(context).type_here,
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              labelStyle: GoogleFonts.lato(color: Colors.white),
                              hintStyle: GoogleFonts.lato(
                                  fontSize: 17, color: Colors.white),
                            ),
                            obscureText: false,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            height: 0.5,
                            color: Colors.grey),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(Languages.of(context).Cancel,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (_edtControllerName.text
                                      .trim()
                                      .isNotEmpty) {
                                    updateDesc(_edtControllerName.text.trim());
                                  } else {}
                                },
                                child: Text(Languages.of(context).ok,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Color(0xff00CC99),
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> exitGroup() async {
    CallApi api = CallApi();
    var data = {'token': await api.getToken(), 'UUID': widget.UUID};

    var res = await api.postData(data, 'delete-group-room', context);
    var body = json.decode(res.body);
    setState(() {
      exiting = false;
    });
    if (body['success'] != null && body['success']) {
      widget.state.readChatMsg();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> changeNotificationSetting() async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'UUID': widget.UUID,
      'rooms_notification': isMuted ? 'on' : 'off',
    };

    var res = await api.postData(data, 'room-change-notification', context);
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      setState(() {
        isMuted = !isMuted;
      });
    }
  }
}
