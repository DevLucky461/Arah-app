import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetail extends StatelessWidget {
  final String imagePath;

  ImageDetail(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color_primary,
          leading: InkWell(
            child: Icon(Icons.arrow_back_sharp, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: PhotoView(
          imageProvider: NetworkImage(getImage(imagePath)),
        ));
  }
}
