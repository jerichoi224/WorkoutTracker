import 'package:flutter/cupertino.dart';

class CupertinoLocalizationKrDelegate extends LocalizationsDelegate<CupertinoLocalizations> {

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(_) => false;

  @override
  Future<CupertinoLocalizations> load(Locale locale) async => DefaultCupertinoLocalizations();

}