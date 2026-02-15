import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/game_provider.dart';
import '../services/purchase_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: l.settings.toUpperCase(),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: GothicColors.goldPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Sound Effects
                  _buildSettingCard(
                    icon: Icons.volume_up,
                    title: l.soundEffects,
                    trailing: Switch(
                      value: gameProvider.soundEnabled,
                      onChanged: (value) => gameProvider.setSoundEnabled(value),
                      activeColor: GothicColors.goldPrimary,
                      activeTrackColor: GothicColors.goldDark.withOpacity(0.5),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Language
                  _buildSettingCard(
                    icon: Icons.language,
                    title: l.language,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageChip(
                          'TR',
                          gameProvider.locale == 'tr',
                          () => gameProvider.setLocale('tr'),
                        ),
                        const SizedBox(width: 8),
                        _buildLanguageChip(
                          'EN',
                          gameProvider.locale == 'en',
                          () => gameProvider.setLocale('en'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Restore Purchases
                  _buildSettingCard(
                    icon: Icons.restore,
                    title: l.restorePurchases,
                    onTap: () async {
                      final restored = await PurchaseService().restorePurchases();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              restored ? l.purchaseRestored : l.noPurchasesToRestore,
                            ),
                            backgroundColor: GothicColors.bgCard,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Privacy Policy
                  _buildSettingCard(
                    icon: Icons.privacy_tip_outlined,
                    title: l.privacyPolicy,
                    onTap: () async {
                      final uri = Uri.parse('https://vampireparty.github.io/privacy-policy');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // About
                  _buildSettingCard(
                    icon: Icons.info_outline,
                    title: l.about,
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GothicColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: GothicColors.goldPrimary.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: GothicColors.goldPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: GothicColors.goldLight,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null && onTap != null)
              Icon(Icons.arrow_forward_ios,
                  color: GothicColors.goldPrimary.withOpacity(0.4), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [GothicColors.crimson, GothicColors.crimsonDark],
                )
              : null,
          color: isSelected ? null : GothicColors.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? GothicColors.goldPrimary.withOpacity(0.5)
                : GothicColors.goldPrimary.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? GothicColors.goldLight : GothicColors.goldPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
