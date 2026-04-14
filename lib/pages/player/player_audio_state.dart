enum PlayerStatus { idle, playing, paused }

class PlayerAudioState {
  final String title;
  final String fileName;
  final PlayerStatus status;

  const PlayerAudioState({
    required this.title,
    required this.fileName,
    this.status = PlayerStatus.idle,
  });

  PlayerAudioState copyWith({
    String? title,
    String? fileName,
    PlayerStatus? status,
  }) {
    return PlayerAudioState(
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
    );
  }
}
