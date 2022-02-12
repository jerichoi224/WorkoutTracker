enum PartType {
  back,
  bicep,
  cardio,
  chest,
  core,
  leg,
  shoulder,
  tricep,
  other,
}

extension toStringPartType on PartType {
  String toLanguageString(String locale) {
    if(locale == "kr")
      {
        switch(this.name)
        {
          case "back":
            return "등";
          case "bicep":
            return "이두";
          case "cardio":
            return "유산소";
          case "chest":
            return "가슴";
          case "core":
            return "코어";
          case "leg":
            return "하체";
          case "shoulder":
            return "어깨";
          case "tricep":
            return "삼두";
          case "other":
            return "그 외";
        }
      }
    return this.name;
  }
}

enum WorkoutType {
  barbell,
  dumbbell,
  cardio,
  machine,
  other,
}

extension toStringWorkoutType on WorkoutType {
  String toLanguageString(String locale) {
    if(locale == "kr")
    {
      switch(this.name)
      {
        case "barbell":
          return "바벨";
        case "dumbbell":
          return "아령";
        case "cardio":
          return "유산소";
        case "machine":
          return "기구 운동";
        case "other":
          return "기타";
      }
    }
    return this.name;
  }
}

enum MetricType {
  km,
  kg,
  floor,
  reps,
  lb,
  duration,
  miles
}