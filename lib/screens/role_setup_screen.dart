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
    final gp = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final totalRoles = gp.state.totalRoles;
    final playerCount = gp.state.playerCount;
    final rolesMatch = totalRoles == playerCount;

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            // ── Header ─────────────────────────────
            GothicHeaderBanner(
              title: 'ROL SE\u00C7\u0130M\u0130',
              subtitle: 'OYUNCU SAYISI',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: GothicColors.goldPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              statusWidget: _buildStatusChip(playerCount, totalRoles, rolesMatch),
            ),

            // ── Warning if mismatch ────────────────
            if (!rolesMatch) _buildWarningBar(l),

            // ── Scrollable body ────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // player count card
                    _buildPlayerCountCard(playerCount, totalRoles, rolesMatch),
                    const SizedBox(height: 20),

                    // free roles
                    _buildSectionDivider(l.freeRoles),
                    const SizedBox(height: 10),
                    FramedPanel(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children:
                            Role.freeRoles.asMap().entries.map((entry) {
                          final role = entry.value;
                          final count = gp.getRoleCount(role.type);
                          return OrnateRoleRow(
                            iconEmoji: role.iconPath,
                            name: l.getRoleName(role.nameKey),
                            description: l.getRoleDesc(role.descKey),
                            count: count,
                            onMinus: count > 0
                                ? () => gp.setRoleCount(
                                    role.type, count - 1)
                                : null,
                            onPlus: () =>
                                gp.setRoleCount(role.type, count + 1),
                            showDivider:
                                entry.key < Role.freeRoles.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // premium roles
                    _buildSectionDivider(l.premiumRoles),
                    const SizedBox(height: 10),
                    FramedPanel(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children: Role.premiumRoles
                            .asMap()
                            .entries
                            .map((entry) {
                          final role = entry.value;
                          final isLocked = role.isPremium && !gp.isPremium;
                          final count = gp.getRoleCount(role.type);
                          return OrnateRoleRow(
                            iconEmoji: role.iconPath,
                            name: l.getRoleName(role.nameKey),
                            description: l.getRoleDesc(role.descKey),
                            count: count,
                            isLocked: isLocked,
                            onMinus: count > 0
                                ? () => gp.setRoleCount(
                                    role.type, count - 1)
                                : null,
                            onPlus: () =>
                                gp.setRoleCount(role.type, count + 1),
                            onLockedTap: () => showDialog(
                              context: context,
                              builder: (_) => const PaywallDialog(),
                            ),
                            showDivider: entry.key <
                                Role.premiumRoles.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                    // space for CTA
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // ── Sticky CTA ────────────────────────
            StickyCtaBar(
              label: rolesMatch
                  ? 'ROLLER\u0130 DA\u011eIT'
                  : 'ROL SAYISI E\u015e\u0130T DE\u011e\u0130L',
              icon: rolesMatch ? Icons.play_arrow_rounded : Icons.block,
              enabled: rolesMatch,
              onTap: () {
                gp.proceedToRoleDistribution();
                Navigator.pushNamed(context, '/role-reveal');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── status chip inside header ──────────────────

  Widget _buildStatusChip(int players, int roles, bool match) {
    final color = match ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24);
    final icon = match ? Icons.check_circle : Icons.info_outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            '$players oyuncu / $roles rol',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── warning bar ────────────────────────────────

  Widget _buildWarningBar(LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFBBF24).withOpacity(0.08),
            Colors.transparent,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFBBF24).withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFFBBF24), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.totalRolesMustMatch,
              style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ── player count card ──────────────────────────

  Widget _buildPlayerCountCard(int players, int roles, bool match) {
    return FramedPanel(
      child: Column(
        children: [
          Text(
            'TOPLAM OYUNCU',
            style: TextStyle(
              color: GothicColors.goldPrimary.withOpacity(0.5),
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$players',
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 44,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Oyuncu',
            style: TextStyle(
              color: GothicColors.goldPrimary.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          GothicHeaderBanner.buildOrnamentalDivider(opacity: 0.25),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCountPill('$players', 'Oyuncu',
                  GothicColors.goldPrimary.withOpacity(0.4)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  match ? Icons.check_circle : Icons.close,
                  color: match
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              _buildCountPill('$roles', 'Rol',
                  match
                      ? const Color(0xFF4ADE80).withOpacity(0.3)
                      : const Color(0xFFEF4444).withOpacity(0.3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountPill(String value, String label, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: GothicColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: GothicColors.goldPrimary.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── ornamental section divider ─────────────────

  Widget _buildSectionDivider(String label) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  GothicColors.goldPrimary.withOpacity(0.25),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u25C6 ',
                style: TextStyle(
                  color: GothicColors.goldPrimary.withOpacity(0.5),
                  fontSize: 8,
                ),
              ),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: GothicColors.goldPrimary.withOpacity(0.65),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                ' \u25C6',
                style: TextStyle(
                  color: GothicColors.goldPrimary.withOpacity(0.5),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GothicColors.goldPrimary.withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
