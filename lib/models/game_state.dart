import 'player.dart';
import 'role.dart';

enum GamePhase {
  playerSetup,
  roleSetup,
  roleDistribution,
  adminControl,
  night,
  day,
  vote,
  result,
}

class NightActions {
  String? vampireTargetId;
  String? doctorProtectionId;
  String? seerPeekId;
  String? seerPeekResult;
  String? guardProtectionId;
  String? lastGuardProtectionId;
  bool witchSaveUsed;
  bool witchKillUsed;
  String? witchKillTargetId;

  NightActions({
    this.vampireTargetId,
    this.doctorProtectionId,
    this.seerPeekId,
    this.seerPeekResult,
    this.guardProtectionId,
    this.lastGuardProtectionId,
    this.witchSaveUsed = false,
    this.witchKillUsed = false,
    this.witchKillTargetId,
  });

  void reset() {
    lastGuardProtectionId = guardProtectionId;
    vampireTargetId = null;
    doctorProtectionId = null;
    seerPeekId = null;
    seerPeekResult = null;
    guardProtectionId = null;
    witchKillTargetId = null;
  }
}

class GameState {
  List<Player> players;
  Map<RoleType, int> roleCounts;
  GamePhase currentPhase;
  NightActions nightActions;
  List<String> logs;
  int currentRevealIndex;
  int nightCount;
  String? winner;

  GameState({
    List<Player>? players,
    Map<RoleType, int>? roleCounts,
    this.currentPhase = GamePhase.playerSetup,
    NightActions? nightActions,
    List<String>? logs,
    this.currentRevealIndex = 0,
    this.nightCount = 0,
    this.winner,
  })
      : players = players ?? [],
        roleCounts = roleCounts ?? {},
        nightActions = nightActions ?? NightActions(),
        logs = logs ?? [];

  int get totalRoles => roleCounts.values.fold(0, (a, b) => a + b);

  int get playerCount => players.length;

  bool get rolesMatchPlayers => totalRoles == playerCount;

  List<Player> get alivePlayers => players.where((p) => p.isAlive).toList();

  List<Player> get deadPlayers => players.where((p) => !p.isAlive).toList();

  int get aliveVampireCount =>
      alivePlayers.where((p) => p.assignedRole?.isVampireTeam ?? false).length;

  int get aliveVillagerCount => alivePlayers.length - aliveVampireCount;

  String? checkWinCondition() {
    if (aliveVampireCount == 0) {
      return 'villagers';
    }
    if (aliveVampireCount >= aliveVillagerCount) {
      return 'vampires';
    }
    return null;
  }

  void reset() {
    players = [];
    roleCounts = {};
    currentPhase = GamePhase.playerSetup;
    nightActions = NightActions();
    logs = [];
    currentRevealIndex = 0;
    nightCount = 0;
    winner = null;
  }
}
