import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/game_state.dart';

class GameProvider with ChangeNotifier {
  GameState _state = GameState();
  bool _isPremium = false;
  bool _adminOverride = false;
  bool _soundEnabled = true;
  String _locale = 'tr';
  bool _adsEnabled = true;

  GameState get state => _state;
  bool get isPremium => _isPremium || _adminOverride;
  bool get iapPremium => _isPremium;
  bool get adminOverride => _adminOverride;
  bool get soundEnabled => _soundEnabled;
  String get locale => _locale;
  bool get adsEnabled => _adsEnabled && !isPremium;

  List<Player> get players => _state.players;
  Map<RoleType, int> get roleCounts => _state.roleCounts;
  GamePhase get currentPhase => _state.currentPhase;
  int get currentRevealIndex => _state.currentRevealIndex;

  GameProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('isPremium') ?? false;
    _adminOverride = prefs.getBool('adminOverride') ?? false;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _locale = prefs.getString('locale') ?? 'tr';
    notifyListeners();
  }

  Future<void> setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', value);
    notifyListeners();
  }

  Future<void> setAdminOverride(bool value) async {
    _adminOverride = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adminOverride', value);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  Future<void> setLocale(String value) async {
    _locale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
    notifyListeners();
  }

  // Player Management
  void addPlayer(String name) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _state.players.add(Player(id: id, name: name));
    notifyListeners();
  }

  void removePlayer(String id) {
    _state.players.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updatePlayerName(String id, String name) {
    final index = _state.players.indexWhere((p) => p.id == id);
    if (index != -1) {
      _state.players[index] = _state.players[index].copyWith(name: name);
      notifyListeners();
    }
  }

  // Role Management
  void setRoleCount(RoleType type, int count) {
    if (count <= 0) {
      _state.roleCounts.remove(type);
    } else {
      _state.roleCounts[type] = count;
    }
    notifyListeners();
  }

  int getRoleCount(RoleType type) => _state.roleCounts[type] ?? 0;

  // Phase Management
  void setPhase(GamePhase phase) {
    _state.currentPhase = phase;
    notifyListeners();
  }

  void proceedToRoleSetup() {
    if (_state.players.isNotEmpty) {
      setPhase(GamePhase.roleSetup);
    }
  }

  void proceedToRoleDistribution() {
    if (_state.rolesMatchPlayers) {
      _assignRoles();
      _state.currentRevealIndex = 0;
      setPhase(GamePhase.roleDistribution);
    }
  }

  void _assignRoles() {
    List<Role> rolePool = [];
    for (final entry in _state.roleCounts.entries) {
      final role = Role.allRoles.firstWhere((r) => r.type == entry.key);
      for (int i = 0; i < entry.value; i++) {
        rolePool.add(role);
      }
    }
    _fisherYatesShuffle(rolePool);
    for (int i = 0; i < _state.players.length; i++) {
      _state.players[i].assignedRole = rolePool[i];
      _state.players[i].hasSeenRole = false;
    }
  }

  void _fisherYatesShuffle<T>(List<T> list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  Player? get currentRevealPlayer {
    if (_state.currentRevealIndex < _state.players.length) {
      return _state.players[_state.currentRevealIndex];
    }
    return null;
  }

  void markCurrentPlayerSawRole() {
    if (_state.currentRevealIndex < _state.players.length) {
      _state.players[_state.currentRevealIndex].hasSeenRole = true;
      _state.currentRevealIndex++;
      if (_state.currentRevealIndex >= _state.players.length) {
        setPhase(GamePhase.adminControl);
      }
      notifyListeners();
    }
  }

  void markPlayerSawRole(String playerId) {
    final index = _state.players.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      _state.players[index].hasSeenRole = true;
      notifyListeners();
    }
  }

  bool get allPlayersRevealed =>
      _state.players.isNotEmpty && _state.players.every((p) => p.hasSeenRole);

  // Night Phase - Simplified for moderator mode
  void startNight() {
    _state.nightActions.reset();
    _state.nightCount++;
    _state.isNightPhase = true;
    setPhase(GamePhase.night);
  }

  void incrementNightCount() {
    // Called when waking up from night
    notifyListeners();
  }

  // Kill player - used by moderator
  void killPlayer(String playerId) {
    final playerIndex = _state.players.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1 && _state.players[playerIndex].isAlive) {
      _state.players[playerIndex].isAlive = false;
      final playerName = _state.players[playerIndex].name;
      _state.logs.add('${_state.players[playerIndex].name} öldü');
      notifyListeners();
    }
  }

  void setVampireTarget(String? playerId) {
    _state.nightActions.vampireTargetId = playerId;
    notifyListeners();
  }

  void setDoctorProtection(String? playerId) {
    _state.nightActions.doctorProtectionId = playerId;
    notifyListeners();
  }

  void setSeerPeek(String playerId) {
    _state.nightActions.seerPeekId = playerId;
    final player = _state.players.firstWhere((p) => p.id == playerId);
    _state.nightActions.seerPeekResult = player.assignedRole?.nameKey ?? 'unknown';
    notifyListeners();
  }

  void setGuardProtection(String? playerId) {
    if (playerId != _state.nightActions.lastGuardProtectionId) {
      _state.nightActions.guardProtectionId = playerId;
      notifyListeners();
    }
  }

  bool hasRole(RoleType type) {
    return _state.alivePlayers.any((p) => p.assignedRole?.type == type);
  }

  Player? getAlivePlayerWithRole(RoleType type) {
    try {
      return _state.alivePlayers.firstWhere((p) => p.assignedRole?.type == type);
    } catch (_) {
      return null;
    }
  }

  void endNight() {
    final targetId = _state.nightActions.vampireTargetId;
    final protectedId = _state.nightActions.doctorProtectionId;
    final guardedId = _state.nightActions.guardProtectionId;

    if (targetId != null) {
      final isProtected = targetId == protectedId || targetId == guardedId;
      if (!isProtected) {
        final targetIndex = _state.players.indexWhere((p) => p.id == targetId);
        if (targetIndex != -1) {
          _state.players[targetIndex].isAlive = false;
          final playerName = _state.players[targetIndex].name;
          _state.logs.add('Gece ${_state.nightCount}: $playerName öldü');
        }
      } else {
        _state.logs.add('Gece ${_state.nightCount}: Kimse ölmedi');
      }
    } else {
      _state.logs.add('Gece ${_state.nightCount}: Kimse ölmedi');
    }

    final winner = _state.checkWinCondition();
    if (winner != null) {
      _state.winner = winner;
      setPhase(GamePhase.result);
    } else {
      setPhase(GamePhase.day);
    }
  }

  // Day Phase
  void startVoting() {
    setPhase(GamePhase.vote);
  }

  void eliminatePlayer(String? playerId) {
    if (playerId != null) {
      final playerIndex = _state.players.indexWhere((p) => p.id == playerId);
      if (playerIndex != -1) {
        _state.players[playerIndex].isAlive = false;
        final playerName = _state.players[playerIndex].name;
        _state.logs.add('Oylama: $playerName elendi');
      }
    }

    final winner = _state.checkWinCondition();
    if (winner != null) {
      _state.winner = winner;
      setPhase(GamePhase.result);
    } else {
      setPhase(GamePhase.adminControl);
    }
  }

  // Game Reset
  void resetGame() {
    _state.reset();
    notifyListeners();
  }
}
