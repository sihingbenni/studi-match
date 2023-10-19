

enum WorkingTimeModel {
  partTime;


  factory WorkingTimeModel.fromEAJson(String value) {
    switch (value) {
      case 'partTime':
        return WorkingTimeModel.partTime;
      default:
        throw Exception('Unknown WorkingTimeModel: $value');
    }
  }
}