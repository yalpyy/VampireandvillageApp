import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class AdminControlScreen extends StatelessWidget {
  const AdminControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);

    return Scaffold(
      body: GothicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Success icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF166534).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4ADE80).withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ADE80).withOpacity(0.1),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Color(0xFF4ADE80),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.allPlayersSawRoles,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: GothicColors.goldLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                GothicHeaderBanner.buildOrnamentalDivider(),
                const SizedBox(height: 12),
                Text(
                  l.readyForModerator,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GothicColors.goldPrimary.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                // Player summary
                FramedPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people,
                          color: GothicColors.goldPrimary.withOpacity(0.7),
                          size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l.playersReady(gameProvider.players.length),
                        style: TextStyle(
                          color: GothicColors.goldPrimary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // CTA
                StickyCtaBar(
                  label: l.goToModerator,
                  icon: Icons.admin_panel_settings,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/moderator');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
