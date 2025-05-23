import 'package:flutter/material.dart';
import 'package:todo_list/config/api_service.dart';
import 'package:todo_list/database/database.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/json/task_bean.dart';
import 'package:todo_list/json/task_icon_bean.dart';
import 'package:todo_list/model/all_model.dart';
import 'package:todo_list/utils/shared_util.dart';
import 'package:todo_list/widgets/custom_icon_widget.dart';
import 'package:todo_list/widgets/net_loading_widget.dart';

class EditTaskPageLogic {
  final EditTaskPageModel _model;

  EditTaskPageLogic(this._model);

  Widget getIconText(
      {required Icon icon, String text = '', VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.withOpacity(0.2)),
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(
              width: 4,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  //提交一项任务
  void submitOneItem() {
    final controller = _model.textEditingController;
    String text = controller.text;
    if (text.isEmpty) return;
    _model.taskDetails.add(TaskDetailBean(taskDetailName: text));
//    WidgetsBinding.instance.addPostFrameCallback( (_) => controller.clear());
    controller.clear();
    _model.refresh();
//    final scroller = _model.scrollController;
//    scroller?.animateTo(scroller?.position?.maxScrollExtent,
//        duration: Duration(milliseconds: 200), curve: Curves.easeInOutSine)?.then((a){
//      controller.text = "";
//    });
  }

  //监测软键盘
  void scrollToEndWhenEdit() {
    //检测软键盘是否弹出
    if (MediaQuery.of(_model.context!).viewInsets.bottom > 100) {
      debugPrint("软键盘弹出}");
      final scroller = _model.scrollController;
      debugPrint(
          "当前:${scroller?.position?.pixels ?? 100}  全:${scroller?.position?.maxScrollExtent ?? 100}");
      scroller.animateTo(scroller.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOutSine);
    } else {
      debugPrint("软键盘收起");
    }
  }

  //监听文字，提交按钮是否可以点击
  void editListener() {
    final text = _model.textEditingController.text;
    if (text.isEmpty && _model.canAddTaskDetail) {
      _model.canAddTaskDetail = false;
      _model.refresh();
    } else if (text.isNotEmpty && !_model.canAddTaskDetail) {
      _model.canAddTaskDetail = true;
      _model.refresh();
    }
  }

  //删除一项任务
  void removeItem(int index) {
    _model.taskDetails.removeAt(index);
    _model.refresh();
  }

  //选择任务结束时间
  void pickEndTime(GlobalModel globalModel) {
    DateTime initialDate = _model.startDate ?? DateTime.now();
    initialDate = initialDate.add(Duration(days: 1));
    DateTime firstDate = initialDate;
    DateTime lastDate = initialDate.add(Duration(days: 365));
    showDP(firstDate, initialDate, lastDate, globalModel.logic.isDarkNow())
        .then(
      (day) {
        if (day == null) return;
        if (_model.startDate != null) {
          if (day.isBefore(_model.startDate!)) {
            showDialog(
                context: _model.context!,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Text(
                        IntlLocalizations.of(_model.context!)!.endBeforeStart),
                  );
                });
            return;
          }
        }
        _model.deadLine = day;
        _model.refresh();
      },
    );
  }

