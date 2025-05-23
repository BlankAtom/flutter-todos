import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/config/api_service.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/model/global_model.dart';
import 'package:todo_list/pages/navigator/settings/about/webview_page.dart';
import 'package:todo_list/widgets/loading_widget.dart';
import 'package:todo_list/widgets/net_loading_widget.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<String> descriptions = [];

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    if (descriptions.isEmpty) {
      descriptions.add(IntlLocalizations.of(context).version112);
      descriptions.add(IntlLocalizations.of(context).version111);
      descriptions.add(IntlLocalizations.of(context).version110);
      descriptions.add(IntlLocalizations.of(context).version109);
      descriptions.add(IntlLocalizations.of(context).version108);
      descriptions.add(IntlLocalizations.of(context).version107);
      descriptions.add(IntlLocalizations.of(context).version106);
      descriptions.add(IntlLocalizations.of(context).version105);
      descriptions.add(IntlLocalizations.of(context).version104);
      descriptions.add(IntlLocalizations.of(context).version103);
      descriptions.add(IntlLocalizations.of(context).version102);
      descriptions.add(IntlLocalizations.of(context).version101);
      descriptions.add(IntlLocalizations.of(context).version100);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlLocalizations.of(context).aboutApp,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        backgroundColor: globalModel.logic.getBgInDark(),
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0.0,
      ),
      body: Container(
        color: globalModel.logic.getBgInDark(),
        child: Container(
          margin: EdgeInsets.all(20),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (ctx) {
                          return WebViewPage(
                            'https://oldchen.top/flutter-blog/#/',
                            title: IntlLocalizations.of(context).myBlog,
                          );
                        }));
                      },
                      child: Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.all(10),
                                child: Image.asset(
                                  "images/icon_2.png",
                                  fit: BoxFit.contain,
                                ))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 2),
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                IntlLocalizations.of(context).appName,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                // Container(
                                //   alignment: Alignment.bottomLeft,
                                //   child: FutureBuilder(
                                //       future: PackageInfo.fromPlatform(),
                                //       builder: (context, snapshot) {
                                //         if (snapshot.hasData) {
                                //           PackageInfo? packageInfo =
                                //               snapshot.data;
                                //           return Text(
                                //             packageInfo?.version ?? 'NULL',
                                //             style: TextStyle(
                                //                 fontSize: 20,
                                //                 color: Theme.of(context)
                                //                             .primaryColor ==
                                //                         Color(0xff212121)
                                //                     ? Colors.white
                                //                     : Color.fromRGBO(
                                //                         141, 141, 141, 1.0)),
                                //           );
                                //         } else
                                //           return Container();
                                //       }),
                                // ),
                                SizedBox(
                                  width: 30,
                                ),
                                Platform.isAndroid
                                    ? GestureDetector(
                                        child: Icon(
                                          Icons.cloud_upload,
                                        ),
                                        onTap: () => checkUpdate(globalModel),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Container(
                        margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowIndicator();
                            return true;
                          },
                          child: ListView(
                              children: List.generate(descriptions.length + 1,
                                  (index) {
                            if (index == 0) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      IntlLocalizations.of(context)
                                          .versionDescription,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "✨${IntlLocalizations.of(context).projectLink}✨",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new CupertinoPageRoute(
                                                builder: (ctx) {
                                          return WebViewPage(
                                            "https://github.com/asjqkkkk/todo-list-app",
                                            title: IntlLocalizations.of(context)
                                                .myGithub,
                                          );
                                        }));
                                      },
                                    )
                                  ],
                                ),
                              );
                            } else {
                              final data = descriptions[index - 1];

                              return Container(
                                margin: EdgeInsets.only(right: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromRGBO(141, 141, 141, 1.0),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(child: SelectableText(data)),
                                  ],
                                ),
                              );
                            }
                          })),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkUpdate(GlobalModel globalModel) {
    final loadingController = globalModel.loadingController;

    showDialog(
        context: context,
        builder: (ctx) {
          CancelToken cancelToken = CancelToken();
          return NetLoadingWidget(
            loadingController: loadingController,
            successText: IntlLocalizations.of(context).noUpdate,
            onSuccess: () {
              Navigator.pop(context);
            },
            onRequest: () {
              ApiService.instance.checkUpdate(
                success: (UpdateInfoBean updateInfo) async {
                  // final packageInfo = await PackageInfo.fromPlatform();
                  // bool needUpdate = UpdateInfoBean.needUpdate(
                  //     packageInfo.version, updateInfo.appVersion);
                  // if (needUpdate) {
                  //   Navigator.of(context).pop();
                  //   showDialog(
                  //       context: context,
                  //       builder: (ctx2) {
                  //         return UpdateDialog(
                  //           version: updateInfo.appVersion,
                  //           updateUrl: updateInfo.downloadUrl,
                  //           updateInfo: updateInfo.updateInfo,
                  //           updateInfoColor: globalModel.logic.getBgInDark(),
                  //           backgroundColor:
                  //               globalModel.logic.getPrimaryGreyInDark(context),
                  //         );
                  //       });
                  // }
                  loadingController.setFlag(LoadingFlag.success);
                },
                error: (msg) {
                  loadingController.setFlag(LoadingFlag.error);
                },
                params: {
                  "language": globalModel.currentLocale?.languageCode ?? 'None',
                  "appId": "001"
                },
                token: cancelToken,
              );
            },
            cancelToken: cancelToken,
            key: GlobalKey(),
          );
        });
  }
}
