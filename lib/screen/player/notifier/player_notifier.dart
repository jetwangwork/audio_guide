import 'package:audio_guide/utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../riverpod/local_notifier.dart';
import '../models/player_audio_state.dart';

final playerNotifier = NotifierProvider.autoDispose<PlayerNotifier, PlayerAudioState>(() {
  return PlayerNotifier();
});

class PlayerNotifier extends AutoDisposeNotifier<PlayerAudioState> {

  final _player = AudioPlayer();
  late final LocalNotifier _localNotifier;

  @override
  PlayerAudioState build() {
    _localNotifier = ref.read(localNotifier.notifier);

    _player.playerStateStream.listen((playerState) {
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.completed &&
          state.status == PlayerStatus.playing) {
        debugPrint('播放結束');
        stop();
      }
    });

    ref.onDispose(() {
      _player.dispose();
    });

    state = PlayerAudioState(title: '', fileName: '');
    return state;
  }

  Future<void> initPlayer(String title, id) async {
    final fileName = FileUtils.getAudioFileName(_localNotifier.getCurrentLangText(), id);
    final filePath = await FileUtils.getAudioFilePath(_localNotifier.getCurrentLangText(), id);
    await _player.setFilePath(filePath);
    state = state.copyWith(title: title, fileName: fileName);
  }

  void playOrPause() {
    if (state.status == PlayerStatus.playing) {
      pause();
    } else {
      play();
    }
  }

  Future<void> play() async {
    debugPrint('play');
    state = state.copyWith(status: PlayerStatus.playing);
    await _player.play();
  }

  Future<void> pause() async {
    debugPrint('pause');
    state = state.copyWith(status: PlayerStatus.paused);
    await _player.pause();
  }

  Future<void> stop() async {
    debugPrint('stop');
    state = state.copyWith(status: PlayerStatus.idle);
    await _player.stop();
  }
}