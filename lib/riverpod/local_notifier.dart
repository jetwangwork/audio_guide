import 'dart:ui';

import 'package:audio_guide/models/lang_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/shared_pref.dart';

final localNotifier = NotifierProvider<LocalNotifier, LangModel>(() {
  return LocalNotifier();
});

class LocalNotifier extends Notifier<LangModel> {

  LangModel get currentLang => state;
  List<LangModel> get supportedLangList => List.of(_langList);

  final List<LangModel> _langList = [
    LangModel(LangTag.tw, '繁體中文', 'zh-tw', Locale('zh', 'TW')),
    LangModel(LangTag.cn, '简体中文', 'zh-cn', Locale('zh', 'CN')),
    LangModel(LangTag.en, 'English', 'en', Locale('en')),
    LangModel(LangTag.jp, '日本語', 'ja', Locale('ja')),
    LangModel(LangTag.kr, '한국어', 'ko', Locale('ko')),
  ];

  @override
  LangModel build() {
    return _loadLang();
  }

  // 讀取語言設定
  LangModel _loadLang() {
    final String languageTagName = SharedPref().getValue(
        SharedPrefKeys.languageTagName,
        _langList[0].tag.name
    ) as String;

    for (final item in _langList) {
      if (item.tag.name == languageTagName) {
        return item;
      }
    }

    return _langList[0];
  }

  // 設定語言並保存
  Future<void> setLang(LangTag langTag) async {
    for (final item in _langList) {
      if (item.tag == langTag) {
        state = item;
        await SharedPref().setValue(SharedPrefKeys.languageTagName, item.tag.name);
      }
    }
  }
}