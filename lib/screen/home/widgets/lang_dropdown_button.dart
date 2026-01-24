import 'package:audio_guide/models/lang_model.dart';
import 'package:audio_guide/riverpod/local_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_colors.dart';

class LangDropdownButton extends ConsumerWidget {
  const LangDropdownButton({
    super.key,
    required this.selectedLangModel,
    required this.onChanged,
  });

  final LangModel selectedLangModel;
  final void Function(LangTag langTag) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(localNotifier.notifier);
    final langList = notifier.supportedLangList;
    return DropdownButton<LangModel>(
      menuWidth: 160,
      value: selectedLangModel,
      icon: const Padding(
        padding: EdgeInsets.all(5),
        child:  Icon(
          Icons.language,
          color: Colors.white,
          size: 30,
        ),
      ),
      onChanged: (value) {
        if (value != null && value != selectedLangModel) {
          onChanged(value.tag);
        }
      },
      underline: const SizedBox(),
      selectedItemBuilder: (_) => langList.map((e) => const SizedBox()).toList(),
      items: langList.map((item) {
        return DropdownMenuItem<LangModel>(
          value: item,
          child: Row(
            children: [
              Icon(
                selectedLangModel == item
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(item.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}
