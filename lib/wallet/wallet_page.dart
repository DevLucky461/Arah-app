import 'dart:convert';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/transaction.dart';
import 'package:arah_app/utils/api.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool showAddressPage = false;
  String balance = "";
  String price = "";

  TextEditingController _addressKeyController = TextEditingController();
  TextEditingController _publicKeyController = TextEditingController();

  bool click = false;

  Future post;

  Future<List<Transaction>> getTransaction(context) async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
    };
    var res = await api.postData(data, 'view-transactions', context);
    var body = json.decode(res.body);

    if (body['success'] != null && body['success']) {
      List<Transaction> trans = [];
      List<dynamic> list = body['data']['transactions'];
      for (int i = 0; i < list.length; i++) {
        trans.add(Transaction.fromJson(list[i]));
      }
      setState(() {
        balance = body['data']['coins_balance'].toString();
        price = body['data']['market_price'].toString();
      });
      return trans;
    } else
      setState(() {
        showAddressPage = true;
      });
  }

  @override
  void initState() {
    post = getTransaction(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          color: color_primary,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: Row(
              children: [
                Text(
                  Languages.of(context).My_ARAH_Coins,
                  style: GoogleFonts.lato(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      body: showAddressPage
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                padding: EdgeInsets.all(45),
                children: [
                  Text(
                    Languages.of(context).waves_address,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                    ),
                  ),
                  SizeArah(6, 0),
                  TextField(
                    style: GoogleFonts.lato(fontSize: 18),
                    controller: _addressKeyController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xffBCBCBC)))),
                  ),
                  SizeArah(35, 0),
                  Text(
                    Languages.of(context).waves_public_key,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                    ),
                  ),
                  SizeArah(6, 0),
                  TextField(
                    controller: _publicKeyController,
                    style: GoogleFonts.lato(fontSize: 18),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffBCBCBC))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xffBCBCBC)))),
                  ),
                  SizeArah(80, 0),
                  click
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                padding: EdgeInsets.all(20),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (_addressKeyController.text.isNotEmpty &&
                                      _publicKeyController.text.isNotEmpty) {
                                    getAddressPublicKey();
                                    setState(() {
                                      click = true;
                                    });
                                  } else {
                                    showToast(
                                        Languages.of(context).enter_details);
                                  }
                                },
                                color: color_primary,
                                textColor: arah_white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                child: Text(
                                  Languages.of(context).save,
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            )
          : Container(
              child: ListView(
                children: [
                  Container(
                    color: Color(0xff00CC99),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: InkWell(
                                onTap: () {
                                  openExchangeApp();
                                },
                                child: Image.asset(
                                  'assets/arah/exchange.png',
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/arah/transaction1x.png',
                          width: 100,
                          height: 100,
                        ),
                        Text(getFormattedAmount(balance) + " units",
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              user.address_key != null ? user.address_key : "",
                              style: GoogleFonts.lato(color: Colors.white)),
                        ),
                        // Text("1 unit = " + price,
                        //     style: GoogleFonts.lato(
                        //         color: Colors.white, fontSize: 25)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Languages.of(context).TRANSACTIONS,
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              color: color_light_grey,
                              fontWeight: FontWeight.w600),
                        ),
                        SizeArah(10, 0),
                        Divider(
                          height: 3,
                          color: Color(0xffBCBCBC),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<List<Transaction>>(
                            future: post,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Transaction> lst = snapshot.data;
                                if (lst.isEmpty) {
                                  return Center(
                                      child: Text(
                                    Languages.of(context).No_Transactions_found,
                                    style: GoogleFonts.lato(fontSize: 18),
                                  ));
                                } else {
                                  return Column(
                                    children: getRows(lst),
                                  );
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  getRows(List<Transaction> transactions) {
    List<Widget> lst = [];
    for (int i = 0; i < transactions.length; i++) {
      if (i > 0) lst.add(divider());
      lst.add(Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    transactions[i].description,
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  getDateInDDMMMYYYYHHSS(transactions[i].wave_timestamp),
                  style:
                      GoogleFonts.lato(fontSize: 12, color: Color(0xff818181)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                transactions[i].operation == "+"
                    ? Container()
                    : Text(transactions[i].operation,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                        )),
                Text(
                  getFormattedAmount(transactions[i].quantity_of_coins),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      color: transactions[i].operation == "+"
                          ? Color(0xff00CC99)
                          : Color(0xff000000)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ));
    }
    return lst;
  }

  Future<void> openExchangeApp() async {
    String url =
        "https://play.google.com/store/apps/details?id=com.wavesplatform.wallet&hl=en&gl=US";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getAddressPublicKey() async {
    CallApi api = CallApi();
    var data = {
      'token': await api.getToken(),
      'address_key': _addressKeyController.text.toString(),
      'public_key': _publicKeyController.text.toString(),
    };

    var res = await api.postData(data, 'set-address-public-key', context);
    var body = json.decode(res.body);

    if (body['success'] != null && body['success']) {
      setState(() {
        click = false;
        showAddressPage = false;
      });
    } else {
      if (body['message'] != null)
        showToast(body['message']);
      else
        showToast(Languages.of(context).error_occurred);
      setState(() {
        click = false;
      });
    }
  }
}

typedef void OnPublicKeyAdded();
