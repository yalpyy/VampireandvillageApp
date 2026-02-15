import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  String? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final alivePlayers = gameProvider.state.alivePlayers;

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: l.votePhase.toUpperCase(),
            ),
            // Info banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: GothicColors.crimson.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GothicColors.crimson.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.how_to_vote, color: Color(0xFFFCA5A5), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.selectPlayerToEliminate,
                      style: const TextStyle(
                        color: GothicColors.goldLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: alivePlayers.length,
                itemBuilder: (context, index) {
                  final player = alivePlayers[index];
                  final isSelected = _selectedPlayerId == player.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedPlayerId = player.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? GothicColors.crimson.withOpacity(0.3)
                            : GothicColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? GothicColors.crimson.withOpacity(0.7)
                              : GothicColors.goldPrimary.withOpacity(0.12),
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
                                ? const Color(0xFFFCA5A5)
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
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom buttons
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: GothicColors.bgDeep,
                border: Border(
                  top: BorderSide(
                    color: GothicColors.goldPrimary.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Skip button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _eliminatePlayer(context, null),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: GothicColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: GothicColors.goldPrimary.withOpacity(0.25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l.skip.toUpperCase(),
                            style: TextStyle(
                              color: GothicColors.goldPrimary.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Eliminate button
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _selectedPlayerId != null
                          ? () => _eliminatePlayer(context, _selectedPlayerId)
                          : null,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: _selectedPlayerId != null
                              ? const LinearGradient(
                                  colors: [GothicColors.crimson, GothicColors.crimsonDark],
                                )
                              : null,
                          color: _selectedPlayerId != null
                              ? null
                              : const Color(0xFF2A2A3A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedPlayerId != null
                                ? GothicColors.goldPrimary.withOpacity(0.5)
                                : const Color(0xFF3A3A4A),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l.eliminate.toUpperCase(),
                            style: TextStyle(
                              color: _selectedPlayerId != null
                                  ? GothicColors.goldLight
                                  : Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminatePlayer(BuildContext context, String? playerId) {
    final gameProvider = context.read<GameProvider>();

    if (playerId != null && gameProvider.soundEnabled) {
      SoundService().playDeath();
    }

    gameProvider.eliminatePlayer(playerId);

    if (gameProvider.state.winner != null) {
      if (gameProvider.soundEnabled) {
        SoundService().playGameEnd();
      }
      Navigator.pushReplacementNamed(context, '/result');
    } else {
      Navigator.pushReplacementNamed(context, '/admin-control');
    }
  }
}
