class AudioLangModel {
  final AudioLangTag tag;
  final String text;

  AudioLangModel(this.tag, this.text);
}

enum AudioLangTag {
  tw,
  cn,
  en,
  jp,
  kr
}