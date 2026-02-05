# Vampire Party Game - Flutter

A single-device, offline party game inspired by "Vampire / Werewolf". The game is played on ONE phone that is passed hand-to-hand. No backend, no login, no rooms – just pure party fun!

## Features

- **Moderator Mode**: The phone acts as a moderator console - all role decisions happen verbally in the room
- **Offline Only**: No internet required
- **Single Device**: Phone owner controls the game as moderator
- **Multiple Roles**: Villager, Vampire, Doctor, Seer, Hunter, Witch, Lovers, Guard, Drunk
- **Secure Role Reveal**: Math challenges prevent accidental role exposure
- **Timer System**: Configurable night/day timers with presets (30s, 60s, 90s, 2m, 3m, 5m)
- **Sound Effects**: Wolf howl for night, rooster for day, atmospheric audio
- **First Night Rule**: Night 1 has no actions - only timer and phase transitions
- **Localization**: Turkish (default) and English (premium)
- **Premium Features**: One-time purchase removes ads and unlocks all roles
- **KVKK Compliance**: Terms acceptance on first launch

## Game Flow (Moderator Mode)

1. **Setup**: Add players, assign roles
2. **Role Reveal**: Each player sees their role via math challenge
3. **Moderator Screen**: 
   - "Put Everyone to Sleep" → Wolf howl plays, night timer starts
   - "Wake Everyone Up" → Rooster plays, day begins
   - Mark players as dead manually
   - Dead players show their revealed role
4. **Win Condition**: Villagers win when all vampires eliminated, Vampires win when >= villagers

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd vampire_party_game
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── player.dart           # Player model
│   ├── role.dart             # Role definitions
│   └── game_state.dart       # Game state management
├── providers/
│   └── game_provider.dart    # State management with Provider
├── screens/
│   ├── player_setup_screen.dart
│   ├── role_setup_screen.dart
│   ├── role_reveal_screen.dart
│   ├── admin_control_screen.dart
│   ├── night_screen.dart
│   ├── day_screen.dart
│   ├── vote_screen.dart
│   ├── result_screen.dart
│   ├── settings_screen.dart
│   └── about_screen.dart
├── services/
│   ├── ad_service.dart       # AdMob integration
│   ├── purchase_service.dart # In-app purchases
│   ├── sound_service.dart    # Audio playback
│   └── admin_override_service.dart
├── widgets/
│   ├── paywall_dialog.dart
│   └── ad_banner_widget.dart
├── utils/
│   └── localization_helper.dart
└── l10n/
    ├── app_tr.arb           # Turkish translations
    └── app_en.arb           # English translations
```

## AdMob Setup

### Current Configuration (Test Ads)
The app uses Google's test ad unit IDs during development:
- Android Banner: `ca-app-pub-3940256099942544/6300978111`
- iOS Banner: `ca-app-pub-3940256099942544/2934735716`

### Production Setup
1. Create an AdMob account at https://admob.google.com/
2. Create apps for Android and iOS
3. Create banner ad units
4. Update the following files:

**lib/services/ad_service.dart:**
```dart
static String get bannerAdUnitId {
  if (Platform.isAndroid) {
    return 'YOUR_ANDROID_BANNER_AD_UNIT_ID';
  } else if (Platform.isIOS) {
    return 'YOUR_IOS_BANNER_AD_UNIT_ID';
  }
}
```

**android/app/src/main/AndroidManifest.xml:**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="YOUR_ANDROID_APP_ID"/>
```

**ios/Runner/Info.plist:**
```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_IOS_APP_ID</string>
```

## In-App Purchase Setup

### Product ID
- **premium_party_pack** (non-consumable)

### Google Play Console Setup
1. Create an app in Google Play Console
2. Go to Monetize > Products > In-app products
3. Create a new product with ID: `premium_party_pack`
4. Set price and publish

### App Store Connect Setup
1. Create an app in App Store Connect
2. Go to Features > In-App Purchases
3. Create a Non-Consumable product with ID: `premium_party_pack`
4. Set price, description, and submit for review

## Sound Effects

The app expects the following sound files in `assets/sounds/`:
- `night.mp3` - Played when night begins
- `day.mp3` - Played when day begins
- `vote.mp3` - Played when voting starts
- `death.mp3` - Played when a player dies
- `game_end.mp3` - Played when game ends

The app handles missing sound files gracefully (no crash).

## Hidden Admin Override

For testing/gifting purposes:
1. Go to Settings > About
2. Tap the logo 5 times quickly
3. Enter the PIN to unlock premium features on this device

**Note:** This does not fake a purchase - it only enables features locally.

## Build for Release

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

## Game Rules

### Roles

**Free Roles:**
- **Villager**: Vote to eliminate vampires
- **Vampire**: Kill one villager each night
- **Doctor**: Protect one player each night

**Premium Roles:**
- **Seer**: Peek at one player's role each night
- **Hunter**: Kill someone when you die
- **Witch**: One save and one kill potion
- **Lovers**: Two players bound together
- **Guard**: Protect (can't repeat same player)
- **Drunk**: Unknown role until mid-game

### Win Conditions
- **Villagers win**: All vampires eliminated
- **Vampires win**: Vampires >= Villagers

## License

Proprietary - All rights reserved.

## Support

For support, contact: [your-email@example.com]
