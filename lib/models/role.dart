enum RoleType {
  villager,
  vampire,
  doctor,
  seer,
  hunter,
  witch,
  lovers,
  guard,
  drunk,
}

class Role {
  final RoleType type;
  final bool isPremium;

  const Role({
    required this.type,
    this.isPremium = false,
  });

  static const List<Role> allRoles = [
    Role(type: RoleType.villager, isPremium: false),
    Role(type: RoleType.vampire, isPremium: false),
    Role(type: RoleType.doctor, isPremium: false),
    Role(type: RoleType.seer, isPremium: true),
    Role(type: RoleType.hunter, isPremium: true),
    Role(type: RoleType.witch, isPremium: true),
    Role(type: RoleType.lovers, isPremium: true),
    Role(type: RoleType.guard, isPremium: true),
    Role(type: RoleType.drunk, isPremium: true),
  ];

  static List<Role> get freeRoles =>
      allRoles.where((r) => !r.isPremium).toList();

  static List<Role> get premiumRoles =>
      allRoles.where((r) => r.isPremium).toList();

  String get nameKey {
    switch (type) {
      case RoleType.villager:
        return 'villager';
      case RoleType.vampire:
        return 'vampire';
      case RoleType.doctor:
        return 'doctor';
      case RoleType.seer:
        return 'seer';
      case RoleType.hunter:
        return 'hunter';
      case RoleType.witch:
        return 'witch';
      case RoleType.lovers:
        return 'lovers';
      case RoleType.guard:
        return 'guard';
      case RoleType.drunk:
        return 'drunk';
    }
  }

  String get descKey => '${nameKey}Desc';

  String get iconPath {
    switch (type) {
      case RoleType.villager:
        return '🏠';
      case RoleType.vampire:
        return '🧛';
      case RoleType.doctor:
        return '💉';
      case RoleType.seer:
        return '🔮';
      case RoleType.hunter:
        return '🏹';
      case RoleType.witch:
        return '🧪';
      case RoleType.lovers:
        return '💕';
      case RoleType.guard:
        return '🛡️';
      case RoleType.drunk:
        return '🍺';
    }
  }

  bool get isVampireTeam => type == RoleType.vampire;
}
