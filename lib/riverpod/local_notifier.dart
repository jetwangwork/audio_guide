import 'package:audio_guide/constants.dart';
import 'package:audio_guide/models/lang_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/shared_pref.dart';

final localNotifier = NotifierProvider<LocalNotifier, LangModel>(() {
  return LocalNotifier();
});

class LocalNotifier extends Notifier<LangModel> {

  LangModel get currentLang => state;
  final List<LangModel> _supportedLangList = AppConstants.supportedLangList;

  @override
  LangModel build() {
    return _loadLang();
  }

  // 讀取語言設定
  LangModel _loadLang() {
    final String languageTagName = SharedPref().getValue(
        SharedPrefKeys.languageTagName,
        _supportedLangList[0].tag.name
    ) as String;

    for (final item in _supportedLangList) {
      if (item.tag.name == languageTagName) {
        return item;
      }
    }

    return _supportedLangList[0];
  }

  // 設定語言並保存
  Future<void> setLang(LangTag langTag) async {
    for (final item in _supportedLangList) {
      if (item.tag == langTag) {
        state = item;
        await SharedPref().setValue(SharedPrefKeys.languageTagName, item.tag.name);
      }
    }
  }
}