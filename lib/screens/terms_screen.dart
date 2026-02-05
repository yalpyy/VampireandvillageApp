import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';
import '../utils/localization_helper.dart';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Same background as home
          Image.asset(
            'assets/images/home_background.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A0A2E),
                      Color(0xFF16213E),
                      Color(0xFF0F0F1A),
                    ],
                  ),
                ),
              );
            },
          ),
          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacingXl),
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryRed, Color(0xFF8B0000)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryRed.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🧛', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    l.appTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXxl),
                  // KVKK Section
                  _buildTermsCard(
                    title: 'KVKK Aydınlatma Metni',
                    content:
                        'Bu uygulama, 6698 sayılı Kişisel Verilerin Korunması Kanunu kapsamında kişisel verilerinizi işlememektedir. Uygulama tamamen çevrimdışı çalışır ve hiçbir kişisel veri sunucularımıza gönderilmez.\n\nUygulama içi satın alımlar için yalnızca uygulama mağazası (Google Play / App Store) tarafından işlenen ödeme bilgileri kullanılır.',
                    isAccepted: _kvkkAccepted,
                    checkboxLabel: 'KVKK Aydınlatma Metnini okudum ve anladım',
                    onChanged: (v) => setState(() => _kvkkAccepted = v ?? false),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Terms Section
                  _buildTermsCard(
                    title: 'Kullanım Koşulları',
                    content:
                        'Bu uygulamayı kullanarak aşağıdaki koşulları kabul etmiş olursunuz:\n\n• Uygulama yalnızca eğlence amaçlıdır\n• Premium özellikler tek seferlik satın alma ile açılır\n• Uygulama içi satın alımlar iade edilemez\n• Uygulama "olduğu gibi" sunulmaktadır\n• Geliştirici, uygulamanın kullanımından doğabilecek zararlardan sorumlu değildir',
                    isAccepted: _termsAccepted,
                    checkboxLabel: 'Kullanım Koşullarını kabul ediyorum',
                    onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  // Accept button
                  ElevatedButton(
                    onPressed:
                        (_kvkkAccepted && _termsAccepted) ? _acceptTerms : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      disabledBackgroundColor: Colors.grey.shade800,
                      minimumSize:
                          const Size(double.infinity, AppTheme.buttonHeightLg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: Text(
                      'KABUL ET VE DEVAM ET',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: (_kvkkAccepted && _termsAccepted)
                            ? Colors.white
                            : Colors.white38,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          InkWell(
            onTap: () => onChanged(!isAccepted),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isAccepted
                        ? AppTheme.primaryRed
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isAccepted
                          ? AppTheme.primaryRed
                          : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isAccepted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Text(
                    checkboxLabel,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
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
