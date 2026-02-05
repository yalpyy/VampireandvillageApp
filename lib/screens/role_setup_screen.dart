import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';
import '../widgets/paywall_dialog.dart';
import '../utils/app_theme.dart';
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
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        title: Text(l.roleSetup),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Status bar
          _buildStatusBar(playerCount, totalRoles, rolesMatch, l),
          // Warning if mismatch
          if (!rolesMatch) _buildWarningBar(l),
          // Scrollable role list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(l.freeRoles, Colors.white),
                  const SizedBox(height: AppTheme.spacingSm),
                  ...Role.freeRoles.map((role) => _buildRoleCard(
                        context,
                        role,
                        gameProvider,
                        l,
                      )),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildSectionHeader(l.premiumRoles, Colors.amber),
                  const SizedBox(height: AppTheme.spacingSm),
                  ...Role.premiumRoles.map((role) => _buildRoleCard(
                        context,
                        role,
                        gameProvider,
                        l,
                      )),
                  // Extra padding for sticky CTA
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
          // Sticky bottom CTA
          _buildStickyBottomCTA(context, gameProvider, rolesMatch, l),
        ],
      ),
    );
  }

  Widget _buildStatusBar(
      int playerCount, int totalRoles, bool rolesMatch, LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusChip(
            icon: Icons.people_outline,
            label: '$playerCount oyuncu',
            color: Colors.white70,
          ),
          _buildStatusChip(
            icon: rolesMatch ? Icons.check_circle : Icons.error_outline,
            label: '$totalRoles rol',
            color: rolesMatch ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBar(LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        border: Border(
          bottom: BorderSide(color: Colors.orange.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: AppTheme.spacingXs),
          Expanded(
            child: Text(
              l.totalRolesMustMatch,
              style: const TextStyle(color: Colors.orange, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    Role role,
    GameProvider gameProvider,
    LocalizationHelper l,
  ) {
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
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isLocked
              ? AppTheme.surfaceBg.withOpacity(0.4)
              : AppTheme.surfaceBg,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isLocked
                ? Colors.amber.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            // Role icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.withOpacity(0.2)
                    : AppTheme.darkPurple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Center(
                child: Text(
                  role.iconPath,
                  style: TextStyle(
                    fontSize: 28,
                    color: isLocked ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
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
                          color: isLocked ? Colors.grey : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock, color: Colors.amber, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.amber,
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
                  const SizedBox(height: 4),
                  Text(
                    l.getRoleDesc(role.descKey),
                    style: TextStyle(
                      color: isLocked ? Colors.grey.shade600 : Colors.white54,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Counter or lock
            if (!isLocked)
              _buildCounter(count, gameProvider, role)
            else
              const Icon(Icons.lock_outline, color: Colors.amber, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(int count, GameProvider gameProvider, Role role) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCounterButton(
            icon: Icons.remove,
            onPressed: count > 0
                ? () => gameProvider.setRoleCount(role.type, count - 1)
                : null,
            color: count > 0 ? AppTheme.primaryRed : Colors.grey,
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildCounterButton(
            icon: Icons.add,
            onPressed: () => gameProvider.setRoleCount(role.type, count + 1),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  Widget _buildStickyBottomCTA(
    BuildContext context,
    GameProvider gameProvider,
    bool rolesMatch,
    LocalizationHelper l,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: AppTheme.spacingMd,
        right: AppTheme.spacingMd,
        top: AppTheme.spacingMd,
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: rolesMatch
            ? () {
                gameProvider.proceedToRoleDistribution();
                Navigator.pushNamed(context, '/role-reveal');
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: rolesMatch ? AppTheme.primaryRed : Colors.grey.shade700,
          disabledBackgroundColor: Colors.grey.shade800,
          minimumSize: const Size(double.infinity, AppTheme.buttonHeightLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          elevation: rolesMatch ? 6 : 0,
          shadowColor: rolesMatch ? AppTheme.primaryRed.withOpacity(0.5) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              rolesMatch ? Icons.play_arrow_rounded : Icons.block,
              color: rolesMatch ? Colors.white : Colors.white38,
              size: 28,
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              rolesMatch ? 'ROLLERİ DAĞIT' : 'ROL SAYISI EŞİT DEĞİL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: rolesMatch ? Colors.white : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
