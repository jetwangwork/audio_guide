import 'dart:io';

import 'package:audio_guide/api/api_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/local_notifier.dart';
import 'api_manager.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ref.watch(apiManagerProvider);
  final notifier = ref.read(localNotifier.notifier);
  return ApiService._internal(api, notifier);
});

class ApiService {
  ApiService._internal(this._api, this._localNotifier);

  final ApiManager _api;
  final LocalNotifier _localNotifier;

  Future<ApiResult<Response>> getAudioList(int page) {
    return _api.get('/${_localNotifier.getLangText()}/Media/Audio', params: {'page': page});
  }

  Future<ApiResult<File>> downloadAudio(String url, String fileName, {void Function(int received, int total)? onProgress}) {
    return _api.downloadFile(url: url, fileName: fileName, onProgress: onProgress);
  }
}