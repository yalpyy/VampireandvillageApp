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

// ───────────────────────────────────────────────
//  GothicBackground
// ───────────────────────────────────────────────

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

// ───────────────────────────────────────────────
//  GothicHeaderBanner
// ───────────────────────────────────────────────

/// Parchment-style banner with ornate gold dividers
class GothicHeaderBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? statusWidget;

  const GothicHeaderBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.statusWidget,
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
          buildOrnamentalDivider(),
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
          if (statusWidget != null) ...[
            const SizedBox(height: 8),
            statusWidget!,
          ],
          const SizedBox(height: 10),
          buildOrnamentalDivider(),
        ],
      ),
    );
  }

  static Widget buildOrnamentalDivider({double opacity = 0.5}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  GothicColors.goldPrimary.withOpacity(opacity),
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
              color: GothicColors.goldPrimary.withOpacity(opacity + 0.2),
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
                  GothicColors.goldPrimary.withOpacity(opacity),
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

// ───────────────────────────────────────────────
//  FramedPanel
// ───────────────────────────────────────────────

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

// ───────────────────────────────────────────────
//  OrnateStepper  (kept for backward compat)
// ───────────────────────────────────────────────

/// Simple gem-style arrow stepper for counters
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

// ───────────────────────────────────────────────
//  GemStepper  (premium jewel-button stepper)
// ───────────────────────────────────────────────

/// Gem-styled increment/decrement stepper with colored jewel buttons,
/// press-scale animation, and glow.
class GemStepper extends StatefulWidget {
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const GemStepper({
    super.key,
    required this.value,
    this.onMinus,
    this.onPlus,
  });

  @override
  State<GemStepper> createState() => _GemStepperState();
}

class _GemStepperState extends State<GemStepper> {
  bool _minusPressed = false;
  bool _plusPressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGem(
          icon: Icons.remove,
          pressed: _minusPressed,
          onTap: widget.onMinus,
          onPressChanged: (v) => setState(() => _minusPressed = v),
          colors: const [Color(0xFFDC2626), Color(0xFF991B1B)],
          disabledBg: const Color(0xFF2A1515),
        ),
        // value frame
        Container(
          width: 42,
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: GothicColors.bgDeep,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: GothicColors.goldPrimary.withOpacity(0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: GothicColors.goldPrimary.withOpacity(0.06),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            '${widget.value}',
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildGem(
          icon: Icons.add,
          pressed: _plusPressed,
          onTap: widget.onPlus,
          onPressChanged: (v) => setState(() => _plusPressed = v),
          colors: const [Color(0xFF16A34A), Color(0xFF166534)],
          disabledBg: const Color(0xFF0D2818),
        ),
      ],
    );
  }

  Widget _buildGem({
    required IconData icon,
    required bool pressed,
    required VoidCallback? onTap,
    required ValueChanged<bool> onPressChanged,
    required List<Color> colors,
    required Color disabledBg,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => onPressChanged(true) : null,
      onTapUp: enabled
          ? (_) {
              onPressChanged(false);
              onTap?.call();
            }
          : null,
      onTapCancel: enabled ? () => onPressChanged(false) : null,
      child: AnimatedScale(
        scale: pressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  )
                : null,
            color: enabled ? null : disabledBg,
            border: Border.all(
              color: enabled
                  ? GothicColors.goldPrimary.withOpacity(0.55)
                  : GothicColors.goldPrimary.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: enabled && !pressed
                ? [
                    BoxShadow(
                      color: colors[0].withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: enabled
                ? GothicColors.goldLight
                : GothicColors.goldPrimary.withOpacity(0.15),
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────
//  OrnateRoleRow
// ───────────────────────────────────────────────

/// A single role row with circular portrait icon, gold text,
/// GemStepper counter, and premium lock state.
class OrnateRoleRow extends StatelessWidget {
  final String iconEmoji;
  final String name;
  final String description;
  final int count;
  final bool isLocked;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onLockedTap;
  final bool showDivider;

  const OrnateRoleRow({
    super.key,
    required this.iconEmoji,
    required this.name,
    required this.description,
    this.count = 0,
    this.isLocked = false,
    this.onMinus,
    this.onPlus,
    this.onLockedTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? onLockedTap : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // circular portrait icon with gold ring
                _buildPortraitIcon(),
                const SizedBox(width: 14),
                // name + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: isLocked
                                    ? Colors.grey.shade500
                                    : GothicColors.goldLight,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 8),
                            _buildProBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: TextStyle(
                          color: isLocked
                              ? Colors.grey.shade700
                              : GothicColors.goldPrimary.withOpacity(0.45),
                          fontSize: 11,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // stepper or lock
                if (!isLocked)
                  GemStepper(
                    value: count,
                    onMinus: onMinus,
                    onPlus: onPlus,
                  )
                else
                  _buildLockIcon(),
              ],
            ),
          ),
          if (showDivider) _buildRowDivider(),
        ],
      ),
    );
  }

  Widget _buildPortraitIcon() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLocked
              ? [
                  Colors.grey.withOpacity(0.25),
                  Colors.grey.withOpacity(0.08),
                ]
              : [
                  GothicColors.goldPrimary.withOpacity(0.6),
                  GothicColors.goldDark.withOpacity(0.25),
                ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLocked
              ? GothicColors.bgDeep.withOpacity(0.8)
              : GothicColors.bgSurface,
          boxShadow: isLocked
              ? null
              : [
                  BoxShadow(
                    color: GothicColors.goldPrimary.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            iconEmoji,
            style: TextStyle(
              fontSize: 26,
              color: isLocked ? Colors.grey : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.2),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, color: Color(0xFFFBBF24), size: 10),
          SizedBox(width: 3),
          Text(
            'PRO',
            style: TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFBBF24).withOpacity(0.08),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.15),
        ),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Color(0xFFFBBF24),
        size: 20,
      ),
    );
  }

  Widget _buildRowDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 66),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GothicColors.goldPrimary.withOpacity(0.15),
            GothicColors.goldPrimary.withOpacity(0.02),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────
//  StickyCtaBar
// ───────────────────────────────────────────────

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
                      color:
                          enabled ? GothicColors.goldLight : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? GothicColors.goldLight
                          : Colors.grey.shade600,
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

// ───────────────────────────────────────────────
//  RoleBadge
// ───────────────────────────────────────────────

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
    final bgColor =
        isEvil ? const Color(0xFF3B0A0A) : GothicColors.bgSurface;

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
              color: isEvil
                  ? const Color(0xFFFCA5A5)
                  : GothicColors.goldLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
