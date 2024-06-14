import 'package:arah_app/models/chat_view.dart';
import 'package:arah_app/utils/common.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetail extends StatefulWidget {
  final List<ChatView> lst;
  final int initialIndex;

  PhotoDetail(this.lst, this.initialIndex);

  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  String title;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    title = widget.lst[0].name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: color_primary,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
                initialPage: widget.initialIndex,
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                // autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    title = widget.lst[index].name;
                  });
                }),
            carouselController: _controller,
            items: widget.lst
                .map((item) => PhotoView(
                      imageProvider: NetworkImage(getImage(item.message)),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
