const f = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ',
  'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ',
  'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
const s = ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ',
  'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ',
  'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'];
const t = ['', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ',
  'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ',
  'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ',
  'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
const ga = 44032;

bool containsKr(String searchWord, String targetWord) {
  List search = searchWord.codeUnits;
  List find = targetWord.codeUnits;

  // check if both are korean.
  if(search.any((element) => (element < 12593 || (element > 12642 && element < 44032) || element > 52044)))
    return false;

  if(find.any((element) => (element < 12593 || (element > 12642 && element < 44032) || element > 52044)))
    return false;

  bool ret = false;
  for(int i = 0; i < search.length; i++)
  {
    if(i + find.length > search.length)
    {
      return ret;
    }

    if(search[i] == find[0])
    {
      ret = true;
    }

    if(ret)
    {
      for(int j = 1; j < find.length; j++)
      {
        if(find[j] < ga)
        {
          if(!charContainsKr(search[i + j], find[j]))
          {
            ret = false;
            break;
          }
        }
        else if(search[i + j] != find[j])
        {
          ret = false;
          break;
        }
      }
    }

    if(ret)
      return true;
  }
  return true;
}

bool charContainsKr(int target, int searchChar) {

  int fn, sn, tn = 0;

  target = target - ga;
  fn = (target ~/ 588);
  sn = ((target - (fn * 588)) ~/ 28);
  tn = (target % 28);

  if(f[fn].codeUnits[0] == searchChar ||
      s[sn].codeUnits[0] == searchChar ||
      (tn != 0 && t[tn].codeUnits[0] == searchChar))
  {
    return true;
  }
  return false;
}