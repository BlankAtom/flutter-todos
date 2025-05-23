class UploadAvatarBean {
  /*
   * description : "头像上传成功"
   * filePath : "files/772565130@qq.com/2019/7/avatar.jpg"
   * status : 0
   */

  late String description;
  late String filePath;
  late int status;

  static UploadAvatarBean fromMap(Map<String, dynamic> map) {
    UploadAvatarBean uploadAvatarBean = new UploadAvatarBean();
    uploadAvatarBean.description = map['description'];
    uploadAvatarBean.filePath = map['filePath'];
    uploadAvatarBean.status = map['status'];
    return uploadAvatarBean;
  }

  static List<UploadAvatarBean> fromMapList(dynamic mapList) {
    List<UploadAvatarBean> list =
        List.filled(mapList.length, UploadAvatarBean());
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
