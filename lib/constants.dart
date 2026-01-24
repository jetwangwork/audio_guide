import 'dart:ui';

import 'models/lang_model.dart';

class AppConstants {
  static final List<LangModel> langList = [
    LangModel(LangTag.tw, '繁體中文', Locale('zh', 'TW')),
    LangModel(LangTag.cn, '简体中文', Locale('zh', 'CN')),
    LangModel(LangTag.en, 'English', Locale('en')),
    LangModel(LangTag.jp, '日本語', Locale('ja')),
    LangModel(LangTag.kr, '한국어', Locale('ko')),
  ];
}

class ApiConstants {
  static const String baseUrl = 'https://www.travel.taipei/open-api';
}