  void pickStartTime(GlobalModel globalModel) {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate.add(Duration(days: 1));
    DateTime lastDate = initialDate.add(Duration(days: 365));
    showDP(firstDate, initialDate, lastDate, globalModel.logic.isDarkNow())
        .then(
      (day) {
        if (day == null) return;
        if (_model.deadLine != null) {
          if (day.isAfter(_model.deadLine!)) {
            showDialog(
                context: _model.context!,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Text(
                        IntlLocalizations.of(_model.context!)!.startAfterEnd),
                  );
                });
            return;
          }
        }
        _model.startDate = day;
        _model.refresh();
      },
    );
  }

  Future<DateTime?> showDP(DateTime firstDate, DateTime initialDate,
      DateTime lastDate, bool isDarkNow) {
    return showDatePicker(
      context: _model.context!,
      initialDate: firstDate,
      firstDate: initialDate,
      lastDate: lastDate,
      builder: (context, child) {
        final color = ColorBean.fromBean(_model.taskIcon!.colorBean!);
        return Theme(
          child: child ?? Container(),
          data: isDarkNow
              ? ThemeData.dark()
              : ThemeData(
                  primaryColor: color,
                  hintColor: color,
                  scaffoldBackgroundColor: Colors.white,
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.accent),
                ),
        );
      },
    );
  }

  //将结束时间做个转换
  String getEndTimeText() {
    if (_model.deadLine != null) {
      final time = _model.deadLine!;
      return "${time.year}-${time.month}-${time.day}";
    }
    return IntlLocalizations.of(_model.context!)!.deadline;
  }

  //将开始时间做转换
  String getStartTimeText() {
    if (_model.startDate != null) {
      final time = _model.startDate!;
      return "${time.year}-${time.month}-${time.day}";
    }
    return IntlLocalizations.of(_model.context!)!.startDate;
  }

  //将DateTime转换为String
  String transformDateToString(DateTime date) {
    return date.toIso8601String();
  }

  //将String转换为DateTime
  DateTime transformStringToDate(String date) {
    return DateTime.parse(date);
  }

  //右上角的提交按钮
  void onSubmitTap() {
    bool isEdit = isEditOldTask();
    isEdit ? submitOldTask() : submitNewTask();
  }

  //创建新的任务
  void submitNewTask() async {
    if (_model.taskDetails.length == 0) {
      showDialog(
          context: _model.context!,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Text(IntlLocalizations.of(_model.context!)!
                  .writeAtLeastOneTaskItem),
            );
          });
      return;
    }
    TaskBean taskBean = await transformDataToBean();
    if (taskBean.account == 'default') {
      await exitWithSubmitNewTask(taskBean);
    } else {
      postCreateTask(taskBean);
    }
  }

  Future exitWithSubmitNewTask(TaskBean taskBean,
      {bool needCancelDialog = false}) async {
    await DBProvider.db.createTask(taskBean);
    await _model.mainPageModel?.logic.getTasks();
    _model.mainPageModel?.refresh();
    Navigator.of(_model.context!).pop();
    if (needCancelDialog) Navigator.of(_model.context!).pop();
  }

  Future exitWhenSubmitOldTask(TaskBean taskBean) async {
    DBProvider.db.updateTask(taskBean);
    await _model.mainPageModel?.logic.getTasks();
    _model.mainPageModel?.refresh();
    if (_model.taskDetailPageModel != null) {
      _model.taskDetailPageModel?.isExiting = true;
      _model.taskDetailPageModel?.refresh();
    }
    Navigator.of(_model.context!).popUntil((route) => route.isFirst);
  }

  //修改旧的任务
  void submitOldTask() async {
    if (_model.taskDetails.length == 0) {
      showDialog(
          context: _model.context!,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Text(IntlLocalizations.of(_model.context!)!
                  .writeAtLeastOneTaskItem),
            );
          });
      return;
    }
    TaskBean taskBean = await transformDataToBean(
        id: _model.oldTaskBean?.id, overallProgress: _getOverallProgress());
    taskBean.changeTimes++;
    if (taskBean.account == 'default') {
      await exitWhenSubmitOldTask(taskBean);
    } else {
      taskBean.uniqueId == null
          ? postCreateTask(taskBean, isSubmitOldTask: true)
          : postUpdateTask(taskBean);
    }
  }

  ///在云端创建一个任务
  void postCreateTask(TaskBean taskBean, {bool isSubmitOldTask = false}) async {
    showDialog(
        context: _model.context!,
        builder: (ctx) {
          return NetLoadingWidget(
            key: GlobalKey(),
          );
        });
    final token = await SharedUtil.instance.getString(Keys.token);
    ApiService.instance.postCreateTask(
      success: (UploadTaskBean bean) {
        taskBean.uniqueId = bean.uniqueId;
        taskBean.needUpdateToCloud = 'false';
        isSubmitOldTask
            ? exitWhenSubmitOldTask(taskBean)
            : exitWithSubmitNewTask(taskBean, needCancelDialog: true);
      },
      failed: (UploadTaskBean bean) {
        taskBean.needUpdateToCloud = 'true';
        _model.mainPageModel?.needSyn = true;
        isSubmitOldTask
            ? exitWhenSubmitOldTask(taskBean)
            : exitWithSubmitNewTask(taskBean, needCancelDialog: true);
      },
      error: (msg) {
        taskBean.needUpdateToCloud = 'true';
        _model.mainPageModel?.needSyn = true;
        isSubmitOldTask
            ? exitWhenSubmitOldTask(taskBean)
            : exitWithSubmitNewTask(taskBean, needCancelDialog: true);
      },
      taskBean: taskBean,
      token: token ?? 'None Token',
      cancelToken: _model.cancelToken,
    );
  }

  ///在云端更新一个任务
  void postUpdateTask(
    TaskBean taskBean,
  ) async {
    showDialog(
        context: _model.context!,
        builder: (ctx) {
          return NetLoadingWidget(
            key: GlobalKey(),
          );
        });
    final token = await SharedUtil.instance.getString(Keys.token);
    ApiService.instance.postUpdateTask(
      success: (CommonBean bean) {
        taskBean.needUpdateToCloud = 'false';
        exitWhenSubmitOldTask(taskBean);
      },
      failed: (CommonBean bean) {
        taskBean.needUpdateToCloud = 'true';
        _model.mainPageModel?.needSyn = true;
        exitWhenSubmitOldTask(taskBean);
      },
      error: (msg) {
        taskBean.needUpdateToCloud = 'true';
        _model.mainPageModel?.needSyn = true;
        exitWhenSubmitOldTask(taskBean);
      },
      taskBean: taskBean,
      token: token ?? 'None Token',
      cancelToken: _model.cancelToken,
    );
  }

  //获取当前任务总进度
  double _getOverallProgress() {
    int length = _model.taskDetails.length;
    double overallProgress = 0.0;
    for (int i = 0; i < length; i++) {
      overallProgress += _model.taskDetails[i].itemProgress / length;
    }
    return overallProgress;
  }

  Future<TaskBean> transformDataToBean(
      {int? id, double overallProgress = 0.0}) async {
    final account =
        await SharedUtil.instance.getString(Keys.account) ?? "default";
    final taskName = _model.currentTaskName.isEmpty
        ? _model.taskIcon?.taskName
        : _model.currentTaskName;
    final createDate = _model?.createDate?.toIso8601String() ??
        DateTime.now().toIso8601String();
    TaskBean taskBean = TaskBean(
      taskName: taskName!,
      account: account,
      taskStatus: _model.oldTaskBean?.taskStatus ?? TaskStatus.todo,
      needUpdateToCloud: _model.oldTaskBean?.needUpdateToCloud ?? 'false',
      uniqueId: _model.uniqueId ?? null,
      taskType: _model.taskIcon!.taskName!,
      taskDetailNum: _model.taskDetails.length,
      createDate: createDate,
      startDate: _model.startDate!.toIso8601String(),
      deadLine: _model.deadLine!.toIso8601String(),
      detailList: _model.taskDetails,
      taskIconBean: _model.taskIcon,
      changeTimes: _model.changeTimes,
      overallProgress: overallProgress,
      backgroundUrl: _model.backgroundUrl,
      textColor: _model.textColorBean,
      finishDate: _model.finishDate!.toIso8601String() ?? "",
    );
    if (id != null) {
      taskBean.id = id;
    }
    return taskBean;
  }

  //用旧任务数据初始化所有数据
  void initialDataFromOld(TaskBean? oldTaskBean) {
    if (oldTaskBean != null) {
      _model.taskDetails.clear();
      _model.taskDetails.addAll(oldTaskBean.detailList!);

      debugPrint(
          'startDate:${oldTaskBean.startDate}, deadLine:${oldTaskBean.deadLine}');
      if (oldTaskBean.deadLine != null && oldTaskBean.deadLine.isNotEmpty)
        _model.deadLine = DateTime.parse(oldTaskBean.deadLine);
      if (oldTaskBean.startDate != null && oldTaskBean.startDate.isNotEmpty)
        _model.startDate = DateTime.parse(oldTaskBean.startDate);
      if (oldTaskBean.createDate != null && oldTaskBean.createDate.isNotEmpty)
        _model.createDate = DateTime.parse(oldTaskBean.createDate);
      if (oldTaskBean.finishDate.isNotEmpty)
        _model.finishDate = DateTime.parse(oldTaskBean.finishDate);
      _model.changeTimes = oldTaskBean.changeTimes ?? 0;
      if (oldTaskBean.taskIconBean != null)
        _model.taskIcon = oldTaskBean.taskIconBean!;
      if (oldTaskBean.taskName != null)
        _model.currentTaskName = oldTaskBean.taskName;
      if (oldTaskBean.backgroundUrl != null)
        _model.backgroundUrl = oldTaskBean.backgroundUrl!;
      if (oldTaskBean.textColor != null)
        _model.textColorBean = oldTaskBean.textColor!;
    }
  }

  ///表示当前是属于创建新的任务还是修改旧的任务
  bool isEditOldTask() {
    return _model.oldTaskBean != null;
  }

  String getHintTitle() {
    bool isEdit = isEditOldTask();
    final context = _model.context!;
    String defaultTitle =
        "${IntlLocalizations.of(context)?.defaultTitle}:${_model.taskIcon?.taskName}";
    String oldTaskTitle = "${_model.oldTaskBean?.taskName ?? ''}";
    return isEdit ? oldTaskTitle : defaultTitle;
  }

  ///将当前item置于顶层
  void moveToTop(int index, List list) {
    final item = list[index];
    list.removeAt(index);
    list.insert(0, item);
    _model.refresh();
  }

  ///编辑任务图标
  void onIconPress(IconBean iconBean, ColorBean colorBean) {
    showDialog(
      barrierDismissible: false,
      context: _model.context!,
      builder: (ctx) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            elevation: 0.0,
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            title: Text(IntlLocalizations.of(_model.context!)!.customIcon),
            content: CustomIconWidget(
              iconData: IconBean.fromBean(iconBean),
              onApplyTap: (Color color) async {
                _model.taskIcon?.colorBean = ColorBean.fromColor(color);
                _model.refresh();
              },
              pickerColor: ColorBean.fromBean(colorBean),
              onTextChange: (text) {
                final name = text.isEmpty
                    ? IntlLocalizations.of(_model.context!)?.defaultIconName
                    : text;
                _model.taskIcon?.iconBean?.iconName = name;
              },
              iconName: iconBean.iconName!,
            ));
      },
    );
  }

  void moveTaskDetail(int oldIndex, int newIndex) {
    var oldDetail = _model.taskDetails.removeAt(oldIndex);
    if (newIndex >= _model.taskDetails.length) {
      _model.taskDetails.add(oldDetail);
    } else {
      _model.taskDetails.insert(newIndex, oldDetail);
    }
    _model.refresh();
  }
}
