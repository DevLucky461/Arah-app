import 'package:arah_app/language/languages.dart';
import 'package:arah_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LangOptions extends StatefulWidget {
  LangOptions(this.callback);

  OptionSelected callback;

  @override
  State<StatefulWidget> createState() => OptionsState();
}

class OptionsState extends State<LangOptions> {
  List<String> lst = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lst.clear();
    lst.add(Languages.of(context).english);
    lst.add(Languages.of(context).indonesian);
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
                  width: 115,
                  color: Colors.black87,
                  alignment: AlignmentDirectional.center,
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
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            lst[index],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 2, 8.0, 2),
                        child: Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.white24,
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

typedef void OptionSelected(int index);
