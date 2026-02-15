import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/gothic_ui.dart';
import 'role_reveal_screen.dart';

class RoleRevealListScreen extends StatelessWidget {
  const RoleRevealListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final players = gameProvider.players;
    final allRevealed = gameProvider.allPlayersRevealed;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GothicBackground(
          child: Column(
            children: [
              const GothicHeaderBanner(
                title: 'ROL DA\u011eITIMI',
                subtitle: 'Rol\u00fcn\u00fc g\u00f6rmek i\u00e7in dokun',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Info chip
                      _buildInfoChip(players.length, gameProvider),
                      const SizedBox(height: 16),
                      // Player list
                      FramedPanel(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          children:
                              players.asMap().entries.map((entry) {
                            final player = entry.value;
                            final isLast =
                                entry.key == players.length - 1;
                            return _buildPlayerRow(
                              context,
                              entry.key + 1,
                              player,
                              gameProvider,
                              showDivider: !isLast,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Bottom CTA
              if (allRevealed)
                StickyCtaBar(
                  label: 'MODERAT\u00d6R EKRANINA GE\u00c7',
                  icon: Icons.admin_panel_settings,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/moderator'),
                )
              else
                const StickyCtaBar(
                  label: 'T\u00dcM OYUNCULAR G\u00d6RMEL\u0130',
                  enabled: false,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(int total, GameProvider gp) {
    final seen =
        gp.players.where((p) => p.hasSeenRole).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: GothicColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: GothicColors.goldPrimary.withOpacity(0.2)),
      ),
      child: Text(
        '$seen / $total oyuncu rol\u00fcn\u00fc g\u00f6rd\u00fc',
        style: TextStyle(
          color: GothicColors.goldPrimary.withOpacity(0.7),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlayerRow(
    BuildContext context,
    int index,
    player,
    GameProvider gameProvider, {
    bool showDivider = true,
  }) {
    final hasSeen = player.hasSeenRole;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasSeen
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RoleRevealScreen(player: player),
                      ),
                    );
                  },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  // Index circle
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasSeen
                          ? const Color(0xFF166534).withOpacity(0.3)
                          : GothicColors.bgSurface,
                      border: Border.all(
                        color: hasSeen
                            ? const Color(0xFF4ADE80).withOpacity(0.4)
                            : GothicColors.goldPrimary.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: hasSeen
                          ? const Icon(Icons.check_rounded,
                              color: Color(0xFF4ADE80), size: 20)
                          : Text(
                              '$index',
                              style: const TextStyle(
                                color: GothicColors.goldLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Player name
                  Expanded(
                    child: Text(
                      player.name,
                      style: TextStyle(
                        color: hasSeen
                            ? Colors.grey.shade500
                            : GothicColors.goldLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration:
                            hasSeen ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  // Action
                  if (hasSeen)
                    Text(
                      'G\u00f6r\u00fcld\u00fc',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            GothicColors.crimson,
                            GothicColors.crimsonDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              GothicColors.goldPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'G\u00d6R',
                        style: TextStyle(
                          color: GothicColors.goldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: GothicColors.goldPrimary.withOpacity(0.08),
          ),
      ],
    );
  }
}
