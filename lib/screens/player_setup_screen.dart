import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../utils/localization_helper.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      context.read<GameProvider>().addPlayer(name);
      _nameController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final players = gameProvider.players;
    final l = LocalizationHelper.of(context);

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: Text(l.playerSetup),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBg.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Player count card
                  _buildPlayerCountCard(players.length, l),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Add player input
                  _buildAddPlayerCard(l),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Player list
                  if (players.isNotEmpty) ...[
                    Text(
                      'OYUNCULAR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    ...players.asMap().entries.map((entry) => 
                      _buildPlayerCard(entry.key + 1, entry.value, gameProvider)
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Bottom CTA
          _buildBottomCTA(players.length, l),
        ],
      ),
    );
  }

  Widget _buildPlayerCountCard(int count, LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'TOPLAM OYUNCU',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            count < 3 ? 'En az 3 oyuncu gerekli' : 'Oyuncu ekleyebilirsiniz',
            style: TextStyle(
              color: count < 3 ? Colors.orange : Colors.green,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlayerCard(LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: l.playerName,
                prefixIcon: Icon(
                  Icons.person_add_outlined,
                  color: Colors.white.withOpacity(0.5),
                ),
                filled: true,
                fillColor: AppTheme.surfaceBg,
              ),
              onSubmitted: (_) => _addPlayer(),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _addPlayer,
              icon: const Icon(Icons.add, color: Colors.white),
              iconSize: 28,
              padding: const EdgeInsets.all(AppTheme.spacingSm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(int index, player, GameProvider gameProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.darkPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          onPressed: () => gameProvider.removePlayer(player.id),
          icon: Icon(
            Icons.remove_circle_outline,
            color: Colors.red.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCTA(int playerCount, LocalizationHelper l) {
    final canContinue = playerCount >= 3;

    return Container(
      padding: EdgeInsets.only(
        left: AppTheme.spacingLg,
        right: AppTheme.spacingLg,
        top: AppTheme.spacingMd,
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canContinue
            ? () => Navigator.pushNamed(context, '/role-setup')
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canContinue ? AppTheme.primaryRed : Colors.grey.shade700,
          disabledBackgroundColor: Colors.grey.shade800,
          minimumSize: const Size(double.infinity, AppTheme.buttonHeightLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          elevation: canContinue ? 4 : 0,
        ),
        child: Text(
          l.continueButton.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: canContinue ? Colors.white : Colors.white38,
          ),
        ),
      ),
    );
  }
}
