class LeadershipSkills {
  late final bool hasPowerOfAttorney;
  late final bool hasBudgetResponsibility;
  late final int leadershipResponsibility;

  LeadershipSkills.fromEAJson(Map<String, dynamic> json) {
    hasPowerOfAttorney = json['hasPowerOfAttorney'];
    hasBudgetResponsibility = json['hasBudgetResponsibility'];
    leadershipResponsibility = json['leadershipResponsibility'];
  }
}
