import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../utils/app_theme.dart';
import '../utils/localization_helper.dart';

class ModeratorScreen extends StatefulWidget {
  const ModeratorScreen({super.key});

  @override
  State<ModeratorScreen> createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  bool _isNight = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _timerRunning = false;
  bool _showTimesUp = false;

  // Timer settings
  int _selectedNightPreset = 60;
  final List<int> _nightPresets = [30, 60, 90, 120];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = seconds;
      _timerRunning = true;
      _showTimesUp = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        setState(() {
          _timerRunning = false;
          _showTimesUp = true;
        });
        final gameProvider = context.read<GameProvider>();
        if (gameProvider.soundEnabled) {
          SoundService().playTimesUp();
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _timerRunning = false);
  }

  void _resumeTimer() {
    if (_remainingSeconds > 0) {
      _startTimer(_remainingSeconds);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _selectedNightPreset;
      _timerRunning = false;
      _showTimesUp = false;
    });
  }

  void _putToSleep() {
    final gameProvider = context.read<GameProvider>();
    setState(() {
      _isNight = true;
      _showTimesUp = false;
    });

    if (gameProvider.soundEnabled) {
      SoundService().playWolfHowl();
    }

    _startTimer(_selectedNightPreset);
  }

  void _wakeUp() {
    final gameProvider = context.read<GameProvider>();
    _timer?.cancel();
    setState(() {
      _isNight = false;
      _timerRunning = false;
      _showTimesUp = false;
    });

    if (gameProvider.soundEnabled) {
      SoundService().playRooster();
    }

    gameProvider.incrementNightCount();
  }

  void _showKillBottomSheet(String playerId, String playerName) {
    final l = LocalizationHelper.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: AppTheme.spacingLg,
          right: AppTheme.spacingLg,
          top: AppTheme.spacingLg,
          bottom: MediaQuery.of(ctx).padding.bottom + AppTheme.spacingLg,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              l.playerDiedQuestion(playerName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              l.actionCannotBeUndone,
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            // Kill button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _markPlayerDead(playerId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, AppTheme.buttonHeightLg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, size: 24),
                    SizedBox(width: AppTheme.spacingXs),
                    Text(
                      l.killButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppTheme.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  l.cancel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markPlayerDead(String playerId) {
    final gameProvider = context.read<GameProvider>();
    gameProvider.killPlayer(playerId);

    if (gameProvider.soundEnabled) {
      SoundService().playDeath();
    }

    final winner = gameProvider.state.checkWinCondition();
    if (winner != null) {
      gameProvider.state.winner = winner;
      if (gameProvider.soundEnabled) {
        SoundService().playGameEnd();
      }
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final l = LocalizationHelper.of(context);
    final players = gameProvider.players;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          _buildBackground(),
          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isNight
                    ? [
                        Colors.black.withOpacity(0.7),
                        const Color(0xFF1A0A2E).withOpacity(0.9),
                      ]
                    : [
                        Colors.black.withOpacity(0.5),
                        AppTheme.darkBg.withOpacity(0.85),
                      ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(gameProvider, l),
                // Timer section
                _buildTimerSection(),
                // Timer presets
                _buildTimerPresets(),
                // Player list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    itemCount: players.length,
                    itemBuilder: (context, index) =>
                        _buildPlayerCard(players[index], l),
                  ),
                ),
                // Phase control button
                _buildPhaseControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'assets/images/moderator_background.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isNight
                  ? [const Color(0xFF1A0A2E), const Color(0xFF0D0D1A)]
                  : [const Color(0xFF16213E), const Color(0xFF1A1A2E)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(GameProvider gameProvider, LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: Colors.white,
              onPressed: () => _showExitDialog(gameProvider),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Phase indicator
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: _isNight
                    ? AppTheme.darkPurple.withOpacity(0.4)
                    : AppTheme.primaryRed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color: _isNight
                      ? AppTheme.darkPurple.withOpacity(0.5)
                      : AppTheme.primaryRed.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isNight ? Icons.nightlight_round : Icons.wb_sunny,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text(
                    _isNight
                        ? l.nightLabel(gameProvider.state.nightCount + 1)
                        : l.dayLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Player count
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${gameProvider.state.alivePlayers.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
      child: Column(
        children: [
          // Timer display
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingXl,
              vertical: AppTheme.spacingMd,
            ),
            decoration: BoxDecoration(
              color: _showTimesUp
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: _showTimesUp
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                if (_showTimesUp)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alarm, color: Colors.orange, size: 24),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        l.timesUp,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    _formatTimer(_remainingSeconds),
                    style: TextStyle(
                      color: _remainingSeconds <= 10 && _remainingSeconds > 0
                          ? Colors.orange
                          : Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'monospace',
                      letterSpacing: 4,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          // Timer controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerControlButton(
                icon: _timerRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _timerRunning ? _pauseTimer : _resumeTimer,
                primary: true,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _buildTimerControlButton(
                icon: Icons.refresh,
                onPressed: _resetTimer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: primary
            ? AppTheme.primaryRed.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: primary ? AppTheme.primaryRed : Colors.white70,
        iconSize: 24,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTimerPresets() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _nightPresets.map((seconds) {
          final isSelected = _selectedNightPreset == seconds;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedNightPreset = seconds;
                if (!_timerRunning) {
                  _remainingSeconds = seconds;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingXs,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryRed
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryRed
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                '${seconds}s',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlayerCard(player, LocalizationHelper l) {
    final isDead = !player.isAlive;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: isDead
            ? Colors.black.withOpacity(0.4)
            : AppTheme.surfaceBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDead
              ? Colors.red.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                // Avatar/Role icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDead
                        ? Colors.grey.withOpacity(0.2)
                        : AppTheme.darkPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Center(
                    child: isDead
                        ? Text(
                            player.assignedRole?.iconPath ?? '💀',
                            style: const TextStyle(fontSize: 26),
                          )
                        : const Icon(Icons.person, color: Colors.white54),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                // Player info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          color: isDead ? Colors.grey : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isDead ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.red,
                          decorationThickness: 2,
                        ),
                      ),
                      if (isDead && player.assignedRole != null)
                        Row(
                          children: [
                            const Icon(Icons.visibility,
                                color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              l.getRoleName(player.assignedRole!.nameKey),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Kill button (only for alive players)
                if (!isDead)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          _showKillBottomSheet(player.id, player.name),
                      icon: const Icon(Icons.close, color: Colors.red),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
          // Dead overlay line
          if (isDead)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _DiagonalLinePainter(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhaseControl() {
    return Container(
      padding: EdgeInsets.only(
        left: AppTheme.spacingMd,
        right: AppTheme.spacingMd,
        top: AppTheme.spacingMd,
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBg.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: _isNight ? _buildWakeButton() : _buildSleepButton(),
    );
  }

  Widget _buildSleepButton() {
    final l = LocalizationHelper.of(context);
    return ElevatedButton(
      onPressed: _putToSleep,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.darkPurple,
        minimumSize: const Size(double.infinity, AppTheme.buttonHeightLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        elevation: 6,
        shadowColor: AppTheme.darkPurple.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.nightlight_round, size: 26),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            l.putEveryoneToSleep,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: AppTheme.spacingXs),
          const Text('\u{1F43A}', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildWakeButton() {
    final l = LocalizationHelper.of(context);
    return ElevatedButton(
      onPressed: _wakeUp,
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
          const Icon(Icons.wb_sunny, size: 26),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            l.wakeEveryone,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: AppTheme.spacingXs),
          const Text('\u{1F413}', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  void _showExitDialog(GameProvider gameProvider) {
    final l = LocalizationHelper.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(
          l.exitGame,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l.exitGameConfirmation,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              gameProvider.resetGame();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
            ),
            child: Text(l.exit),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
