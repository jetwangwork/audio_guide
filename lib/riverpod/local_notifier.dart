import 'dart:ui';

import 'package:audio_guide/constants.dart';
import 'package:audio_guide/models/lang_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
import '../utils/shared_pref.dart';

final localNotifier = NotifierProvider<LocalNotifier, LangModel>(() {
  return LocalNotifier();
});

class LocalNotifier extends Notifier<LangModel> {

  LangModel get currentLang => state;

  @override
  LangModel build() {
    return _getLang();
  }

  // 讀取語言設定
  LangModel _getLang() {
    final String languageText = SharedPref().getValue(
        SharedPrefKeys.languageText,
        _getLangText(S.delegate.supportedLocales.first)
    ) as String;

    for (final item in AppConstants.langList) {
      if (_getLangText(item.locale) == languageText) {
        return item;
      }
    }

    return AppConstants.langList[0];
  }

  // 設定語言並保存
  Future<void> setLang(LangTag langTag) async {
    for (final item in AppConstants.langList) {
      if (item.tag == langTag) {
        state = item;
        await SharedPref().setValue(SharedPrefKeys.languageText, _getLangText(item.locale));
      }
    }
  }

  String getCurrentLangText() {
    return _getLangText(state.locale);
  }

  String _getLangText(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}-${locale.countryCode}'.toLowerCase();
    } else {
      return locale.languageCode.toLowerCase();
    }
  }
}