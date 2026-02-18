import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class TermsScreen extends StatefulWidget {
  final VoidCallback onAccepted;

  const TermsScreen({super.key, required this.onAccepted});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _kvkkAccepted = false;
  bool _termsAccepted = false;

  Future<void> _acceptTerms() async {
    if (_kvkkAccepted && _termsAccepted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('termsAccepted', true);
      widget.onAccepted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = LocalizationHelper.of(context);

    return Scaffold(
      body: GothicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: GothicColors.crimson.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: GothicColors.bgCard,
                            child: const Center(
                              child: Text('\u{1F9DB}',
                                  style: TextStyle(fontSize: 40)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.appTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: GothicColors.goldLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                GothicHeaderBanner.buildOrnamentalDivider(),
                const SizedBox(height: 24),
                // KVKK Section
                _buildTermsCard(
                  title: l.kvkkTitle,
                  content: l.kvkkContent,
                  isAccepted: _kvkkAccepted,
                  checkboxLabel: l.kvkkAgreed,
                  onChanged: (v) => setState(() => _kvkkAccepted = v ?? false),
                ),
                const SizedBox(height: 16),
                // Terms Section
                _buildTermsCard(
                  title: l.termsTitle,
                  content: l.termsContent,
                  isAccepted: _termsAccepted,
                  checkboxLabel: l.termsAgreed,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                ),
                const SizedBox(height: 24),
                // Accept button
                GestureDetector(
                  onTap: (_kvkkAccepted && _termsAccepted) ? _acceptTerms : null,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: (_kvkkAccepted && _termsAccepted)
                          ? const LinearGradient(
                              colors: [GothicColors.crimson, GothicColors.crimsonDark],
                            )
                          : null,
                      color: (_kvkkAccepted && _termsAccepted)
                          ? null
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (_kvkkAccepted && _termsAccepted)
                            ? GothicColors.goldPrimary.withOpacity(0.5)
                            : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l.acceptAndContinue,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: (_kvkkAccepted && _termsAccepted)
                              ? GothicColors.goldLight
                              : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCard({
    required String title,
    required String content,
    required bool isAccepted,
    required String checkboxLabel,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GothicColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: GothicColors.goldPrimary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(
                  color: GothicColors.goldPrimary.withOpacity(0.6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => onChanged(!isAccepted),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isAccepted
                        ? GothicColors.crimson
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isAccepted
                          ? GothicColors.crimson
                          : GothicColors.goldPrimary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isAccepted
                      ? const Icon(Icons.check,
                          color: GothicColors.goldLight, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    checkboxLabel,
                    style: TextStyle(
                      color: GothicColors.goldLight.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
