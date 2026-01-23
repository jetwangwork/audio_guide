import 'dart:io';

import 'package:audio_guide/models/audio_lang_model.dart';
import 'package:audio_guide/models/audio_list_model.dart';
import 'package:audio_guide/repository/audio_repository.dart';
import 'package:audio_guide/screen/home/models/audio_item_model.dart';
import 'package:audio_guide/utils/file_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/api_result.dart';
import '../../../constants.dart';
import '../models/home_state.dart';

final homeNotifier = NotifierProvider.autoDispose<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

class HomeNotifier extends AutoDisposeNotifier<HomeState> {

  late final AudioRepository _repo;

  @override
  HomeState build() {
    _repo = ref.read(audioRepositoryProvider);
    state = HomeState(audioItemList: [], isLoading: true);
    getAudioFirstPage();
    return state;
  }

  Future<void> getAudioFirstPage() async {
    final result = await _repo.getAudioList(1);
    switch (result) {
      case ApiSuccess(data: final data):
        final audioItemList = await _checkLocalFiles(data.data);

        final int totalPage = (data.total / 30).toInt() + 1;
        state = state.copyWith(
          isLoading: false,
          audioItemList: audioItemList,
          currentPage: 1,
          totalPage: totalPage,
        );
        break;
      case ApiError(message: final msg):
        state = state.copyWith(
          isLoading: false,
          error: msg
        );
        break;
    }
  }

  Future<void> getAudioNextPage() async {
    if (state.currentPage == state.totalPage || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    final result = await _repo.getAudioList(state.currentPage + 1);
    switch (result) {
      case ApiSuccess(data: final data):
        final audioItemList = await _checkLocalFiles(data.data);;

        state = state.copyWith(
            isLoading: false,
            audioItemList: [...state.audioItemList, ...audioItemList],
            currentPage: state.currentPage + 1,
            isLoadingMore: false
        );
        break;
      case ApiError(message: final msg):
        state = state.copyWith(
            isLoading: false,
            error: msg
        );
        break;
    }
  }

  Future<void> downloadAudio(int index) async {
    final tempList = List.of(state.audioItemList);
    tempList[index] = tempList[index].copyWith(
      status: DownloadStatus.downloading,
    );
    state = state.copyWith(audioItemList: tempList);

    late final downloadStatus;
    final result = await _repo.downloadAudio(state.audioItemList[index].url, FileUtils.getAudioFileName(state.audioItemList[index].id));
    switch (result) {
      case ApiSuccess(data: final path):
        downloadStatus = DownloadStatus.downloaded;
        break;
      case ApiError(message: final msg):
        downloadStatus = DownloadStatus.failed;
        break;
    }

    final newList = List.of(state.audioItemList);
    newList[index] = newList[index].copyWith(
      status: downloadStatus,
    );
    state = state.copyWith(audioItemList: newList);
  }

  AudioLangModel getCurrentAudioLang() {
    final langText = FileUtils.getAudioLangText();
    for (final item in AppConstants.audioLangList) {
      if (item.text == langText) {
        return item;
      }
    }
    return AppConstants.audioLangList[0];
  }

  Future<void> setAudioLang(AudioLangModel langModel) async {
    state = HomeState(audioItemList: [], isLoading: true);
    await FileUtils.setAudioLangText(langModel.tag);
    await getAudioFirstPage();
  }

  Future<List<AudioItemModel>> _checkLocalFiles(List<AudioModel> audioModelList) async {
    return await Future.wait(audioModelList.map((e) async {
      final filePath = await FileUtils.getAudioFilePath(e.id);
      final file = File(filePath);
      final exists = await file.exists();
      return AudioItemModel(id: e.id, title: e.title, url: e.url, status: exists ? DownloadStatus.downloaded : DownloadStatus.notDownloaded);
    }));
  }
}