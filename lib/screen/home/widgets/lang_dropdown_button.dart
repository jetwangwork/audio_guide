import 'package:audio_guide/constants.dart';
import 'package:audio_guide/models/audio_lang_model.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';


class LangDropdownButton extends StatelessWidget {
  const LangDropdownButton({
    super.key,
    required this.selectedLangModel,
    required this.onChanged,
  });

  final AudioLangModel selectedLangModel;
  final void Function(AudioLangModel langModel) onChanged;

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.audioLangList;
    return DropdownButton<AudioLangModel>(
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
          onChanged(value);
        }
      },
      underline: const SizedBox(),
      selectedItemBuilder: (_) => items.map((e) => const SizedBox()).toList(),
      items: items.map((item) {
        return DropdownMenuItem<AudioLangModel>(
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
              Text(item.tag.name.toUpperCase()),
            ],
          ),
        );
      }).toList(),
    );
  }
}
