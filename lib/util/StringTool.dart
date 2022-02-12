import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool isKorean(String text)
{
  return text.codeUnits.any((char) =>
  (char >= 0xAC00 && char <= 0xD7AF)
      ||(char >= 0x1100 && char <= 0x11FF)
      ||(char >= 0x3130 && char <= 0x318F)
      ||(char >= 0xA960 && char <= 0xA97F)
      ||(char >= 0xD7B0 && char <= 0xD7FF)
  );
}

extension StringExtension on String {
  String capitalize(String locale) {
    if(locale == "kr")
      return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension DoubleExtension on double {
  String toStringRemoveTrailingZero() {
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter.format(this);
  }
}

extension DurationExtensions on Duration {
  String toMinutesSeconds() {
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inMinutes)}:$twoDigitSeconds";
  }

  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

final dateFormatter = new DateFormat('yy/MM/dd');
final dateTimeFormatter = new DateFormat('yyyy/MM/dd HH:mm');

String getKoreanFirstVowel(String text)
{
  const f = ['ㄱ', 'ㄱ', 'ㄴ', 'ㄷ', 'ㄷ', 'ㄹ', 'ㅁ',
    'ㅂ', 'ㅂ', 'ㅅ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅈ',
    'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
  const ga = 0xac00;

  int unicode = text.codeUnits[0];
  unicode = unicode - ga;

  int fn = (unicode / 588).toInt();

  return f[fn];
}

String base64toString(Uint8List data)
{
  return base64Encode(data);
}

Image imageFromBase64String(String base64String)
{
  return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill
  );
}

String numToTimeText(int time)
{
  String hr = (time~/3600).toString();
  String min = ((time%3600)~/60).toString();
  String sec = (time%60).toString();

  if(min.length == 1)
    min = "0" + min;
  if(sec.length == 1)
    sec = "0" + sec;

  return  hr + ":" + min + ":" + sec;
}
