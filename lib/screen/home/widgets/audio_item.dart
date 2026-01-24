import 'package:audio_guide/screen/home/models/audio_item_model.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../theme/app_value.dart';

class AudioItem extends StatelessWidget {
  const AudioItem({
    super.key,
    required this.audioItemModel,
    required this.index,
    required this.onPressed,
  });

  final AudioItemModel audioItemModel;
  final int index;
  final Function(int id, int index, String title) onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppValue.defaultPadding),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValue.defaultBorderRadius),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppValue.defaultShadowAlpha),
                blurRadius: 8,      // 陰影模糊程度
                offset: Offset(0, 4), // x, y 位移（向下）
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              audioItemModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _buildButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    final buttonText = audioItemModel.status == DownloadStatus.downloaded ? S.of(context).HomeScreen_play_button : S.of(context).HomeScreen_download_button;
    switch (audioItemModel.status) {
      case DownloadStatus.downloading:
        return ElevatedButton(
            onPressed: null,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
        );
      case DownloadStatus.notDownloaded:
      case DownloadStatus.downloaded:
      case DownloadStatus.failed:
        return ElevatedButton(
            onPressed: () {
              onPressed(audioItemModel.id, index, audioItemModel.title);
            },
            child: Text(buttonText)
        );
    }
  }
}