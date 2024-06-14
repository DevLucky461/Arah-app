import 'package:arah_app/chat/photo_detail.dart';
import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';

class GroupPhotos extends StatefulWidget {
  final List<ChatView> lst;
  final String title;

  GroupPhotos(this.lst, this.title);

  @override
  _GroupPhotosState createState() => _GroupPhotosState();
}

class _GroupPhotosState extends State<GroupPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
            widget.lst.length,
            (index) => Padding(
                  padding: EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      navigateTo(context, PhotoDetail(widget.lst, index));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        getImage(widget.lst[index].message),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
