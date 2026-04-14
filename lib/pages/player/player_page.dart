import 'package:audio_guide/pages/player/player_notifier.dart';
import 'package:audio_guide/pages/player/widgets/audio_play_button.dart';
import 'package:audio_guide/theme/app_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import 'player_audio_state.dart';

class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({
    super.key,
    required this.id,
    required this.title
  });

  final int id;
  final String title;

  @override
  ConsumerState<PlayerPage> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerPage> {

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(playerNotifier.notifier);
    notifier.initPlayer(widget.title, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerNotifier);
    final notifier = ref.read(playerNotifier.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PlayerScreen_title),
      ),
      body: SafeArea(
        child: Center(
          child: _buildContent(state, notifier),
        ),
      ),
    );
  }

  Widget _buildContent(PlayerAudioState state, PlayerNotifier notifier) {
    if (state.fileName == '') {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppValue.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            state.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 50),
          Text(
            state.fileName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          AudioPlayButton(
            status: state.status,
            onTap: () {
              notifier.playOrPause();
            }
          ),
          Spacer()
        ],
      ),
    );
  }
}