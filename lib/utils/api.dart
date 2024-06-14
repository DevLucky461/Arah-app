import 'dart:convert';

import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  static String TOKEN = "token";

  static String BASEAPIURL = BASEURL + 'api/';

  postData(data, String apiUrl, BuildContext context) async {
    String fullUrl = BASEAPIURL + apiUrl;
    print(fullUrl);
    print(jsonEncode(data));
    var resp = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    print(resp.body.toString());
    if (resp.body.toString().contains('TokenExpiredException')) {
      storeToken(null);
      Phoenix.rebirth(context);
    } else
      return resp;
  }

  postDataWithoutAPI(data, String apiUrl, BuildContext context) async {
    String fullUrl = BASEURL + apiUrl;
    print(fullUrl);
    print(jsonEncode(data));
    var resp = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    print(resp.body.toString());
    if (resp.body.toString().contains('TokenExpiredException')) {
      storeToken(null);
      Phoenix.rebirth(context);
    } else
      return resp;
  }

  _setHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  storeContactDetail(String detail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('detail', detail);
  }

  getContactDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('detail');
  }
}
