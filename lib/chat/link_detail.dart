import 'package:arah_app/chat/web_url_view.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';

class LinkDetail extends StatefulWidget {
  final List<ChatView> lst;

  LinkDetail(this.lst);

  @override
  _LinkDetailState createState() => _LinkDetailState();
}

class _LinkDetailState extends State<LinkDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, WebUrlView(getWebLink(widget.lst[index].message)));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      getLink(widget.lst[index].message),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          },
          itemCount: widget.lst.length,
        ),
      ),
    );
  }

  String getLink(String message) {
    List<String> lst;
    List<String> splitmsg;
    if (message.contains('https://')) {
      lst = message.split('https://');
      splitmsg = lst[1].split(' ');
      message = "https://" + splitmsg[0];
    } else if (message.contains('http://')) {
      lst = message.split('http://');
      splitmsg = lst[1].split(' ');
      message = "http://" + splitmsg[0];
    } else if (message.contains('www.')) {
      lst = message.split('www.');
      splitmsg = lst[1].split(' ');
      message = "www." + splitmsg[0];
    }
    return Uri.encodeFull(message);
  }

  String getWebLink(String message) {
    List<String> lst;
    List<String> splitmsg;
    if (message.contains('https://')) {
      lst = message.split('https://');
      splitmsg = lst[1].split(' ');
      message = "https://" + splitmsg[0];
    } else if (message.contains('http://')) {
      lst = message.split('http://');
      splitmsg = lst[1].split(' ');
      message = "http://" + splitmsg[0];
    } else if (message.contains('www.')) {
      lst = message.split('www.');
      splitmsg = lst[1].split(' ');
      message = "https://www." + splitmsg[0];
    }
    return Uri.encodeFull(message);
  }
}
