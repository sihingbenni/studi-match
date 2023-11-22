class LeadershipSkills {
  late final bool? hasPowerOfAttorney;
  late final bool? hasBudgetResponsibility;
  late final bool? leadershipResponsibility;

  LeadershipSkills.fromEAJson(dynamic json) {

    if (json == null) {
      return;
    }
    hasPowerOfAttorney = json['hatVollmacht'];
    hasBudgetResponsibility = json['hatBudgetverantwortung'];
    leadershipResponsibility = json['leadershipResponsibility'];
  }
}
