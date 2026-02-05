import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../utils/localization_helper.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  bool _isLocked = true;
  bool _showingRole = false;
  int _num1 = 0;
  int _num2 = 0;
  String _userAnswer = '';
  bool _wrongAnswer = false;
  final Random _random = Random();
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _generateMathChallenge();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _generateMathChallenge() {
    _num1 = _random.nextInt(9) + 1;
    _num2 = _random.nextInt(9) + 1;
    _userAnswer = '';
    _wrongAnswer = false;
    setState(() {});
  }

  int get _correctAnswer => _num1 + _num2;

  void _checkAnswer() {
    if (_userAnswer == _correctAnswer.toString()) {
      setState(() {
        _isLocked = false;
        _showingRole = true;
        _wrongAnswer = false;
      });
      _fadeController.forward();
    } else {
      setState(() {
        _wrongAnswer = true;
        _userAnswer = '';
      });
    }
  }

  void _onISawIt() {
    final gameProvider = context.read<GameProvider>();
    gameProvider.markCurrentPlayerSawRole();

    if (gameProvider.allPlayersRevealed) {
      Navigator.pushReplacementNamed(context, '/admin-control');
    } else {
      _fadeController.reset();
      setState(() {
        _isLocked = true;
        _showingRole = false;
        _generateMathChallenge();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final currentPlayer = gameProvider.currentRevealPlayer;
    final l = LocalizationHelper.of(context);

    if (currentPlayer == null) {
      return const Scaffold(
        backgroundColor: AppTheme.darkBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_showingRole && !currentPlayer.hasSeenRole) {
          _fadeController.reset();
          setState(() {
            _isLocked = true;
            _showingRole = false;
            _generateMathChallenge();
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkerBg,
        body: SafeArea(
          child: _showingRole
              ? _buildRoleScreen(currentPlayer, l)
              : _buildLockScreen(currentPlayer, l),
        ),
      ),
    );
  }

  Widget _buildLockScreen(player, LocalizationHelper l) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.darkerBg,
            AppTheme.darkPurple.withOpacity(0.2),
            AppTheme.darkerBg,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBg.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 40,
                color: Colors.white38,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            // Player info
            Text(
              l.nextPlayer.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              player.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXxl),
            // Math challenge card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                  color: _wrongAnswer
                      ? Colors.red.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                  width: _wrongAnswer ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    l.solveMath.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Math problem
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingXl,
                      vertical: AppTheme.spacingMd,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBg,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Text(
                      '$_num1 + $_num2 = ?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  // Answer display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: _wrongAnswer
                          ? Colors.red.withOpacity(0.1)
                          : AppTheme.darkerBg,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: _wrongAnswer
                            ? Colors.red.withOpacity(0.3)
                            : Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Text(
                      _userAnswer.isEmpty ? '—' : _userAnswer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _wrongAnswer ? Colors.red : Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_wrongAnswer) ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    const Text(
                      'Yanlış cevap, tekrar dene',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            // Number pad
            _buildNumberPad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 3; i++) _buildNumberButton('$i'),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 4; i <= 6; i++) _buildNumberButton('$i'),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 7; i <= 9; i++) _buildNumberButton('$i'),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberButton('C', isAction: true, color: AppTheme.primaryRed),
              _buildNumberButton('0'),
              _buildNumberButton('✓', isAction: true, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String label, {bool isAction = false, Color? color}) {
    return Container(
      width: 70,
      height: 54,
      margin: const EdgeInsets.all(4),
      child: Material(
        color: isAction
            ? (color ?? AppTheme.surfaceBg)
            : AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: () {
            if (label == 'C') {
              setState(() => _userAnswer = '');
            } else if (label == '✓') {
              _checkAnswer();
            } else {
              if (_userAnswer.length < 2) {
                setState(() {
                  _userAnswer += label;
                  _wrongAnswer = false;
                });
              }
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isAction ? 22 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleScreen(player, LocalizationHelper l) {
    final role = player.assignedRole;
    if (role == null) return const SizedBox();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: role.isVampireTeam
                ? [
                    const Color(0xFF2D0A0A),
                    AppTheme.darkerBg,
                  ]
                : [
                    const Color(0xFF0A0A2D),
                    AppTheme.darkerBg,
                  ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                l.yourRole.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXxl),
              // Role card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: role.isVampireTeam
                        ? [const Color(0xFF8B0000), const Color(0xFF4A0000)]
                        : [AppTheme.surfaceBg, AppTheme.darkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: role.isVampireTeam
                          ? Colors.red.withOpacity(0.3)
                          : AppTheme.darkPurple.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Role icon container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          role.iconPath,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Text(
                      l.getRoleName(role.nameKey),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        role.isVampireTeam ? 'KÖTÜ TARAF' : 'İYİ TARAF',
                        style: TextStyle(
                          color: role.isVampireTeam ? Colors.red.shade200 : Colors.green.shade200,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      l.getRoleDesc(role.descKey),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXxl),
              // I saw it button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onISawIt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    minimumSize: const Size(double.infinity, AppTheme.buttonHeightLg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    elevation: 6,
                    shadowColor: AppTheme.primaryRed.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility, size: 24),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(
                        l.iSawIt.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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
