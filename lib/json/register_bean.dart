class RegisterBean {
  late String description;
  late String token;
  late String avatarUrl;
  late int status;

  static RegisterBean fromMap(Map<String, dynamic> map) {
    RegisterBean diaryBase = new RegisterBean();
    diaryBase.description = map['description'];
    diaryBase.token = map['token'];
    diaryBase.avatarUrl = map['avatarUrl'];
    diaryBase.status = map['status'];
    return diaryBase;
  }

  static List<RegisterBean> fromMapList(dynamic mapList) {
    List<RegisterBean> list = List.filled(mapList.length, RegisterBean());
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
