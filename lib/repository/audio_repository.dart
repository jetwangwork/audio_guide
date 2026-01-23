import 'package:audio_guide/api/api_service.dart';
import 'package:audio_guide/models/audio_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_result.dart';

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AudioRepository._internal(api);
});

class AudioRepository {
  AudioRepository._internal(this._api);

  final ApiService _api;

  Future<ApiResult<AudioListModel>> getAudioList(int page) async {
    final result = await _api.getAudioList(page);
    switch (result) {
      case ApiSuccess(data: final response):
        return ApiSuccess(AudioListModel.fromJson(response.data));
      case ApiError(message: final msg):
        return ApiError(msg);
    }
  }

  Future<ApiResult<String>> downloadAudio(String url, String fileName) async {
    final result = await _api.downloadAudio(url, fileName, (received, total) {
      if (total > 0) {
        final progress = received / total;
        debugPrint('progress: $progress');
      }
    });

    switch (result) {
      case ApiSuccess(data: final file):
        debugPrint('下載完成：${file.path}');
        return ApiSuccess(file.path);
      case ApiError(message: final msg):
        debugPrint('下載失敗：$msg');
        return ApiError(msg);
    }
  }
}
