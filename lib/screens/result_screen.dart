import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/paywall_dialog.dart';
import '../services/ad_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    AdService().showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final winner = gameProvider.state.winner;
    final isVampiresWin = winner == 'vampires';

    final accentColor =
        isVampiresWin ? const Color(0xFFDC2626) : const Color(0xFF16A34A);

    return Scaffold(
      body: GothicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Winner icon
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isVampiresWin
                                ? [const Color(0xFF7F1D1D), const Color(0xFF991B1B)]
                                : [const Color(0xFF166534), const Color(0xFF16A34A)],
                          ),
                          border: Border.all(
                            color: GothicColors.goldPrimary.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isVampiresWin ? '\u{1F9DB}' : '\u{1F3E0}',
                            style: const TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        isVampiresWin ? l.vampiresWin : l.villagersWin,
                        style: TextStyle(
                          color: isVampiresWin
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFF86EFAC),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GothicHeaderBanner.buildOrnamentalDivider(),
                      const SizedBox(height: 20),
                      // Player list
                      FramedPanel(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: gameProvider.players
                              .map((player) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                        const SizedBox(width: 10),
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
                                        Text(
                                          player.assignedRole?.iconPath ?? '',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l.getRoleName(
                                              player.assignedRole?.nameKey ??
                                                  ''),
                                          style: TextStyle(
                                            color: GothicColors.goldPrimary
                                                .withOpacity(0.7),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Ads allowed on result screen
              if (gameProvider.adsEnabled) const AdBannerWidget(),
              // Premium upsell card
              if (!gameProvider.isPremium)
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => const PaywallDialog(),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GothicColors.goldDark,
                          GothicColors.goldDark.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: GothicColors.goldPrimary.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: GothicColors.goldLight),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.premiumPackTitle,
                            style: const TextStyle(
                              color: GothicColors.goldLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: GothicColors.goldLight.withOpacity(0.7),
                            size: 16),
                      ],
                    ),
                  ),
                ),
              // New Game CTA
              StickyCtaBar(
                label: l.newGame.toUpperCase(),
                icon: Icons.refresh,
                onTap: () {
                  gameProvider.resetGame();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
