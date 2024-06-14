import 'package:arah_app/language/languages.dart';
import 'package:arah_app/login/lang_options.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewOptions extends StatefulWidget {
  final bool peoplePage;
  final OptionSelected callback;

  NewOptions(this.peoplePage, this.callback);

  @override
  State<StatefulWidget> createState() => NewOptionsState();
}

class NewOptionsState extends State<NewOptions> {
  List<String> lst = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lst.clear();
    lst.add(Languages.of(context).New_Chat);
    lst.add(Languages.of(context).New_Group);
    lst.add(Languages.of(context).New_Community);
    // lst.add(Languages.of(context).Archieved);
    // if (widget.peoplePage) {
    //   lst.add(Languages.of(context).Add_Contact);
    //   lst.add(Languages.of(context).Contacts_Sync);
    // }
    return GestureDetector(
      onTap: () {
        widget.callback.call(-1);
      },
      child: Container(
        color: Colors.transparent,
        height: getScreenHeight(context),
        width: getScreenWidth(context),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Wrap(
              children: [
                Container(
                  width: 170,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: color_shadow, spreadRadius: 0.3),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.centerStart,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: lst.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          widget.callback.call(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            lst[index],
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 2, 8.0, 2),
                        child: Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.black45,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
