import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/chat_msg.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ListRow extends StatelessWidget {
  final ChatMsg chat;

  ListRow(this.chat);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: new GlobalKey(),
      color: chat.selected ? Color(0xffC5E2DF) : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: chat.image == null || chat.image == ""
                            ? Image.asset('assets/arah/Icon-Avatar.png')
                            : Image.network(
                                getImage(chat.image),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    new Positioned(
                      top: 45,
                      left: 45,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: true
                            ? Color(0xFF66d046)
                            : (false ? Color(0xFFffb400) : Color(0xFFacacac)),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: getScreenWidth(context) - 170,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name == null ? "" : chat.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        chat.last_message_type == 'image'
                            ? Row(children: [
                                Icon(Icons.image, color: Colors.grey),
                                Text(
                                  Languages.of(context).image,
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),
                              ])
                            : Text(
                                chat.last_message_type == 'notification'
                                    ? chat.last_message +
                                        Languages.of(context).joined_grp
                                    : (chat.last_msg_sender_id != user.id
                                        ? chat.last_msg_sender_name +
                                            " :" +
                                            chat.last_message
                                        : chat.last_message),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87),
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getDateTimeFromGMT(context, chat.last_received),
                          style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        SizeArah(5),
                        chat.unread > 0
                            ? CircleAvatar(
                                radius: 10,
                                backgroundColor: color_primary,
                                child: Text(
                                  chat.unread.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 15,
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 85, right: 20),
            child: Container(
              height: 2,
              width: double.infinity,
              color: color_grey_divider,
            ),
          )
        ],
      ),
    );
  }
}
