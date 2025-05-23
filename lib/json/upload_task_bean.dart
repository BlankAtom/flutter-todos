class UploadTaskBean {
  /*
   * description : "任务创建成功"
   * uniqueId : "772565130@qq.com1566790167339"
   * status : 0
   */

  late String description;
  late String uniqueId;
  late int status;

  static UploadTaskBean fromMap(Map<String, dynamic> map) {
    UploadTaskBean uploadTaskBean = new UploadTaskBean();
    uploadTaskBean.description = map['description'];
    uploadTaskBean.uniqueId = map['uniqueId'];
    uploadTaskBean.status = map['status'];
    return uploadTaskBean;
  }

  static List<UploadTaskBean> fromMapList(dynamic mapList) {
    List<UploadTaskBean> list = List.filled(mapList.length, UploadTaskBean());
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  @override
  String toString() {
    return 'UploadTaskBean{description: $description, uniqueId: $uniqueId, status: $status}';
  }
}
