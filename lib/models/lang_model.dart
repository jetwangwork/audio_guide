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
  final String apiText;
  final Locale locale;

  const LangModel(this.tag, this.label, this.apiText, this.locale);
}