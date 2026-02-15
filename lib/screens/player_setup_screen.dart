import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/gothic_ui.dart';
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
      body: GothicBackground(
        child: Column(
          children: [
            GothicHeaderBanner(
              title: 'OYUNCU SE\u00C7\u0130M\u0130',
              subtitle: 'OYUNCU SAYISI',
              leading: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: GothicColors.goldPrimary, size: 20),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: GothicColors.goldPrimary, size: 22),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/settings'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Player count display
                    _buildCountDisplay(players.length),
                    const SizedBox(height: 16),
                    // Add player input
                    _buildAddPlayerInput(l),
                    const SizedBox(height: 20),
                    // Player list
                    if (players.isNotEmpty) ...[
                      _buildSectionLabel('OYUNCULAR'),
                      const SizedBox(height: 8),
                      FramedPanel(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          children: players.asMap().entries.map((entry) {
                            final isLast =
                                entry.key == players.length - 1;
                            return _buildPlayerRow(
                              entry.key + 1,
                              entry.value,
                              gameProvider,
                              showDivider: !isLast,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            // Bottom CTA
            StickyCtaBar(
              label: l.continueButton.toUpperCase(),
              icon: Icons.arrow_forward_rounded,
              enabled: players.length >= 3,
              onTap: () => Navigator.pushNamed(context, '/role-setup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountDisplay(int count) {
    final isValid = count >= 3;
    return FramedPanel(
      child: Column(
        children: [
          Text(
            'TOPLAM OYUNCU',
            style: TextStyle(
              color: GothicColors.goldPrimary.withOpacity(0.5),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: GothicColors.goldLight,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isValid ? 'Oyuncu ekleyebilirsiniz' : 'En az 3 oyuncu gerekli',
            style: TextStyle(
              color: isValid
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFFFBBF24),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlayerInput(LocalizationHelper l) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GothicColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: GothicColors.goldPrimary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              focusNode: _focusNode,
              style:
                  const TextStyle(color: GothicColors.goldLight, fontSize: 16),
              decoration: InputDecoration(
                hintText: l.playerName,
                prefixIcon: Icon(
                  Icons.person_add_outlined,
                  color: GothicColors.goldPrimary.withOpacity(0.5),
                ),
              ),
              onSubmitted: (_) => _addPlayer(),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GothicColors.crimson, GothicColors.crimsonDark],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: GothicColors.goldPrimary.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: _addPlayer,
              icon: const Icon(Icons.add, color: GothicColors.goldLight),
              iconSize: 26,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(
      int index, player, GameProvider gameProvider,
      {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // Circular avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      GothicColors.goldDark.withOpacity(0.4),
                      GothicColors.bgSurface,
                    ],
                  ),
                  border: Border.all(
                      color: GothicColors.goldPrimary.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: GothicColors.goldLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  player.name,
                  style: const TextStyle(
                    color: GothicColors.goldLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => gameProvider.removePlayer(player.id),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.red.withOpacity(0.7),
                  size: 20,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: GothicColors.goldPrimary.withOpacity(0.08),
          ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: GothicColors.goldPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: GothicColors.goldPrimary.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
