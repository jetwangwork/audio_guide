import 'package:audio_guide/pages/home/models/audio_item_model.dart';

class HomeState {
  final List<AudioItemModel> audioItemList;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPage;
  final String? error;

  const HomeState({
    required this.audioItemList,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.totalPage = 1,
    this.error,
  });

  HomeState copyWith({
    List<AudioItemModel>? audioItemList,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPage,
    String? error,
  }) {
    return HomeState(
      audioItemList: audioItemList ?? this.audioItemList,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      error: error,
    );
  }
}
