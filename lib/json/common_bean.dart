class CommonBean {
  String description = '';
  int status = 0;

  static CommonBean fromMap(Map<String, dynamic> map) {
    CommonBean commonBean = new CommonBean();
    commonBean.description = map['description'];
    commonBean.status = map['status'];
    return commonBean;
  }

  static List<CommonBean> fromMapList(dynamic mapList) {
    List<CommonBean> list = List.filled(mapList.length, CommonBean());
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
