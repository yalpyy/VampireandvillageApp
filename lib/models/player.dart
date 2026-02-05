import 'role.dart';

class Player {
  final String id;
  final String name;
  Role? assignedRole;
  bool isAlive;
  bool hasSeenRole;

  Player({
    required this.id,
    required this.name,
    this.assignedRole,
    this.isAlive = true,
    this.hasSeenRole = false,
  });

  Player copyWith({
    String? id,
    String? name,
    Role? assignedRole,
    bool? isAlive,
    bool? hasSeenRole,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      assignedRole: assignedRole ?? this.assignedRole,
      isAlive: isAlive ?? this.isAlive,
      hasSeenRole: hasSeenRole ?? this.hasSeenRole,
    );
  }
}
