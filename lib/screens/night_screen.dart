import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class NightScreen extends StatefulWidget {
  const NightScreen({super.key});

  @override
  State<NightScreen> createState() => _NightScreenState();
}

class _NightScreenState extends State<NightScreen> {
  int _currentStep = 0;
  String? _selectedPlayerId;
  String? _seerResult;

  // Role-specific accent colors
  Color _roleColor(RoleType type) {
    switch (type) {
      case RoleType.vampire:
        return const Color(0xFFDC2626);
      case RoleType.doctor:
        return const Color(0xFF16A34A);
      case RoleType.guard:
        return const Color(0xFF2563EB);
      case RoleType.seer:
        return const Color(0xFF9333EA);
      default:
        return GothicColors.goldPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final alivePlayers = gameProvider.state.alivePlayers;

    final steps = _buildNightSteps(gameProvider, l);

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: l.nightPhase.toUpperCase(),
              subtitle: '${l.night} ${gameProvider.state.nightCount}',
            ),
            Expanded(
              child: steps.isEmpty
                  ? _buildEndNight(context, gameProvider, l)
                  : _buildNightStep(
                      steps[_currentStep], alivePlayers, gameProvider, l),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _buildNightSteps(
      GameProvider gameProvider, LocalizationHelper l) {
    final steps = <Map<String, dynamic>>[];

    if (gameProvider.hasRole(RoleType.vampire)) {
      steps.add({
        'role': RoleType.vampire,
        'title': l.vampireSelectTarget,
        'icon': '\u{1F9DB}',
      });
    }

    if (gameProvider.hasRole(RoleType.doctor)) {
      steps.add({
        'role': RoleType.doctor,
        'title': l.doctorSelectProtection,
        'icon': '\u{1F489}',
      });
    }

    if (gameProvider.hasRole(RoleType.guard)) {
      steps.add({
        'role': RoleType.guard,
        'title': l.guardSelectProtection,
        'icon': '\u{1F6E1}\uFE0F',
      });
    }

    if (gameProvider.hasRole(RoleType.seer)) {
      steps.add({
        'role': RoleType.seer,
        'title': l.seerPeekRole,
        'icon': '\u{1F52E}',
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
    final color = _roleColor(roleType);

    return Column(
      children: [
        // Role card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.4),
            ),
          ),
          child: Column(
            children: [
              Text(
                step['icon'],
                style: const TextStyle(fontSize: 44),
              ),
              const SizedBox(height: 10),
              Text(
                step['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: GothicColors.goldLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (actor != null) ...[
                const SizedBox(height: 6),
                Text(
                  '(${actor.name})',
                  style: TextStyle(
                    color: GothicColors.goldPrimary.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_seerResult != null && roleType == RoleType.seer)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF9333EA).withOpacity(0.4),
              ),
            ),
            child: Text(
              _seerResult!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GothicColors.goldLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        // Player list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: alivePlayers.length,
            itemBuilder: (context, index) {
              final player = alivePlayers[index];
              if ((roleType == RoleType.doctor || roleType == RoleType.guard) &&
                  player.assignedRole?.type == roleType) {
                return const SizedBox();
              }
              if (roleType == RoleType.guard &&
                  player.id ==
                      gameProvider.state.nightActions.lastGuardProtectionId) {
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
                      l.getRoleName(
                          player.assignedRole?.nameKey ?? 'unknown'),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.25)
                        : GothicColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? color.withOpacity(0.7)
                          : GothicColors.goldPrimary.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? color
                            : GothicColors.goldPrimary.withOpacity(0.3),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        player.name,
                        style: TextStyle(
                          color: isSelected
                              ? GothicColors.goldLight
                              : GothicColors.goldLight.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // CTA
        StickyCtaBar(
          label: _currentStep <
                  _buildNightSteps(gameProvider, l).length - 1
              ? l.continueButton.toUpperCase()
              : l.endNight.toUpperCase(),
          onTap: () => _proceedToNextStep(gameProvider, roleType),
        ),
      ],
    );
  }

  void _proceedToNextStep(GameProvider gameProvider, RoleType currentRole) {
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
        break;
      default:
        break;
    }

    final steps =
        _buildNightSteps(gameProvider, LocalizationHelper.of(context));
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        _selectedPlayerId = null;
        _seerResult = null;
      });
    } else {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l.endNight,
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              gameProvider.endNight();
              if (gameProvider.state.winner != null) {
                Navigator.pushReplacementNamed(context, '/result');
              } else {
                Navigator.pushReplacementNamed(context, '/day');
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [GothicColors.crimson, GothicColors.crimsonDark],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: GothicColors.goldPrimary.withOpacity(0.4),
                ),
              ),
              child: Text(
                l.endNight.toUpperCase(),
                style: const TextStyle(
                  color: GothicColors.goldLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
