import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
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
  int _nightDuration = 60; // Default 60 seconds
  int _dayDuration = 120; // Default 2 minutes

  final List<int> _nightPresets = [30, 60, 90, 120];
  final List<int> _dayPresets = [60, 120, 180, 300];

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
      _remainingSeconds = _isNight ? _nightDuration : _dayDuration;
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

    // Auto-start night timer
    _startTimer(_nightDuration);
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

    // Increment night count when waking up
    gameProvider.incrementNightCount();
  }

  void _markPlayerDead(String playerId) {
    final gameProvider = context.read<GameProvider>();
    gameProvider.killPlayer(playerId);

    if (gameProvider.soundEnabled) {
      SoundService().playDeath();
    }

    // Check win condition
    final winner = gameProvider.state.checkWinCondition();
    if (winner != null) {
      gameProvider.state.winner = winner;
      if (gameProvider.soundEnabled) {
        SoundService().playGameEnd();
      }
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  void _showTimerSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Zamanlayıcı Ayarları',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Night Duration
              const Text(
                'Gece Süresi',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _nightPresets.map((seconds) {
                  final isSelected = _nightDuration == seconds;
                  return ChoiceChip(
                    label: Text(_formatDuration(seconds)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _nightDuration = seconds);
                      setState(() {});
                    },
                    selectedColor: const Color(0xFF4A148C),
                    backgroundColor: const Color(0xFF0F3460),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Day Duration
              const Text(
                'Gündüz Tartışma Süresi',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _dayPresets.map((seconds) {
                  final isSelected = _dayDuration == seconds;
                  return ChoiceChip(
                    label: Text(_formatDuration(seconds)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _dayDuration = seconds);
                      setState(() {});
                    },
                    selectedColor: const Color(0xFFE94560),
                    backgroundColor: const Color(0xFF0F3460),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tamam',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs == 0) return '${minutes}dk';
    return '${minutes}dk ${secs}s';
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
      backgroundColor: _isNight ? const Color(0xFF0D0D1A) : const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: _isNight ? const Color(0xFF1A0A2E) : const Color(0xFF16213E),
        title: Text(
          _isNight ? 'Gece ${gameProvider.state.nightCount + 1}' : 'Gündüz',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A2E),
                title: const Text(
                  'Oyundan Çık',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Oyundan çıkmak istediğinize emin misiniz?',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('İptal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      gameProvider.resetGame();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE94560),
                    ),
                    child: const Text(
                      'Çık',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer, color: Colors.white70),
            onPressed: _showTimerSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Timer Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: _isNight
                  ? const Color(0xFF4A148C).withOpacity(0.3)
                  : const Color(0xFFE94560).withOpacity(0.2),
              child: Column(
                children: [
                  if (_showTimesUp)
                    const Text(
                      '⏰ SÜRE DOLDU!',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      _formatTimer(_remainingSeconds),
                      style: TextStyle(
                        color: _remainingSeconds <= 10 && _remainingSeconds > 0
                            ? Colors.orange
                            : Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Timer Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _timerRunning ? _pauseTimer : _resumeTimer,
                        icon: Icon(
                          _timerRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: _resetTimer,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Player Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final isDead = !player.isAlive;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDead
                          ? const Color(0xFF2D2D2D).withOpacity(0.5)
                          : const Color(0xFF0F3460),
                      borderRadius: BorderRadius.circular(12),
                      border: isDead
                          ? Border.all(color: Colors.red.withOpacity(0.3))
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Player icon/status
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDead
                                      ? Colors.grey.withOpacity(0.3)
                                      : const Color(0xFF16213E),
                                ),
                                child: Center(
                                  child: isDead
                                      ? Text(
                                          player.assignedRole?.iconPath ?? '💀',
                                          style: const TextStyle(fontSize: 24),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Player info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.name,
                                      style: TextStyle(
                                        color: isDead ? Colors.grey : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: isDead
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    if (isDead && player.assignedRole != null)
                                      Text(
                                        l.getRoleName(player.assignedRole!.nameKey),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Kill button (only for alive players)
                              if (!isDead)
                                IconButton(
                                  onPressed: () => _showKillConfirmation(player.id, player.name),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Dead overlay
                        if (isDead)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CrossOutPainter(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Phase Control Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: _isNight
                  ? _buildWakeButton()
                  : _buildSleepButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _putToSleep,
        icon: const Icon(Icons.nightlight_round, color: Colors.white, size: 28),
        label: const Text(
          'Herkesi Uyut',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A148C),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildWakeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _wakeUp,
        icon: const Icon(Icons.wb_sunny, color: Colors.white, size: 28),
        label: const Text(
          'Herkesi Uyandır',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE94560),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showKillConfirmation(String playerId, String playerName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Oyuncu Öldü',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '$playerName öldü olarak işaretlensin mi?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _markPlayerDead(playerId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Öldür',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for crossed out effect
class CrossOutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.4)
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
