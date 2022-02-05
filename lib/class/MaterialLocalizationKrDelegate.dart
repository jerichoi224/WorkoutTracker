
import 'package:flutter/material.dart';

class MaterialLocalizationKrDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  /// Here list supported country and language codes
  @override
  bool isSupported(Locale locale) => locale.languageCode == "kr";
  /// Here create an instance of your [MaterialLocalizations] subclass
  @override
  Future<MaterialLocalizations> load(Locale locale) async => DefaultMaterialLocalizations();
  @override
  bool shouldReload(_) => false;
}