import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._internal();

  static Future<String> getAudioFilePath(String langText, int audioId) async {
    final fileName = FileUtils.getAudioFileName(langText, audioId);
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${fileName}';
  }

  static String getAudioFileName(String langText, int audioId) {
    return '${langText}-${audioId}.mp3';
  }
}