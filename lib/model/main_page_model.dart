import 'package:flutter/material.dart';
import 'package:todo_list/config/api_service.dart';
import 'package:todo_list/json/task_bean.dart';
import 'package:todo_list/logic/all_logic.dart';

import 'global_model.dart';

class MainPageModel extends ChangeNotifier {
  late MainPageLogic logic;
  BuildContext? context;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<TaskBean> tasks = [];

  ///当前滑动的卡片位置
  int currentCardIndex = 0;

  ///当前点击进入详情页的index，方便在详情页里面操作删除、更新等
  int currentTapIndex = 0;

  ///当前头像的类型
  int currentAvatarType = CurrentAvatarType.defaultAvatar;

  ///当前的头像url,比如本地的就是本地路径，网络就是网络地址
  String currentAvatarUrl = "images/icon.png";

  ///当前的用户名
  String currentUserName = "";

  ///当前正在编辑中的用户名
  String currentEditingUserName = "";

  ///是否开启天气
  bool enableWeatherShow = false;

  ///当前位置信息
  String currentPosition = "";

  ///是否需要与云端同步信息
  bool needSyn = true;

  ///当前卡片背景透明度
  double currentTransparency = 1.0;

  ///是否开启任务详情界面背景透明
  bool enableTaskPageOpacity = false;

  ///用于在透明模式下，打开任务卡片时，隐藏头像等内容
  bool canHideWidget = false;

  CancelToken cancelToken = CancelToken();

  ///用于在mainPage销毁后将GlobalModel中的mainPageModel销毁
  late GlobalModel _globalModel;

  MainPageModel({required this.context}) {
    // debugPrint('MainPage Model build');
    logic = MainPageLogic(this);
    this.context = context;
    // setContext(context, globalModel: globalModel)
  }

  initState() {
    // logic.initState();
  }

  void setContext(BuildContext context, {required GlobalModel globalModel}) {
    if (this.context != null) return;
    this.context = context;
    this._globalModel = globalModel;
    logic.getAvatarType().then((value) {
      Future.wait(
        [
          logic.getTasks(),
          logic.getCurrentAvatar(),
          logic.getCurrentUserName(),
          logic.getCurrentTransparency(),
          logic.getEnableCardPageOpacity(),
        ],
      ).then((value) {
        refresh();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    // _globalModel.mainPageModel = null;
    debugPrint("MainPageModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}

class CurrentAvatarType {
  static const int defaultAvatar = 0;
  static const int local = 1;
  static const int net = 2;
}
