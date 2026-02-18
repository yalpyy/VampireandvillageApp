import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';
import '../widgets/gothic_ui.dart';
import '../utils/localization_helper.dart';

class RoleRevealScreen extends StatefulWidget {
  final Player player;

  const RoleRevealScreen({super.key, required this.player});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onGordum() {
    context.read<GameProvider>().markPlayerSawRole(widget.player.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.player.assignedRole;
    final l = LocalizationHelper.of(context);

    if (role == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isEvil = role.isVampireTeam;

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: GothicBackground(
          child: Column(
            children: [
              GothicHeaderBanner(
                title: widget.player.name.toUpperCase(),
                subtitle: l.yourRole.toUpperCase(),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: GothicColors.goldPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Role card
                        _buildRoleCard(role, isEvil, l),
                        const SizedBox(height: 24),
                        // Team badge
                        RoleBadge(
                          icon: role.iconPath,
                          name: isEvil ? l.evilTeam : l.goodTeam,
                          isEvil: isEvil,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // GÖRDÜM CTA
              StickyCtaBar(
                label: l.iSawIt.toUpperCase(),
                icon: Icons.visibility,
                onTap: _onGordum,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(role, bool isEvil, LocalizationHelper l) {
    final glowColor = isEvil
        ? const Color(0xFFDC2626).withOpacity(0.2)
        : GothicColors.goldPrimary.withOpacity(0.15);
    final borderColor = isEvil
        ? const Color(0xFFDC2626).withOpacity(0.4)
        : GothicColors.goldPrimary.withOpacity(0.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isEvil
              ? [const Color(0xFF3B0A0A), const Color(0xFF1A0510)]
              : [const Color(0xFF1E1233), const Color(0xFF0D0816)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(color: glowColor, blurRadius: 20, spreadRadius: 2),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Role icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [BoxShadow(color: glowColor, blurRadius: 12)],
            ),
            child: Center(
              child: Text(role.iconPath, style: const TextStyle(fontSize: 56)),
            ),
          ),
          const SizedBox(height: 20),
          // Role name
          Text(
            l.getRoleName(role.nameKey),
            style: TextStyle(
              color: isEvil
                  ? const Color(0xFFFCA5A5)
                  : GothicColors.goldLight,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              l.getRoleDesc(role.descKey),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEvil
                    ? Colors.red.shade100.withOpacity(0.7)
                    : GothicColors.goldLight.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
