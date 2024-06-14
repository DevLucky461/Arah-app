import 'dart:ui';

import 'package:arah_app/models/people.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListRowPeople extends StatelessWidget {
  final People chat;

  ListRowPeople(this.chat);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xffC5E2DF),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: chat.image == null || chat.image == ""
                      ? Container()
                      : Image.network(
                          getImage(chat.image),
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
                        chat.name,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70, right: 20),
          child: Container(
            height: 2,
            width: double.infinity,
            color: color_grey_divider,
          ),
        )
      ],
    );
  }
}
