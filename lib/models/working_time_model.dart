enum WorkingTimeModel {
  partTime,
  fullTime,
  miniJob,
  shiftNightWeekendWork;

  factory WorkingTimeModel.fromEAJson(dynamic value) {
    switch (value) {
      case 'TEILZEIT':
        return WorkingTimeModel.partTime;
      case 'VOLLZEIT':
        return WorkingTimeModel.fullTime;
      case 'MINIJOB':
        return WorkingTimeModel.miniJob;
      case 'SCHICHT_NACHTARBEIT_WOCHENENDE':
        return WorkingTimeModel.shiftNightWeekendWork;
      default:
        throw Exception('Unknown WorkingTimeModel: $value');
    }
  }
}
