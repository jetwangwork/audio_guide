import 'dart:ui';

import 'models/lang_model.dart';

class AppConstants {
  static List<LangModel> get supportedLangList => List.of(_langList);
  static const List<LangModel> _langList = const [
    LangModel(LangTag.tw, '繁體中文', 'zh-tw', Locale('zh', 'TW')),
    LangModel(LangTag.cn, '简体中文', 'zh-cn', Locale('zh', 'CN')),
    LangModel(LangTag.en, 'English', 'en', Locale('en')),
    LangModel(LangTag.jp, '日本語', 'ja', Locale('ja')),
    LangModel(LangTag.kr, '한국어', 'ko', Locale('ko')),
  ];
}

class ApiConstants {
  static const String baseUrl = 'https://www.travel.taipei/open-api';
}