import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../utils/localization_helper.dart';

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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(l.votePhase, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94560).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE94560).withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.how_to_vote, color: Color(0xFFE94560)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.selectPlayerToEliminate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: alivePlayers.length,
                  itemBuilder: (context, index) {
                    final player = alivePlayers[index];
                    final isSelected = _selectedPlayerId == player.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedPlayerId = player.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE94560).withOpacity(0.3)
                              : const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFFE94560), width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? const Color(0xFFE94560)
                                  : Colors.white38,
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _eliminatePlayer(context, null),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l.skip,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedPlayerId != null
                          ? () =>
                              _eliminatePlayer(context, _selectedPlayerId)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94560),
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l.eliminate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
