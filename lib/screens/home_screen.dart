import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/ad_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Gorseldeki altin/amber renk paleti
  static const Color goldPrimary = Color(0xFFC9A84C);
  static const Color goldDark = Color(0xFF8B6914);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color brownDark = Color(0xFF3B2415);
  static const Color brownMedium = Color(0xFF5C3A1E);
  static const Color purpleDark = Color(0xFF2D1045);

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arkaplan gorseli - tam ekran
          Image.asset(
            'assets/images/Homebackground_new.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [purpleDark, brownDark, Color(0xFF0F0F1A)],
                  ),
                ),
              );
            },
          ),
          // Settings butonu - sag ust
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: brownDark.withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(color: goldPrimary.withOpacity(0.4), width: 1.5),
              ),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: const Icon(Icons.settings_outlined),
                color: goldLight,
                iconSize: 24,
              ),
            ),
          ),
          // Sag alt - OYUNA BASLA butonu (altin cerceveli kare)
          Positioned(
            bottom: gameProvider.adsEnabled ? 70 : 24,
            right: 16,
            child: _buildStartButton(gameProvider),
          ),
          // Banner reklam - en altta
          if (gameProvider.adsEnabled)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AdBannerWidget(),
            ),
        ],
      ),
    );
  }

  Widget _buildStartButton(GameProvider gameProvider) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            gameProvider.resetGame();
            Navigator.pushNamed(context, '/player-setup');
          },
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // Altin cerceve
              border: Border.all(
                color: goldPrimary,
                width: 2.5,
              ),
              // Arka plan gradient - koyu kahve/mor
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A2A10),
                  Color(0xFF2D1045),
                  Color(0xFF1A0A1E),
                ],
              ),
              boxShadow: [
                // Dis glow - altin
                BoxShadow(
                  color: goldPrimary.withOpacity(_glowAnimation.value * 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                // Ic golge
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play ikonu - altin
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [goldLight, goldPrimary, goldDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: goldPrimary.withOpacity(_glowAnimation.value * 0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF2D1045),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 10),
                // OYUNA BASLA yazisi
                const Text(
                  'OYUNA',
                  style: TextStyle(
                    color: goldLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    height: 1.1,
                  ),
                ),
                const Text(
                  'BAŞLA',
                  style: TextStyle(
                    color: goldPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
