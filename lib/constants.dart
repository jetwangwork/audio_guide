import 'models/audio_lang_model.dart';

class AppConstants {
  static final List<AudioLangModel> audioLangList = [
    AudioLangModel(AudioLangTag.tw, 'zh-tw'),
    AudioLangModel(AudioLangTag.cn, 'zh-cn'),
    AudioLangModel(AudioLangTag.en, 'en'),
    AudioLangModel(AudioLangTag.jp, 'ja'),
    AudioLangModel(AudioLangTag.kr, 'ko'),
  ];
}

class ApiConstants {
  static const String baseUrl = 'https://www.travel.taipei/open-api';
}