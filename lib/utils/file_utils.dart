import 'package:path_provider/path_provider.dart';

import '../constants.dart';

class FileUtils {
  FileUtils._internal();

  static Future<String> getAudioFilePath(int audioId) async {
    final fileName = FileUtils.getAudioFileName(audioId);
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${fileName}';
  }

  static String getAudioFileName(int audioId) {
    return '${ApiConstants.defaultAudioLang}-${audioId}.mp3';
  }
}