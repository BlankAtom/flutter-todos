import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/i10n/localization_intl.dart';

import 'loading_widget.dart';

class NetLoadingWidget extends StatefulWidget {
  final LoadingController? loadingController;
  final Widget? successWidget;
  final String? loadingText;
  final String? errorText;
  final String? successText;
  final String? emptyText;
  final String? idleText;
  final VoidCallback? onRequest;
  final VoidCallback? onSuccess;
  final CancelToken? cancelToken;

  const NetLoadingWidget({
    required Key key,
    this.loadingController,
    this.successWidget,
    this.loadingText,
    this.errorText,
    this.successText,
    this.emptyText,
    this.idleText,
    this.onRequest,
    this.cancelToken,
    this.onSuccess,
  }) : super(key: key);

  @override
  _NetLoadingWidgetState createState() => _NetLoadingWidgetState();
}

class _NetLoadingWidgetState extends State<NetLoadingWidget> {
  LoadingFlag loadingFlag = LoadingFlag.loading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: Container(
            width: size.width / 3 * 2,
            height: size.height / 3,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: LoadingWidget(
                flag: loadingFlag,
                loadingText: getLoadingText(),
                successWidget: Container(
                  margin: EdgeInsets.all(10),
                  child: widget.successWidget ??
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                widget.successText ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              overlayColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Theme.of(context).primaryColorLight;
                                }
                                return null;
                              }),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            onPressed: widget.onSuccess ?? () {},
                            child: Text(IntlLocalizations.of(context).ok),
                          )
                        ],
                      ),
                ),
                errorCallBack: widget.onRequest ?? () {},
                errorText: getLoadingText(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget?.loadingController?._setState(this);
    if (widget.onRequest != null) {
      widget.onRequest!();
    }
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget?.cancelToken?.cancel();
    super.dispose();
  }

  String getLoadingText() {
    switch (loadingFlag) {
      case LoadingFlag.loading:
        return widget.loadingText ?? IntlLocalizations.of(context).waitAMoment;
        break;
      case LoadingFlag.error:
        return widget.errorText ?? IntlLocalizations.of(context).submitAgain;
        break;
      case LoadingFlag.success:
        return widget.successText ??
            IntlLocalizations.of(context).submitSuccess;
        break;
      case LoadingFlag.empty:
        return widget.emptyText ?? "";
        break;
      case LoadingFlag.idle:
        return widget.idleText ?? "";
        break;
    }
    return "";
  }
}

//这里面的state没有去执行dispose，不知道会不会内存泄漏
class LoadingController {
  late _NetLoadingWidgetState _state;
  LoadingFlag _flag = LoadingFlag.loading;

  void setFlag(LoadingFlag loadingFlag) {
    _state?.loadingFlag = loadingFlag;
    _flag = loadingFlag;
    _state?.refresh();
    print("设置:${_state?.loadingFlag}");
  }

  void _setState(_NetLoadingWidgetState state) {
    this._state = state;
    print("设置了:${this._state}");
  }

  LoadingFlag get flag => _flag;
}
