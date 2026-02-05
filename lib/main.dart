import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'services/services.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  try {
    await AdService().initialize();
  } catch (e) {
    // AdMob might not be configured yet - continue without ads
  }

  try {
    await PurchaseService().initialize();
  } catch (e) {
    // In-app purchases might not be configured yet
  }

  runApp(const VampirePartyApp());
}

class VampirePartyApp extends StatelessWidget {
  const VampirePartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          // Update ad service premium status
          AdService().setPremiumStatus(gameProvider.isPremium);

          // Connect purchase service to game provider
          PurchaseService().onPremiumStatusChanged = (isPremium) {
            gameProvider.setPremium(isPremium);
          };

          return MaterialApp(
            title: 'Vampir Partisi',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFFE94560),
              scaffoldBackgroundColor: const Color(0xFF1A1A2E),
              fontFamily: 'Roboto',
            ),
            locale: Locale(gameProvider.locale),
            initialRoute: '/',
            routes: {
              '/': (_) => const PlayerSetupScreen(),
              '/role-setup': (_) => const RoleSetupScreen(),
              '/role-reveal': (_) => const RoleRevealScreen(),
              '/admin-control': (_) => const AdminControlScreen(),
              '/night': (_) => const NightScreen(),
              '/day': (_) => const DayScreen(),
              '/vote': (_) => const VoteScreen(),
              '/result': (_) => const ResultScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/about': (_) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }
}
