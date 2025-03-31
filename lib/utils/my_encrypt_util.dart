import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  static EncryptUtil _instance = EncryptUtil._internal();
  factory EncryptUtil() {
    return _instance;
  }

  static EncryptUtil get instance => _getInstance();

  late Encrypter _encrypter;

  EncryptUtil._internal() {
    //初始化
    final theKey = Key.fromUtf8("my 32 length key................");
    _encrypter = Encrypter(AES(theKey));
  }

  final iv = IV.fromLength(16);

  static EncryptUtil _getInstance() {
    if (_instance == null) {
      _instance = new EncryptUtil._internal();
    }
    return _instance;
  }

  String encrypt(String value) {
    if (value.isEmpty) return "";
    return _encrypter.encrypt(value, iv: iv).base64; //被加密后的文字
  }

  String decrypt(String value) {
    if (value.isEmpty) return "";
    return _encrypter.decrypt64(value ?? "", iv: iv);
  }
}
