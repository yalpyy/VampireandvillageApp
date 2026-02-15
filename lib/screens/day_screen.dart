import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final alivePlayers = gameProvider.state.alivePlayers;
    final logs = gameProvider.state.logs;

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: '${l.dayPhase}'.toUpperCase(),
              subtitle: '${l.day} ${gameProvider.state.nightCount}',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Event Log
                    FramedPanel(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history,
                                  color: GothicColors.goldPrimary.withOpacity(0.7),
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                l.eventLog,
                                style: const TextStyle(
                                  color: GothicColors.goldLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (logs.isEmpty)
                            Text(
                              '-',
                              style: TextStyle(
                                color: GothicColors.goldPrimary.withOpacity(0.3)),
                            )
                          else
                            ...logs.reversed.take(5).map((log) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '\u2022 $log',
                                    style: TextStyle(
                                      color: GothicColors.goldPrimary.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Alive Players header
                    Row(
                      children: [
                        const Icon(Icons.people, color: Color(0xFF4ADE80), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${l.alivePlayers} (${alivePlayers.length})',
                          style: const TextStyle(
                            color: GothicColors.goldLight,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: gameProvider.players.length,
                        itemBuilder: (context, index) {
                          final player = gameProvider.players[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: player.isAlive
                                  ? GothicColors.bgCard
                                  : GothicColors.bgDeep.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: player.isAlive
                                    ? GothicColors.goldPrimary.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  player.isAlive
                                      ? Icons.person
                                      : Icons.person_off,
                                  color: player.isAlive
                                      ? const Color(0xFF4ADE80)
                                      : Colors.grey.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    player.name,
                                    style: TextStyle(
                                      color: player.isAlive
                                          ? GothicColors.goldLight
                                          : Colors.grey.shade600,
                                      fontSize: 15,
                                      decoration: player.isAlive
                                          ? null
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                if (!player.isAlive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: GothicColors.crimson.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      l.dead,
                                      style: const TextStyle(
                                        color: Color(0xFFFCA5A5),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StickyCtaBar(
              label: l.startVoting.toUpperCase(),
              icon: Icons.how_to_vote,
              onTap: () {
                if (gameProvider.soundEnabled) {
                  SoundService().playVoteStart();
                }
                gameProvider.startVoting();
                Navigator.pushReplacementNamed(context, '/vote');
              },
            ),
          ],
        ),
      ),
    );
  }
}
