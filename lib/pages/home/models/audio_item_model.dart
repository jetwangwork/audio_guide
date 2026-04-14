enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

class AudioItemModel {
  final int id;
  final String title;
  final String url;
  final DownloadStatus status;

  const AudioItemModel({
    required this.id,
    required this.title,
    required this.url,
    this.status = DownloadStatus.notDownloaded,
  });

  AudioItemModel copyWith({
    int? id,
    String? title,
    String? url,
    DownloadStatus? status,
  }) {
    return AudioItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      status: status ?? this.status,
    );
  }
}
