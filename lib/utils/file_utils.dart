import 'package:audio_guide/utils/shared_pref.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../models/audio_lang_model.dart';

class FileUtils {
  FileUtils._internal();

  static String getAudioLangText() {
    return SharedPref().getValue(SharedPrefKeys.audioLang, AppConstants.audioLangList[0].text) as String;
  }

  static Future<void> setAudioLangText(AudioLangTag audioLangTag) async {
    for (final item in AppConstants.audioLangList) {
      if (item.tag == audioLangTag) {
        await SharedPref().setValue(SharedPrefKeys.audioLang, item.text);
        break;
      }
    }
  }

  static Future<String> getAudioFilePath(int audioId) async {
    final fileName = FileUtils.getAudioFileName(audioId);
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${fileName}';
  }

  static String getAudioFileName(int audioId) {
    return '${getAudioLangText()}-${audioId}.mp3';
  }
}