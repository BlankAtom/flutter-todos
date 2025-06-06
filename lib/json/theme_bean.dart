import 'package:todo_list/json/color_bean.dart';

export 'package:todo_list/json/color_bean.dart';

class ThemeBean {
  late String? themeName;
  late ColorBean? colorBean;
  late String? themeType;

  ThemeBean({this.themeName, this.colorBean, this.themeType});

  static ThemeBean fromMap(Map<String, dynamic> map) {
    ThemeBean bean = new ThemeBean();
    bean.themeName = map['themeName'];
    bean.colorBean = ColorBean.fromMap(map['colorBean']);
    bean.themeType = map['themeType'];
    return bean;
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'themeName': themeName,
      'colorBean': colorBean?.toMap(),
      'themeType': themeType
    };
  }

  @override
  bool operator ==(other) {
    return (other as ThemeBean).themeName == themeName;
  }
}
