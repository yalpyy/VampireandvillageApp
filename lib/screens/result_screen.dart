import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/paywall_dialog.dart';
import '../utils/localization_helper.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final winner = gameProvider.state.winner;
    final isVampiresWin = winner == 'vampires';

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isVampiresWin
                              ? [Colors.red.shade900, Colors.red.shade700]
                              : [Colors.green.shade700, Colors.green.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isVampiresWin
                                ? Colors.red.withOpacity(0.4)
                                : Colors.green.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isVampiresWin ? '🧛' : '🏠',
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      isVampiresWin ? l.vampiresWin : l.villagersWin,
                      style: TextStyle(
                        color: isVampiresWin ? Colors.red : Colors.green,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Show all players and roles
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: gameProvider.players
                            .map((player) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            player.isAlive
                                                ? Icons.person
                                                : Icons.person_off,
                                            color: player.isAlive
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            player.name,
                                            style: TextStyle(
                                              color: player.isAlive
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            player.assignedRole?.iconPath ?? '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l.getRoleName(
                                                player.assignedRole?.nameKey ??
                                                    ''),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ads allowed on result screen
            if (gameProvider.adsEnabled) _buildAdBanner(),
            // Premium upsell card
            if (!gameProvider.isPremium)
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const PaywallDialog(),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade700, Colors.amber.shade900],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.premiumPackTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    gameProvider.resetGame();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l.newGame,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Ads allowed under New Game button
            if (gameProvider.adsEnabled) _buildAdBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdBanner() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF16213E),
      child: const Center(
        child: Text(
          'Ad Banner Placeholder',
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}
