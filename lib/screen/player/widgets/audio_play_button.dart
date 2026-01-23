import 'package:flutter/material.dart';

import '../../../theme/app_value.dart';
import '../models/player_audio_state.dart';

class AudioPlayButton extends StatelessWidget {
  const AudioPlayButton({
    super.key,
    required this.status,
    required this.onTap
  });

  final PlayerStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(AppValue.defaultPadding / 2),
          child: Icon(
            status == PlayerStatus.playing
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}