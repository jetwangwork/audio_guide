import 'dart:ui';

enum LangTag {
  tw,
  cn,
  en,
  jp,
  kr
}

class LangModel {
  final LangTag tag;
  final String label;
  final Locale locale;

  LangModel(this.tag, this.label, this.locale);
}