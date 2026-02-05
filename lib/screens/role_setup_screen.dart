import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';
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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(l.roleSetup, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF16213E),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.playersCount(playerCount),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    l.rolesSelected(totalRoles),
                    style: TextStyle(
                      color: rolesMatch ? Colors.green : Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (!rolesMatch)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.orange.withOpacity(0.2),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.totalRolesMustMatch,
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.freeRoles,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...Role.freeRoles.map((role) => _buildRoleCard(
                          context,
                          role,
                          gameProvider,
                          l,
                        )),
                    const SizedBox(height: 24),
                    Text(
                      l.premiumRoles,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...Role.premiumRoles.map((role) => _buildRoleCard(
                          context,
                          role,
                          gameProvider,
                          l,
                        )),
                  ],
                ),
              ),
            ),
            if (gameProvider.adsEnabled) _buildAdBanner(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: rolesMatch
                    ? () {
                        gameProvider.proceedToRoleDistribution();
                        Navigator.pushNamed(context, '/role-reveal');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l.continueButton,
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
      ),
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? const Color(0xFF0F3460).withOpacity(0.5)
              : const Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(16),
          border: isLocked
              ? Border.all(color: Colors.amber.withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            Text(
              role.iconPath,
              style: TextStyle(
                fontSize: 32,
                color: isLocked ? Colors.grey : null,
              ),
            ),
            const SizedBox(width: 16),
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
                          fontSize: 18,
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l.locked,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.getRoleDesc(role.descKey),
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLocked)
              Row(
                children: [
                  IconButton(
                    onPressed: count > 0
                        ? () => gameProvider.setRoleCount(role.type, count - 1)
                        : null,
                    icon: Icon(
                      Icons.remove_circle,
                      color: count > 0 ? Colors.red : Colors.grey,
                      size: 32,
                    ),
                  ),
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        gameProvider.setRoleCount(role.type, count + 1),
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                ],
              )
            else
              const Icon(
                Icons.lock,
                color: Colors.amber,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdBanner() {
    return Container(
      height: 50,
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
