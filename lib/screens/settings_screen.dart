import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/localization_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(l.settings, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
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
                activeColor: const Color(0xFFE94560),
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
                    context,
                    'TR',
                    gameProvider.locale == 'tr',
                    () => gameProvider.setLocale('tr'),
                  ),
                  const SizedBox(width: 8),
                  _buildLanguageChip(
                    context,
                    'EN',
                    gameProvider.locale == 'en',
                    gameProvider.isPremium
                        ? () => gameProvider.setLocale('en')
                        : null,
                    isPremiumLocked: !gameProvider.isPremium,
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
                // TODO: Call purchase service restore
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.purchaseRestored)),
                );
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
          color: const Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null && onTap != null)
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback? onTap, {
    bool isPremiumLocked = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE94560)
              : isPremiumLocked
                  ? Colors.grey.withOpacity(0.3)
                  : const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
          border: isPremiumLocked
              ? Border.all(color: Colors.amber.withOpacity(0.5))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isPremiumLocked && !isSelected
                    ? Colors.grey
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isPremiumLocked && !isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.lock, color: Colors.amber, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}
