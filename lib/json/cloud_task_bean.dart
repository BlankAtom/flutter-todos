import 'package:todo_list/json/task_bean.dart';

class CloudTaskBean {
  /*
   * description : "获取日记列表成功"
   * status : 0
   * taskList : [{"id":16,"taskName":"123123123","taskType":"运动","account":"772565130@qq.com","taskStatus":"0","taskDetailNum":"1","uniqueId":"772565130@qq.com1566799964054","overallProgress":"1.0","changeTimes":"1","createDate":"2019-08-26 14:12:44 下午","finishDate":"2019-08-22T15:57:09.985443","startDate":null,"deadLine":null,"taskIconBean":{"taskName":"运动","iconBean":{"codePoint":58726,"fontFamily":"MaterialIcons","fontPackage":"","iconName":"","matchTextDirection":"false"},"colorBean":{"red":151,"green":215,"blue":178,"opacity":1}},"detailList":[{"taskDetailName":"123123123","itemProgress":1}]}]
   */

  String description = '';
  int status = 0;
  List<TaskBean> taskList = List.empty();

  static CloudTaskBean fromMap(Map<String, dynamic> map) {
    CloudTaskBean cloudTaskBean = new CloudTaskBean();
    cloudTaskBean.description = map['description'];
    cloudTaskBean.status = map['status'];
    cloudTaskBean.taskList = TaskBean.fromNetMapList(map['taskList']);
    return cloudTaskBean;
  }

  static List<CloudTaskBean> fromMapList(dynamic mapList) {
    List<CloudTaskBean> list =
        List.filled(mapList.length, CloudTaskBean(), growable: true);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
