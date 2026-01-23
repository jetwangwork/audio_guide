import 'dart:io';

import 'package:audio_guide/api/api_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'api_manager.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ref.watch(apiManagerProvider);
  return ApiService._internal(api);
});

class ApiService {
  ApiService._internal(this._api);

  final ApiManager _api;

  Future<ApiResult<Response>> getAudioList(int page) {
    return _api.get('/${ApiConstants.defaultAudioLang}/Media/Audio', params: {'page': page});
  }

  Future<ApiResult<File>> downloadAudio(String url, String fileName, void Function(int received, int total)? onProgress) {
    return _api.downloadFile(url: url, fileName: fileName, onProgress: onProgress);
  }
}