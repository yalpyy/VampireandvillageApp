import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE94560), Color(0xFF8B0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE94560).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🧛', style: TextStyle(fontSize: 50)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // KVKK Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KVKK Aydınlatma Metni',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bu uygulama, 6698 sayılı Kişisel Verilerin Korunması Kanunu kapsamında kişisel verilerinizi işlememektedir. Uygulama tamamen çevrimdışı çalışır ve hiçbir kişisel veri sunucularımıza gönderilmez.\n\nUygulama içi satın alımlar için yalnızca uygulama mağazası (Google Play / App Store) tarafından işlenen ödeme bilgileri kullanılır.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _kvkkAccepted,
                      onChanged: (v) => setState(() => _kvkkAccepted = v ?? false),
                      title: const Text(
                        'KVKK Aydınlatma Metnini okudum ve anladım',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      activeColor: const Color(0xFFE94560),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Terms Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kullanım Koşulları',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bu uygulamayı kullanarak aşağıdaki koşulları kabul etmiş olursunuz:\n\n• Uygulama yalnızca eğlence amaçlıdır\n• Premium özellikler tek seferlik satın alma ile açılır\n• Uygulama içi satın alımlar iade edilemez\n• Uygulama "olduğu gibi" sunulmaktadır\n• Geliştirici, uygulamanın kullanımından doğabilecek zararlardan sorumlu değildir',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _termsAccepted,
                      onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                      title: const Text(
                        'Kullanım Koşullarını kabul ediyorum',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      activeColor: const Color(0xFFE94560),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_kvkkAccepted && _termsAccepted) ? _acceptTerms : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  disabledBackgroundColor: Colors.grey.shade700,
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
            ],
          ),
        ),
      ),
    );
  }
}
