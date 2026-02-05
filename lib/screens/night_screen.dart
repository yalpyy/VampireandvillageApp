import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';

class NightScreen extends StatefulWidget {
  const NightScreen({super.key});

  @override
  State<NightScreen> createState() => _NightScreenState();
}

class _NightScreenState extends State<NightScreen> {
  int _currentStep = 0;
  String? _selectedPlayerId;
  String? _seerResult;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final alivePlayers = gameProvider.state.alivePlayers;

    final steps = _buildNightSteps(gameProvider, l);

    // NO ADS on this screen - security rule
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0A2E),
        title: Text(
          '${l.nightPhase} - ${l.night} ${gameProvider.state.nightCount}',
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: steps.isEmpty
            ? _buildEndNight(context, gameProvider, l)
            : _buildNightStep(steps[_currentStep], alivePlayers, gameProvider, l),
      ),
    );
  }

  List<Map<String, dynamic>> _buildNightSteps(
      GameProvider gameProvider, LocalizationHelper l) {
    final steps = <Map<String, dynamic>>[];

    // Always have vampire action
    if (gameProvider.hasRole(RoleType.vampire)) {
      steps.add({
        'role': RoleType.vampire,
        'title': l.vampireSelectTarget,
        'icon': '🧛',
        'color': Colors.red,
      });
    }

    // Doctor action
    if (gameProvider.hasRole(RoleType.doctor)) {
      steps.add({
        'role': RoleType.doctor,
        'title': l.doctorSelectProtection,
        'icon': '💉',
        'color': Colors.green,
      });
    }

    // Guard action
    if (gameProvider.hasRole(RoleType.guard)) {
      steps.add({
        'role': RoleType.guard,
        'title': 'Muhafız: Koruyacağın kişiyi seç',
        'icon': '🛡️',
        'color': Colors.blue,
      });
    }

    // Seer action
    if (gameProvider.hasRole(RoleType.seer)) {
      steps.add({
        'role': RoleType.seer,
        'title': l.seerPeekRole,
        'icon': '🔮',
        'color': Colors.purple,
      });
    }

    return steps;
  }

  Widget _buildNightStep(
    Map<String, dynamic> step,
    List alivePlayers,
    GameProvider gameProvider,
    LocalizationHelper l,
  ) {
    final roleType = step['role'] as RoleType;
    final actor = gameProvider.getAlivePlayerWithRole(roleType);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (step['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (step['color'] as Color).withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                Text(
                  step['icon'],
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 12),
                Text(
                  step['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (actor != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '(${actor.name})',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_seerResult != null && roleType == RoleType.seer) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _seerResult!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: alivePlayers.length,
              itemBuilder: (context, index) {
                final player = alivePlayers[index];
                // Skip self for doctor/guard protection
                if ((roleType == RoleType.doctor || roleType == RoleType.guard) &&
                    player.assignedRole?.type == roleType) {
                  return const SizedBox();
                }
                // Guard can't protect same person consecutively
                if (roleType == RoleType.guard &&
                    player.id == gameProvider.state.nightActions.lastGuardProtectionId) {
                  return const SizedBox();
                }

                final isSelected = _selectedPlayerId == player.id;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedPlayerId = player.id);
                    if (roleType == RoleType.seer) {
                      gameProvider.setSeerPeek(player.id);
                      _seerResult = l.seerResult(
                        player.name,
                        l.getRoleName(player.assignedRole?.nameKey ?? 'unknown'),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (step['color'] as Color).withOpacity(0.4)
                          : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: step['color'], width: 2)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? step['color'] : Colors.white38,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          player.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _proceedToNextStep(gameProvider, roleType),
            style: ElevatedButton.styleFrom(
              backgroundColor: step['color'],
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentStep < _buildNightSteps(gameProvider, l).length - 1
                  ? l.continueButton
                  : l.endNight,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToNextStep(GameProvider gameProvider, RoleType currentRole) {
    // Save the selection
    switch (currentRole) {
      case RoleType.vampire:
        gameProvider.setVampireTarget(_selectedPlayerId);
        break;
      case RoleType.doctor:
        gameProvider.setDoctorProtection(_selectedPlayerId);
        break;
      case RoleType.guard:
        gameProvider.setGuardProtection(_selectedPlayerId);
        break;
      case RoleType.seer:
        // Already saved when selected
        break;
      default:
        break;
    }

    final steps = _buildNightSteps(gameProvider, LocalizationHelper.of(context));
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        _selectedPlayerId = null;
        _seerResult = null;
      });
    } else {
      // End night
      gameProvider.endNight();
      if (gameProvider.soundEnabled) {
        if (gameProvider.state.winner != null) {
          SoundService().playGameEnd();
          Navigator.pushReplacementNamed(context, '/result');
        } else {
          SoundService().playDayStart();
          Navigator.pushReplacementNamed(context, '/day');
        }
      } else {
        if (gameProvider.state.winner != null) {
          Navigator.pushReplacementNamed(context, '/result');
        } else {
          Navigator.pushReplacementNamed(context, '/day');
        }
      }
    }
  }

  Widget _buildEndNight(
      BuildContext context, GameProvider gameProvider, LocalizationHelper l) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          gameProvider.endNight();
          if (gameProvider.state.winner != null) {
            Navigator.pushReplacementNamed(context, '/result');
          } else {
            Navigator.pushReplacementNamed(context, '/day');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A148C),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          l.endNight,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
