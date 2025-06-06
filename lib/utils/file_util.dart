import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/config/api_strategy.dart';

class FileUtil {
  static FileUtil _instance = FileUtil._internal();

  factory FileUtil() {
    return _instance;
  }
  FileUtil._internal();

  static FileUtil getInstance() {
    if (_instance == null) {
      _instance = FileUtil._internal();
    }
    return _instance;
  }

  Future<String> getSavePath(String endPath) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String path = tempDir.path + endPath;
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return path;
  }

  void copyFile(String oldPath, String newPath) {
    File file = File(oldPath);
    if (file.existsSync()) {
      file.copy(newPath);
    }
  }

  Future<List<String>> getDirChildren(String path) async {
    Directory directory = Directory(path);
    final childrenDir = directory.listSync();
    List<String> pathList = [];
    for (var o in childrenDir) {
      final filename = o.path.split("/").last;
      if (filename.contains(".")) {
        pathList.add(o.path);
      }
    }
    return pathList;
  }

  ///[assetPath] 例子 'images/'
  ///[assetName] 例子 '1.jpg'
  ///[filePath] 例子:'/myFile/'
  ///[fileName]  例子 'girl.jpg'
  Future<String> copyAssetToFile(String assetPath, String assetName,
      String filePath, String fileName) async {
    String newPath = await FileUtil.getInstance().getSavePath(filePath);
    String name = fileName;
    bool exists = await new File(newPath + name).exists();
    if (!exists) {
      var data = await rootBundle.load(assetPath + assetName);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(newPath + name).writeAsBytes(bytes);
      return newPath + name;
    } else
      return newPath + name;
  }

  void downloadFile({
    required String url,
    required String filePath,
    required String fileName,
    required Function onComplete,
  }) async {
    final path = await FileUtil.getInstance().getSavePath(filePath);
    String name = fileName ?? url.split("/").last;
    ApiStrategy.getInstance().client.download(
      url,
      path + name,
      onReceiveProgress: (int count, int total) {
        final downloadProgress = ((count / total) * 100).toInt();
        if (downloadProgress == 100) {
          if (onComplete != null) onComplete(path + name);
        }
      },
      options: Options(
        sendTimeout: Duration(milliseconds: 15 * 1000),
        receiveTimeout: Duration(milliseconds: 360 * 1000),
      ),
    );
  }
}
