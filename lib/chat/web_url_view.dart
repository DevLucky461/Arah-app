import 'dart:io';

import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebUrlView extends StatefulWidget {
  final String url;

  WebUrlView(this.url);

  @override
  WebUrlViewState createState() => WebUrlViewState();
}

class WebUrlViewState extends State<WebUrlView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
