import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list/config/api_service.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/model/all_model.dart';
import 'package:todo_list/pages/main/avatar_history_page.dart';
import 'package:todo_list/utils/file_util.dart';
import 'package:todo_list/utils/permission_request_util.dart';
import 'package:todo_list/utils/shared_util.dart';
import 'package:todo_list/widgets/net_loading_widget.dart';

class AvatarPageLogic {
  final AvatarPageModel _model;

  AvatarPageLogic(this._model);

  //头像设置
  void onAvatarSelect(AvatarType type, BuildContext context) {
    switch (type) {
      case AvatarType.local:
        PermissionReqUtil.getInstance().requestPermission(
          Permission.photos,
          granted: getImage,
          deniedDes: IntlLocalizations.of(context)!.deniedDes,
          context: context,
          openSetting: IntlLocalizations.of(context)!.openSystemSetting,
        );
        break;
      case AvatarType.history:
        Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
          return AvatarHistoryPage(
            currentAvatarUrl: _model.mainPageModel.currentAvatarUrl,
            avatarPageModel: _model,
          );
        }));
        break;
    }
  }

  Future getImage() async {
    final context = _model.context;

    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (Platform.isAndroid) {
        PermissionReqUtil.getInstance().requestPermission(
          Permission.photos,
          granted: () {
            _saveAndGetAvatarFile(image);
          },
          deniedDes: IntlLocalizations.of(context)!.deniedDes,
          context: context,
          openSetting: IntlLocalizations.of(context)!.openSystemSetting,
        );
        return;
      }
      _saveAndGetAvatarFile(image);
    }
  }

  void _saveAndGetAvatarFile(XFile file) async {
    _model.currentAvatarType = CurrentAvatarType.local;
    _model.currentAvatarUrl = file.path;
    _model.refresh();
  }

  void onSaveTap() async {
    final croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: _model.currentAvatarUrl,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    await _saveImage(File(croppedFile?.path ?? _model.currentAvatarUrl));
  }

  Future _saveImage(File file) async {
    String newPath = await FileUtil.getInstance().getSavePath('/avatar/');
    String name = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    File newFile = file.copySync(newPath + name);
    if (newFile.existsSync()) {
      final account = await SharedUtil.instance.getString(Keys.account);
      if (account == "default" || account == null) {
        await _saveImageData(newFile.path);
      } else {
        final token = await SharedUtil.instance.getString(Keys.token);
        final path = newFile.path;
        String fileName = path
            .substring(path.lastIndexOf("/") + 1, path.length)
            .replaceAll(" ", "");
        String transFormName = Uri.encodeFull(fileName).replaceAll("%", "");

        uploadAvatar(account, token ?? 'None Token', path, transFormName);
      }
    }
  }

  Future _saveImageData(String filePath) async {
    await SharedUtil.instance.saveString(Keys.localAvatarPath, filePath);
    await SharedUtil.instance
        .saveInt(Keys.currentAvatarType, CurrentAvatarType.local);
    _model.mainPageModel.currentAvatarType = CurrentAvatarType.local;
    _model.mainPageModel.currentAvatarUrl = filePath;
    _model.mainPageModel.refresh();
    Navigator.of(_model.context).pop();
  }

  void uploadAvatar(
      String account, String token, String filePath, String fileName) async {
    final context = _model.context;
    _showLoadingDialog(context);
    ApiService.instance.uploadAvatar(
      params: FormData.fromMap({
        "avatar": await MultipartFile.fromFile(filePath),
        "account": account,
        "token": token
      }),
      success: (UploadAvatarBean bean) {
        Navigator.pop(context);
        _saveImageData(filePath);
      },
      failed: (UploadAvatarBean bean) {
        Navigator.pop(context);
        _showTextDialog(bean.description);
      },
      error: (msg) {
        Navigator.pop(context);
        _showTextDialog(msg);
      },
      token: _model.cancelToken,
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return NetLoadingWidget(
            key: GlobalKey(),
          );
        });
  }

  void _showTextDialog(String text) {
    final context = _model.context;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Text(text),
          );
        });
  }

  ImageProvider getAvatarProvider() {
    final avatarType = _model.currentAvatarType;
    final url = _model.currentAvatarUrl;
    switch (avatarType) {
      case CurrentAvatarType.defaultAvatar:
        return AssetImage("images/icon.png");
        break;
      case CurrentAvatarType.local:
        File file = File(url);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          return AssetImage("images/icon.png");
        }
        break;
      case CurrentAvatarType.net:
        return NetworkImage(url);
        break;
    }
    return AssetImage("images/icon.png");
  }
}
