import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/config/all_types.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/model/account_page_model.dart';
import 'package:todo_list/widgets/custom_cache_image.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final primaryColorLight = Theme.of(context).primaryColorLight;
    final size = MediaQuery.of(context).size;

    final model = Provider.of<AccountPageModel>(context)..setContext(context);

    return WillPopScope(
      onWillPop: () {
        model.isExisting = true;
        model.refresh();
        return Future.value(true);
      },
      child: Stack(
        children: <Widget>[
          Container(
              width: size.width,
              height: size.height,
              child: model.backgroundType == AccountBGType.defaultType
                  ? SvgPicture.asset(
                      "svgs/bg.svg",
                      fit: BoxFit.cover,
                    )
                  : CustomCacheImage(
                      url: model.backgroundUrl,
                      key: GlobalKey(),
                    )),
          model.isExisting
              ? Container()
              : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    width: size.width,
                    height: size.height,
                    color: primaryColor.withOpacity(0.1),
                  ),
                ),
          GestureDetector(
            onTap: model.logic.onBackgroundTap,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(IntlLocalizations.of(context).myAccount),
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                margin: EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          child: model.logic.getAvatar(primaryColor),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        model.userName ?? "null",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w100),
                      ),
                      Text(
                        model.emailAccount ?? "null",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: model.logic.onLogoutPressed,
                        child: Text(IntlLocalizations.of(context).logout),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: model.logic.onResetPasswordPressed,
                        child:
                            Text(IntlLocalizations.of(context).resetPassword),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
