import 'package:flutter/material.dart';

/// Shared gothic fantasy color palette
class GothicColors {
  static const Color goldPrimary = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color goldDark = Color(0xFF8B6914);
  static const Color bgDeep = Color(0xFF0D0816);
  static const Color bgDark = Color(0xFF1A0E2E);
  static const Color bgCard = Color(0xFF1E1233);
  static const Color bgSurface = Color(0xFF251742);
  static const Color crimson = Color(0xFFB91C1C);
  static const Color crimsonDark = Color(0xFF7F1D1D);
}

/// Full-screen dark purple gradient background
class GothicBackground extends StatelessWidget {
  final Widget child;
  const GothicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A0E2E),
            Color(0xFF0D0816),
            Color(0xFF0A0612),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Parchment-style banner with ornate gold dividers
class GothicHeaderBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;

  const GothicHeaderBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A1640), Color(0xFF1A0E2E)],
        ),
        border: Border(
          bottom: BorderSide(
            color: GothicColors.goldPrimary.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: GothicColors.goldPrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null)
            Align(alignment: Alignment.centerLeft, child: leading!),
          _buildOrnamentalDivider(),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: GothicColors.goldPrimary.withOpacity(0.6),
                fontSize: 13,
                letterSpacing: 2,
              ),
            ),
          ],
          const SizedBox(height: 10),
          _buildOrnamentalDivider(),
        ],
      ),
    );
  }

  Widget _buildOrnamentalDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  GothicColors.goldPrimary.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '\u25C6',
            style: TextStyle(
              color: GothicColors.goldPrimary.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GothicColors.goldPrimary.withOpacity(0.5),
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

/// Card with inner gold border and subtle glow
class FramedPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const FramedPanel({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GothicColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GothicColors.goldPrimary.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: GothicColors.goldPrimary.withOpacity(0.04),
            blurRadius: 16,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Gem-style arrow stepper for counters
class OrnateStepper extends StatelessWidget {
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const OrnateStepper({
    super.key,
    required this.value,
    this.onMinus,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GothicColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GothicColors.goldPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBtn(Icons.remove, onMinus),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(
                color: GothicColors.goldLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildBtn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: enabled
                ? GothicColors.goldPrimary
                : GothicColors.goldPrimary.withOpacity(0.2),
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Full-width bottom CTA ribbon with red/gold gradient
class StickyCtaBar extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final IconData? icon;

  const StickyCtaBar({
    super.key,
    required this.label,
    this.enabled = true,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: GothicColors.bgDeep,
        border: Border(
          top: BorderSide(
            color: enabled
                ? GothicColors.goldPrimary.withOpacity(0.4)
                : Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: enabled
                  ? const LinearGradient(
                      colors: [Color(0xFFB91C1C), Color(0xFF8B1A1A)],
                    )
                  : null,
              color: enabled ? null : const Color(0xFF2A2A3A),
              border: Border.all(
                color: enabled
                    ? GothicColors.goldPrimary.withOpacity(0.5)
                    : const Color(0xFF3A3A4A),
                width: 1.5,
              ),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: GothicColors.crimson.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: SizedBox(
              height: 58,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: enabled ? GothicColors.goldLight : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color:
                          enabled ? GothicColors.goldLight : Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Framed role stamp/badge
class RoleBadge extends StatelessWidget {
  final String icon;
  final String name;
  final bool isEvil;

  const RoleBadge({
    super.key,
    required this.icon,
    required this.name,
    this.isEvil = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isEvil
        ? const Color(0xFFDC2626).withOpacity(0.5)
        : GothicColors.goldPrimary.withOpacity(0.5);
    final bgColor = isEvil ? const Color(0xFF3B0A0A) : GothicColors.bgSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color:
                  isEvil ? const Color(0xFFFCA5A5) : GothicColors.goldLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
