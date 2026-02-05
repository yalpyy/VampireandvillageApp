import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final alivePlayers = gameProvider.state.alivePlayers;
    final logs = gameProvider.state.logs;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          '${l.dayPhase} - ${l.day} ${gameProvider.state.nightCount}',
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Log
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.history, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          l.eventLog,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (logs.isEmpty)
                      const Text(
                        '-',
                        style: TextStyle(color: Colors.white38),
                      )
                    else
                      ...logs.reversed.take(5).map((log) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• $log',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Alive Players
              Row(
                children: [
                  const Icon(Icons.people, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    '${l.alivePlayers} (${alivePlayers.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                            ? const Color(0xFF0F3460)
                            : const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            player.isAlive
                                ? Icons.person
                                : Icons.person_off,
                            color:
                                player.isAlive ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            player.name,
                            style: TextStyle(
                              color:
                                  player.isAlive ? Colors.white : Colors.grey,
                              fontSize: 16,
                              decoration: player.isAlive
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          if (!player.isAlive) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l.dead,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (gameProvider.soundEnabled) {
                    SoundService().playVoteStart();
                  }
                  gameProvider.startVoting();
                  Navigator.pushReplacementNamed(context, '/vote');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.how_to_vote, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      l.startVoting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
