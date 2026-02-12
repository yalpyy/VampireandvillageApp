import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'providers/game_provider.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS 14+ ATT izni iste (reklamlardan ONCE)
  if (!kIsWeb && Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(seconds: 1));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // Initialize services
  try {
    await AdService().initialize();
    await AdService().loadInterstitialAd();
  } catch (e) {
    // AdMob might not be configured yet - continue without ads
  }

  try {
    await PurchaseService().initialize();
  } catch (e) {
    // In-app purchases might not be configured yet
  }

  // Check if terms accepted
  final prefs = await SharedPreferences.getInstance();
  final termsAccepted = prefs.getBool('termsAccepted') ?? false;

  runApp(VampirePartyApp(termsAccepted: termsAccepted));
}

class VampirePartyApp extends StatefulWidget {
  final bool termsAccepted;

  const VampirePartyApp({super.key, required this.termsAccepted});

  @override
  State<VampirePartyApp> createState() => _VampirePartyAppState();
}

class _VampirePartyAppState extends State<VampirePartyApp> {
  late bool _termsAccepted;

  @override
  void initState() {
    super.initState();
    _termsAccepted = widget.termsAccepted;
  }

  void _onTermsAccepted() {
    setState(() => _termsAccepted = true);
  }

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
            theme: AppTheme.darkTheme,
            locale: Locale(gameProvider.locale),
            home: _termsAccepted
                ? const HomeScreen()
                : TermsScreen(onAccepted: _onTermsAccepted),
            routes: {
              '/home': (_) => const HomeScreen(),
              '/player-setup': (_) => const PlayerSetupScreen(),
              '/role-setup': (_) => const RoleSetupScreen(),
              '/role-reveal': (_) => const RoleRevealScreen(),
              '/admin-control': (_) => const AdminControlScreen(),
              '/moderator': (_) => const ModeratorScreen(),
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
