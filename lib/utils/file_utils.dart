import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._internal();

  static Future<String> getAudioFilePath(String apiText, int audioId) async {
    final fileName = FileUtils.getAudioFileName(apiText, audioId);
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${fileName}';
  }

  static String getAudioFileName(String apiText, int audioId) {
    return '${apiText}-${audioId}.mp3';
  }
}