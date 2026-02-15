import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/game_provider.dart';
import '../services/admin_override_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/gothic_ui.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _logoTapCount = 0;
  DateTime? _lastTapTime;

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inSeconds > 2) {
      _logoTapCount = 0;
    }
    _lastTapTime = now;
    _logoTapCount++;

    if (_logoTapCount >= 5) {
      _logoTapCount = 0;
      _showPinDialog();
    }
  }

  void _showPinDialog() {
    final pinController = TextEditingController();
    final l = LocalizationHelper.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GothicColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: GothicColors.goldPrimary.withOpacity(0.3)),
        ),
        title: Text(
          l.enterPin,
          style: const TextStyle(color: GothicColors.goldLight),
        ),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          style: const TextStyle(color: GothicColors.goldLight),
          decoration: InputDecoration(
            filled: true,
            fillColor: GothicColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GothicColors.goldPrimary.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GothicColors.goldPrimary.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GothicColors.goldPrimary.withOpacity(0.6),
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l.cancel,
              style: TextStyle(color: GothicColors.goldPrimary.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final pin = pinController.text;
              if (AdminOverrideService.verifyPin(pin)) {
                context.read<GameProvider>().setAdminOverride(true);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.adminOverrideEnabled),
                    backgroundColor: Colors.green.shade800,
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.incorrectPin),
                    backgroundColor: GothicColors.crimson,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GothicColors.crimson,
            ),
            child: Text(
              l.confirm,
              style: const TextStyle(color: GothicColors.goldLight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);

    return Scaffold(
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: l.about.toUpperCase(),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: GothicColors.goldPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tappable Logo
                      GestureDetector(
                        onTap: _onLogoTap,
                        child: Container(
                          width: 120,
                          height: 120,
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
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: GothicColors.bgCard,
                                  child: const Center(
                                    child: Text('\u{1F9DB}',
                                        style: TextStyle(fontSize: 50)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.appTitle,
                        style: const TextStyle(
                          color: GothicColors.goldLight,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.version} 1.0.0',
                        style: TextStyle(
                          color: GothicColors.goldPrimary.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (gameProvider.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: GothicColors.goldPrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: GothicColors.goldPrimary.withOpacity(0.5),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: GothicColors.goldPrimary),
                              SizedBox(width: 8),
                              Text(
                                'Premium',
                                style: TextStyle(
                                  color: GothicColors.goldPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      // Privacy Policy
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(
                              'https://vampireparty.github.io/privacy-policy');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          l.privacyPolicy,
                          style: TextStyle(
                            color: GothicColors.goldPrimary,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: GothicColors.goldPrimary.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Terms
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(
                              'https://vampireparty.github.io/terms');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          l.termsOfUse,
                          style: TextStyle(
                            color: GothicColors.goldPrimary,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: GothicColors.goldPrimary.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
