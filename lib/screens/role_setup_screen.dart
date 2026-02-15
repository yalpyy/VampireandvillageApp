import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';
import '../widgets/gothic_ui.dart';
import '../widgets/paywall_dialog.dart';
import '../utils/localization_helper.dart';

class RoleSetupScreen extends StatelessWidget {
  const RoleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final totalRoles = gameProvider.state.totalRoles;
    final playerCount = gameProvider.state.playerCount;
    final rolesMatch = totalRoles == playerCount;

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: 'ROL SE\u00C7\u0130M\u0130',
              subtitle: '$playerCount oyuncu / $totalRoles rol',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: GothicColors.goldPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Warning bar
            if (!rolesMatch) _buildWarningBar(l),
            // Scrollable role list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(l.freeRoles, GothicColors.goldLight),
                    const SizedBox(height: 8),
                    FramedPanel(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Column(
                        children: Role.freeRoles.asMap().entries.map((entry) {
                          return _buildRoleRow(
                            context,
                            entry.value,
                            gameProvider,
                            l,
                            showDivider: entry.key < Role.freeRoles.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionLabel(l.premiumRoles, const Color(0xFFFBBF24)),
                    const SizedBox(height: 8),
                    FramedPanel(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Column(
                        children:
                            Role.premiumRoles.asMap().entries.map((entry) {
                          return _buildRoleRow(
                            context,
                            entry.value,
                            gameProvider,
                            l,
                            showDivider:
                                entry.key < Role.premiumRoles.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            // Sticky CTA
            StickyCtaBar(
              label: rolesMatch ? 'ROLLER\u0130 DA\u011eIT' : 'ROL SAYISI E\u015e\u0130T DE\u011e\u0130L',
              icon: rolesMatch ? Icons.play_arrow_rounded : Icons.block,
              enabled: rolesMatch,
              onTap: () {
                gameProvider.proceedToRoleDistribution();
                Navigator.pushNamed(context, '/role-reveal');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBar(LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24).withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
              color: const Color(0xFFFBBF24).withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFFBBF24), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.totalRolesMustMatch,
              style: const TextStyle(
                  color: Color(0xFFFBBF24), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleRow(
    BuildContext context,
    Role role,
    GameProvider gameProvider,
    LocalizationHelper l, {
    bool showDivider = true,
  }) {
    final isPremium = gameProvider.isPremium;
    final isLocked = role.isPremium && !isPremium;
    final count = gameProvider.getRoleCount(role.type);

    return GestureDetector(
      onTap: isLocked
          ? () => showDialog(
                context: context,
                builder: (_) => const PaywallDialog(),
              )
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Role icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.15)
                        : GothicColors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLocked
                          ? Colors.grey.withOpacity(0.2)
                          : GothicColors.goldPrimary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      role.iconPath,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l.getRoleName(role.nameKey),
                            style: TextStyle(
                              color: isLocked
                                  ? Colors.grey
                                  : GothicColors.goldLight,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBF24)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock,
                                      color: Color(0xFFFBBF24), size: 11),
                                  SizedBox(width: 3),
                                  Text(
                                    'PRO',
                                    style: TextStyle(
                                      color: Color(0xFFFBBF24),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.getRoleDesc(role.descKey),
                        style: TextStyle(
                          color: isLocked
                              ? Colors.grey.shade700
                              : GothicColors.goldPrimary.withOpacity(0.4),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Counter or lock
                if (!isLocked)
                  OrnateStepper(
                    value: count,
                    onMinus: count > 0
                        ? () =>
                            gameProvider.setRoleCount(role.type, count - 1)
                        : null,
                    onPlus: () =>
                        gameProvider.setRoleCount(role.type, count + 1),
                  )
                else
                  const Icon(Icons.lock_outline,
                      color: Color(0xFFFBBF24), size: 22),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              color: GothicColors.goldPrimary.withOpacity(0.08),
            ),
        ],
      ),
    );
  }
}
