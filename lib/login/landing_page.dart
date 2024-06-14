import 'package:arah_app/chat/chat_page.dart';
import 'package:arah_app/compass/compass_page.dart';
import 'package:arah_app/language/languages.dart';
import 'package:arah_app/profile_me/edit_profile.dart';
import 'package:arah_app/utils/common.dart';
import 'package:arah_app/wallet/wallet_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  bool unreadExist = false;
  int selectedPage = 0;
  PageController _pageController = PageController(initialPage: 0, keepPage: true);

  Future<void> setUnreadState(bool state) async {
    setState(() {
      unreadExist = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: getScreenHeight(context),
        child: Column(
          children: [
            Container(
              height: getScreenHeight(context) - 80,
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return getPage(index);
                },
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                reverse: false,
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
              ),
            ),
            Container(
              child: Container(
                height: 80,
                width: getScreenWidth(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color_nav_start, color_nav_end],
                  ),
                  border: Border(
                    top: BorderSide(width: 1.0, color: color_nav_border),
                  ),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getBottomNavItem(Languages.of(context).Chat, 'assets/navigation/Chat', 0),
                        getBottomNavItem(Languages.of(context).Quran, 'assets/navigation/Quran', 1),
                        getBottomNavItem(
                            Languages.of(context).Wallet, 'assets/navigation/Wallet', 2),
                        getBottomNavItem(
                            Languages.of(context).Account, 'assets/navigation/Account', 3)
                        // getBottomNavItem('Media', 'assets/navigation/media', 2),
                        // getBottomNavItem(Languages.of(context).Hall, 'assets/navigation/hall', 3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBottomNavItem(String text, String assetBasePath, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPage = index;
          _pageController.jumpToPage(index);
          // _pageController.animateToPage(index,
          //     duration: Duration(milliseconds: 100), curve: Curves.easeIn);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(3, 3, 3, 0),
                child: Image.asset(
                  index == selectedPage ? assetBasePath + "_Selected.png" : assetBasePath + ".png",
                  height: 25,
                  width: 25,
                ),
              ),
              index == 0 && unreadExist
                  ? Positioned(
                      top: 0, right: 0, child: Icon(Icons.circle, size: 12, color: Colors.red))
                  : SizedBox(),
            ],
          ),
          SizeArah(5, 0),
          getBottomBarText(text, index == selectedPage),
        ],
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return ChatMainBody(this);
        break;

      case 1:
        return CompassPage();
        break;

      case 2:
        return WalletPage();
        break;

      case 3:
        return EditProfile();
        break;

      // case 2:
      //   return Media();
      //   break;
      //
      // case 3:
      //   return Hall();
      //   break;
    }
  }
}
