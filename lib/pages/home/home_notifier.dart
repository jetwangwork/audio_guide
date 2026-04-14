import 'dart:io';

import 'package:audio_guide/models/api/audio_list_model.dart';
import 'package:audio_guide/models/lang_model.dart';
import 'package:audio_guide/repository/audio_repository.dart';
import 'package:audio_guide/pages/home/models/audio_item_model.dart';
import 'package:audio_guide/utils/file_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_result.dart';
import '../../riverpod/local_notifier.dart';
import 'models/home_state.dart';

final homeNotifier = NotifierProvider.autoDispose<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

class HomeNotifier extends AutoDisposeNotifier<HomeState> {

  late final AudioRepository _repo;
  late final LocalNotifier _localNotifier;

  @override
  HomeState build() {
    _repo = ref.read(audioRepositoryProvider);
    _localNotifier = ref.read(localNotifier.notifier);

    state = HomeState(audioItemList: [], isLoading: true);
    getAudioFirstPage();
    return state;
  }

  Future<void> getAudioFirstPage() async {
    final result = await _repo.getAudioList(1);
    switch (result) {
      case ApiSuccess(data: final data):
        final audioItemList = await checkLocalFiles(data.data);
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
        final audioItemList = await checkLocalFiles(data.data);

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
    final fileName = FileUtils.getAudioFileName(_localNotifier.currentLang.apiText, state.audioItemList[index].id);
    final result = await _repo.downloadAudio(state.audioItemList[index].url, fileName);
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

  LangModel getLang() {
    return _localNotifier.currentLang;
  }

  Future<void> setLang(LangTag langTag) async {
    state = HomeState(audioItemList: [], isLoading: true);
    await _localNotifier.setLang(langTag);
    await getAudioFirstPage();
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