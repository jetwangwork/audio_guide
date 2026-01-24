import 'dart:io';

import 'package:audio_guide/api/api_service.dart';
import 'package:audio_guide/models/api/audio_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_result.dart';
import '../riverpod/local_notifier.dart';
import '../screen/home/models/audio_item_model.dart';
import '../utils/file_utils.dart';

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  final notifier = ref.read(localNotifier.notifier);
  return AudioRepository._internal(api, notifier);
});

class AudioRepository {
  AudioRepository._internal(this._api, this._localNotifier);

  final ApiService _api;
  final LocalNotifier _localNotifier;

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
    final result = await _api.downloadAudio(url, fileName, onProgress: (received, total) {
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

  Future<List<AudioItemModel>> checkLocalFiles(List<AudioModel> audioModelList) async {
    return await Future.wait(audioModelList.map((e) async {
      final filePath = await FileUtils.getAudioFilePath(_localNotifier.currentLang.apiText, e.id);
      final file = File(filePath);
      final exists = await file.exists();
      return AudioItemModel(id: e.id, title: e.title, url: e.url, status: exists ? DownloadStatus.downloaded : DownloadStatus.notDownloaded);
    }));
  }
}
