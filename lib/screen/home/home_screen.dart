import 'package:audio_guide/route/args/player_screen_args.dart';
import 'package:audio_guide/route/route_constants.dart';
import 'package:audio_guide/screen/home/widgets/audio_item.dart';
import 'package:audio_guide/screen/home/widgets/lang_dropdown_button.dart';
import 'package:audio_guide/theme/app_value.dart';
import 'package:audio_guide/widgets/error_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../models/lang_model.dart';
import 'models/audio_item_model.dart';
import 'models/home_state.dart';
import 'notifiers/home_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 偵測是否滑到底部
    _scrollController.addListener(() {
      final notifier = ref.read(homeNotifier.notifier);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        notifier.getAudioNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifier);
    final notifier = ref.read(homeNotifier.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).HomeScreen_title),
        actions: [
          LangDropdownButton(
            selectedLangModel: notifier.getLang(),
            onChanged: (LangTag langTag) {
              notifier.setLang(langTag);
            },
          ),
          const SizedBox(width: AppValue.defaultPadding / 2)
        ],
      ),
      body: SafeArea(
        child: Expanded(child: _buildListView(state, notifier)),
      ),
    );
  }

  Widget _buildListView(HomeState state, HomeNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: ErrorIcon(size: 80, errorMsg: state.error));
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppValue.defaultPadding),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.audioItemList.length + (state.currentPage != state.totalPage ? 1 : 0),
        itemBuilder: (context, index) {
          // 還可以載入，列表最下面要轉圈圈
          if (index >= state.audioItemList.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppValue.defaultPadding),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final audioItemModel = state.audioItemList[index];
          return AudioItem(
            audioItemModel: audioItemModel,
            index: index,
            onPressed: (int id, int index, String title) {
              if (audioItemModel.status == DownloadStatus.downloaded) {
                Navigator.pushNamed(context, playerScreenRoute, arguments: PlayerScreenArgs(id, title));
              } else {
                notifier.downloadAudio(index);
              }
            },
          );
        },
      ),
    );
  }
}
