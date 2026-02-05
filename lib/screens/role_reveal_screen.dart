import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../utils/localization_helper.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  bool _isLocked = true;
  bool _showingRole = false;
  int _num1 = 0;
  int _num2 = 0;
  String _userAnswer = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateMathChallenge();
  }

  void _generateMathChallenge() {
    _num1 = _random.nextInt(9) + 1;
    _num2 = _random.nextInt(9) + 1;
    _userAnswer = '';
    setState(() {});
  }

  int get _correctAnswer => _num1 + _num2;

  void _checkAnswer() {
    if (_userAnswer == _correctAnswer.toString()) {
      setState(() {
        _isLocked = false;
        _showingRole = true;
      });
    } else {
      _userAnswer = '';
      setState(() {});
    }
  }

  void _onISawIt() {
    final gameProvider = context.read<GameProvider>();
    gameProvider.markCurrentPlayerSawRole();

    if (gameProvider.allPlayersRevealed) {
      Navigator.pushReplacementNamed(context, '/admin-control');
    } else {
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
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // NO ADS on this screen - security rule
    return WillPopScope(
      onWillPop: () async {
        if (_showingRole && !currentPlayer.hasSeenRole) {
          setState(() {
            _isLocked = true;
            _showingRole = false;
            _generateMathChallenge();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: SafeArea(
          child: _showingRole
              ? _buildRoleScreen(currentPlayer, l)
              : _buildLockScreen(currentPlayer, l),
        ),
      ),
    );
  }

  Widget _buildLockScreen(player, LocalizationHelper l) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.white38,
          ),
          const SizedBox(height: 32),
          Text(
            l.nextPlayer,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l.solveMath,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$_num1 + $_num2 = ?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildNumberPad(),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F3460),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _userAnswer.isEmpty ? '-' : _userAnswer,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            for (int i = 1; i <= 9; i++)
              _buildNumberButton(i.toString()),
            _buildNumberButton('C', isAction: true),
            _buildNumberButton('0'),
            _buildNumberButton('✓', isAction: true),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String label, {bool isAction = false}) {
    return SizedBox(
      width: 72,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (label == 'C') {
            setState(() => _userAnswer = '');
          } else if (label == '✓') {
            _checkAnswer();
          } else {
            if (_userAnswer.length < 2) {
              setState(() => _userAnswer += label);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isAction
              ? (label == '✓' ? const Color(0xFF4CAF50) : const Color(0xFFE94560))
              : const Color(0xFF16213E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleScreen(player, LocalizationHelper l) {
    final role = player.assignedRole;
    if (role == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            player.name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.yourRole,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: role.isVampireTeam
                    ? [const Color(0xFF8B0000), const Color(0xFF4A0000)]
                    : [const Color(0xFF0F3460), const Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: role.isVampireTeam
                      ? Colors.red.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  role.iconPath,
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  l.getRoleName(role.nameKey),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.getRoleDesc(role.descKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onISawIt,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94560),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l.iSawIt,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
