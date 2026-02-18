import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class LocalizationHelper {
  final BuildContext context;

  LocalizationHelper._(this.context);

  static LocalizationHelper of(BuildContext context) {
    return LocalizationHelper._(context);
  }

  String get locale {
    try {
      return context.read<GameProvider>().locale;
    } catch (_) {
      return 'tr';
    }
  }

  bool get _isEn => locale == 'en';

  // ── General ────────────────────────────────────
  String get appTitle => _isEn ? 'Vampire Party' : 'Vampir Partisi';
  String get continueButton => _isEn ? 'Continue' : 'Devam Et';
  String get confirm => _isEn ? 'Confirm' : 'Onayla';
  String get cancel => _isEn ? 'Cancel' : '\u0130ptal';
  String get warning => _isEn ? 'Warning' : 'Uyar\u0131';
  String get ok => _isEn ? 'OK' : 'Tamam';
  String get dead => _isEn ? 'Dead' : '\u00d6ld\u00fc';
  String get alive => _isEn ? 'Alive' : 'Hayatta';
  String get player => _isEn ? 'Player' : 'Oyuncu';
  String get role => _isEn ? 'Role' : 'Rol';
  String get night => _isEn ? 'Night' : 'Gece';
  String get day => _isEn ? 'Day' : 'G\u00fcnd\u00fcz';
  String get exit => _isEn ? 'Exit' : '\u00c7\u0131k';

  // ── Home Screen ────────────────────────────────
  String get startGameLine1 => _isEn ? 'START' : 'OYUNA';
  String get startGameLine2 => _isEn ? 'GAME' : 'BA\u015eLA';

  // ── Player Setup ───────────────────────────────
  String get playerSetup => _isEn ? 'Player Setup' : 'Oyuncu Ayarlar\u0131';
  String get playerSelection => _isEn ? 'PLAYER SELECTION' : 'OYUNCU SE\u00c7\u0130M\u0130';
  String get playerCount => _isEn ? 'PLAYER COUNT' : 'OYUNCU SAYISI';
  String get totalPlayers => _isEn ? 'TOTAL PLAYERS' : 'TOPLAM OYUNCU';
  String get players => _isEn ? 'PLAYERS' : 'OYUNCULAR';
  String get enterPlayerCount => _isEn ? 'Enter player count' : 'Oyuncu say\u0131s\u0131n\u0131 girin';
  String get playerName => _isEn ? 'Player Name' : 'Oyuncu Ad\u0131';
  String get addPlayer => _isEn ? 'Add' : 'Ekle';
  String get removePlayer => _isEn ? 'Remove' : 'Kald\u0131r';
  String get canAddPlayers => _isEn ? 'You can add players' : 'Oyuncu ekleyebilirsiniz';
  String get minimumPlayersRequired => _isEn ? 'At least 3 players required' : 'En az 3 oyuncu gerekli';

  // ── Role Setup ─────────────────────────────────
  String get roleSetup => _isEn ? 'Role Setup' : 'Rol Ayarlar\u0131';
  String get roleSelection => _isEn ? 'ROLE SELECTION' : 'ROL SE\u00c7\u0130M\u0130';
  String get totalRolesMustMatch => _isEn ? 'Total roles must match player count' : 'Toplam rol say\u0131s\u0131 oyuncu say\u0131s\u0131na e\u015fit olmal\u0131';
  String rolesSelected(int count) => _isEn ? '$count roles selected' : '$count rol se\u00e7ildi';
  String playersCount(int count) => _isEn ? '$count players' : '$count oyuncu';
  String get freeRoles => _isEn ? 'Free Roles' : '\u00dccretsiz Roller';
  String get premiumRoles => _isEn ? 'Premium Roles' : 'Premium Roller';
  String get locked => _isEn ? 'Locked' : 'Kilitli';
  String get premiumRole => _isEn ? 'Premium Role' : 'Premium Rol';
  String get unlockPremium => _isEn ? 'Unlock Premium' : 'Premium Paketi A\u00e7';
  String get premiumRequired => _isEn ? 'Premium required for this role' : 'Bu rol i\u00e7in premium gerekli';
  String get distributeRoles => _isEn ? 'DISTRIBUTE ROLES' : 'ROLLER\u0130 DA\u011eIT';
  String get roleCountMismatch => _isEn ? 'ROLE COUNT MISMATCH' : 'ROL SAYISI E\u015e\u0130T DE\u011e\u0130L';
  String playerAndRoleCount(int players, int roles) =>
      _isEn ? '$players players / $roles roles' : '$players oyuncu / $roles rol';

  // ── Role Reveal ────────────────────────────────
  String get nextPlayer => _isEn ? 'Next Player' : 'S\u0131radaki Oyuncu';
  String get solveMath => _isEn ? 'Solve to see your role' : 'Rol\u00fcn\u00fc g\u00f6rmek i\u00e7in \u00e7\u00f6z';
  String get yourRole => _isEn ? 'Your Role' : 'Senin Rol\u00fcn';
  String get iSawIt => _isEn ? 'I Saw It' : 'G\u00f6rd\u00fcm';
  String get seeRole => _isEn ? 'SEE' : 'G\u00d6R';
  String get seen => _isEn ? 'Seen' : 'G\u00f6r\u00fcld\u00fc';
  String get roleDistribution => _isEn ? 'ROLE DISTRIBUTION' : 'ROL DA\u011eITIMI';
  String get tapToSeeRole => _isEn ? 'Tap to see your role' : 'Rol\u00fcn\u00fc g\u00f6rmek i\u00e7in dokun';
  String get evilTeam => _isEn ? 'EVIL TEAM' : 'K\u00d6T\u00dc TARAF';
  String get goodTeam => _isEn ? 'GOOD TEAM' : '\u0130Y\u0130 TARAF';
  String get allPlayersMustSee => _isEn ? 'ALL PLAYERS MUST SEE' : 'T\u00dcM OYUNCULAR G\u00d6RMEL\u0130';
  String playersSawRole(int seen, int total) =>
      _isEn ? '$seen / $total players saw their role' : '$seen / $total oyuncu rol\u00fcn\u00fc g\u00f6rd\u00fc';
  String get allPlayersSawRoles => _isEn ? 'All players saw their roles' : 'T\u00fcm oyuncular rollerini g\u00f6rd\u00fc';
  String get goToModerator => _isEn ? 'GO TO MODERATOR' : 'MODERAT\u00d6R EKRANINA GE\u00c7';
  String get readyForModerator => _isEn ? 'Ready to proceed to moderator screen' : 'Moderat\u00f6r ekran\u0131na ge\u00e7meye haz\u0131rs\u0131n\u0131z';
  String playersReady(int count) => _isEn ? '$count players ready' : '$count oyuncu haz\u0131r';

  // ── Moderator Screen ───────────────────────────
  String get putEveryoneToSleep => _isEn ? 'PUT EVERYONE TO SLEEP' : 'HERKES\u0130 UYUT';
  String get wakeEveryone => _isEn ? 'WAKE EVERYONE UP' : 'HERKES\u0130 UYANDIR';
  String nightLabel(int num) => _isEn ? 'NIGHT $num' : 'GECE $num';
  String get dayLabel => _isEn ? 'DAY' : 'G\u00dcND\u00dcZ';
  String get timesUp => _isEn ? 'TIME\'S UP!' : 'S\u00dcRE DOLDU!';
  String playerDiedQuestion(String player) =>
      _isEn ? 'Did $player die?' : '$player \u00f6ld\u00fc m\u00fc?';
  String get actionCannotBeUndone => _isEn ? 'This action cannot be undone' : 'Bu i\u015flem geri al\u0131namaz';
  String get killButton => _isEn ? 'KILL' : '\u00d6LD\u00dcR';
  String get exitGame => _isEn ? 'Exit Game' : 'Oyundan \u00c7\u0131k';
  String get exitGameConfirmation => _isEn
      ? 'Are you sure you want to exit? Progress will not be saved.'
      : 'Oyundan \u00e7\u0131kmak istedi\u011finize emin misiniz? \u0130lerleme kaydedilmeyecek.';

  // ── Night / Day / Vote ─────────────────────────
  String get startNight => _isEn ? 'Put Everyone to Sleep (Start Night)' : 'Herkesi Uyut (Gece Ba\u015flas\u0131n)';
  String get nightPhase => _isEn ? 'Night Phase' : 'Gece Faz\u0131';
  String get dayPhase => _isEn ? 'Day Phase' : 'G\u00fcnd\u00fcz Faz\u0131';
  String get votePhase => _isEn ? 'Voting Phase' : 'Oylama Faz\u0131';
  String get vampireSelectTarget => _isEn ? 'Vampire: Select target' : 'Vampir: Hedef se\u00e7';
  String get doctorSelectProtection => _isEn ? 'Doctor: Select who to protect' : 'Doktor: Koruyaca\u011f\u0131n ki\u015fiyi se\u00e7';
  String get seerPeekRole => _isEn ? 'Seer: Select who to peek at' : 'Kahin: Rol\u00fcn\u00fc g\u00f6rmek istedi\u011fin ki\u015fiyi se\u00e7';
  String get guardSelectProtection => _isEn ? 'Guard: Select who to protect' : 'Muhaf\u0131z: Koruyaca\u011f\u0131n ki\u015fiyi se\u00e7';
  String seerResult(String player, String role) => _isEn ? '$player\'s role: $role' : '$player rol\u00fc: $role';
  String get endNight => _isEn ? 'End Night' : 'Geceyi Bitir';
  String playerDied(String player) => _isEn ? '$player died!' : '$player \u00f6ld\u00fc!';
  String get nobodyDied => _isEn ? 'Nobody died tonight.' : 'Bu gece kimse \u00f6lmedi.';
  String get alivePlayers => _isEn ? 'Alive Players' : 'Hayatta Kalanlar';
  String get eventLog => _isEn ? 'Event Log' : 'Olay G\u00fcnl\u00fc\u011f\u00fc';
  String get startVoting => _isEn ? 'Start Voting' : 'Oylamay\u0131 Ba\u015flat';
  String get selectPlayerToEliminate => _isEn ? 'Select a player to eliminate' : 'Elemine edilecek oyuncuyu se\u00e7';
  String get eliminate => _isEn ? 'Eliminate' : 'Elemine Et';
  String get skip => _isEn ? 'Skip' : 'Atla';

  // ── Result ─────────────────────────────────────
  String get villagersWin => _isEn ? 'Villagers Win!' : 'K\u00f6yl\u00fcler Kazand\u0131!';
  String get vampiresWin => _isEn ? 'Vampires Win!' : 'Vampirler Kazand\u0131!';
  String get newGame => _isEn ? 'New Game' : 'Yeni Oyun';

  // ── Settings ───────────────────────────────────
  String get settings => _isEn ? 'Settings' : 'Ayarlar';
  String get soundEffects => _isEn ? 'Sound Effects' : 'Ses Efektleri';
  String get language => _isEn ? 'Language' : 'Dil';
  String get turkish => 'T\u00fcrk\u00e7e';
  String get english => 'English';
  String get premiumOnly => _isEn ? 'Premium Only' : 'Sadece Premium';
  String get restorePurchases => _isEn ? 'Restore Purchases' : 'Sat\u0131n Al\u0131mlar\u0131 Geri Y\u00fckle';
  String get purchaseRestored => _isEn ? 'Purchases restored' : 'Sat\u0131n al\u0131mlar geri y\u00fcklendi';
  String get noPurchasesToRestore => _isEn ? 'No purchases to restore' : 'Geri y\u00fcklenecek sat\u0131n al\u0131m yok';

  // ── About / Premium ────────────────────────────
  String get about => _isEn ? 'About' : 'Hakk\u0131nda';
  String get version => _isEn ? 'Version' : 'Versiyon';
  String get premiumPackTitle => _isEn ? 'Premium Party Pack' : 'Premium Parti Paketi';
  String get premiumPackDesc => _isEn ? 'Unlock all roles, remove ads!' : 'T\u00fcm rolleri a\u00e7, reklamlar\u0131 kald\u0131r!';
  String get premiumPackPrice => _isEn ? 'Buy Once' : 'Tek Seferlik Sat\u0131n Al';
  String get purchase => _isEn ? 'Purchase' : 'Sat\u0131n Al';
  String get alreadyPremium => _isEn ? 'Already Premium' : 'Zaten Premium';
  String get adminPanel => _isEn ? 'Admin Panel' : 'Y\u00f6netici Paneli';
  String get controlPanel => _isEn ? 'Control Panel' : 'Kontrol Paneli';
  String get backToSetup => _isEn ? 'Back to Setup' : 'Ayarlara D\u00f6n';
  String get enterPin => _isEn ? 'Enter PIN' : 'PIN Girin';
  String get incorrectPin => _isEn ? 'Incorrect PIN' : 'Yanl\u0131\u015f PIN';
  String get adminOverrideEnabled => _isEn ? 'Admin override enabled' : 'Y\u00f6netici yetkisi etkinle\u015ftirildi';
  String get privacyPolicy => _isEn ? 'Privacy Policy' : 'Gizlilik Politikas\u0131';
  String get termsOfUse => _isEn ? 'Terms of Use' : 'Kullan\u0131m Ko\u015fullar\u0131';

  // ── Terms Screen ───────────────────────────────
  String get kvkkTitle => _isEn
      ? 'KVKK Disclosure & Privacy Policy'
      : 'KVKK Ayd\u0131nlatma Metni ve Gizlilik Politikas\u0131';
  String get kvkkContent => _isEn
      ? 'This application does not process your personal data under the scope of the Personal Data Protection Law (KVKK No. 6698). The app works completely offline and no personal data is sent to our servers.\n\n'
        'Advertising Service: The app uses Google AdMob advertising service. AdMob may collect device identifiers and usage data for ad display purposes. This data is processed under Google\'s privacy policy.\n\n'
        'In-App Purchases: Payment transactions are processed solely by Apple App Store / Google Play. Your payment information is neither seen nor stored by us.\n\n'
        'Tracking Permission (iOS): On iOS 14+ devices, tracking permission may be requested to show more relevant ads. You can reject this permission; the app will continue to work.\n\n'
        'Your Rights: Under KVKK, you have the right to access, correct, and delete your personal data.'
      : 'Bu uygulama, 6698 say\u0131l\u0131 Ki\u015fisel Verilerin Korunmas\u0131 Kanunu (KVKK) kapsam\u0131nda ki\u015fisel verilerinizi i\u015flememektedir. Uygulama tamamen \u00e7evrimd\u0131\u015f\u0131 \u00e7al\u0131\u015f\u0131r ve hi\u00e7bir ki\u015fisel veri sunucular\u0131m\u0131za g\u00f6nderilmez.\n\n'
        'Reklam Hizmeti: Uygulama, Google AdMob reklam hizmeti kullanmaktad\u0131r. AdMob, reklam g\u00f6sterimi ama\u00e7l\u0131 cihaz tan\u0131mlay\u0131c\u0131s\u0131 ve kullan\u0131m verisi toplayabilir. Bu veriler Google\'un gizlilik politikas\u0131 kapsam\u0131nda i\u015flenir.\n\n'
        'Uygulama \u0130\u00e7i Sat\u0131n Al\u0131mlar: \u00d6deme i\u015flemleri yaln\u0131zca Apple App Store / Google Play taraf\u0131ndan i\u015flenir. \u00d6deme bilgileriniz taraf\u0131m\u0131zca g\u00f6r\u00fclmez ve saklanmaz.\n\n'
        '\u0130zleme \u0130zni (iOS): iOS 14 ve \u00fczeri cihazlarda, size daha uygun reklamlar g\u00f6stermek i\u00e7in izleme izni istenebilir. Bu izni reddedebilirsiniz; uygulama \u00e7al\u0131\u015fmaya devam eder.\n\n'
        'Haklar\u0131n\u0131z: KVKK kapsam\u0131nda ki\u015fisel verilerinize eri\u015fim, d\u00fczeltme ve silme haklar\u0131n\u0131z bulunmaktad\u0131r.';
  String get kvkkAgreed => _isEn
      ? 'I have read and understood the KVKK Disclosure'
      : 'KVKK Ayd\u0131nlatma Metnini okudum ve anlad\u0131m';
  String get termsTitle => _isEn ? 'Terms of Use' : 'Kullan\u0131m Ko\u015fullar\u0131';
  String get termsContent => _isEn
      ? 'By using this application, you agree to the following terms:\n\n'
        '- The app is for entertainment purposes only\n'
        '- Premium features are unlocked with a one-time purchase\n'
        '- In-app purchases are subject to Apple/Google refund policies\n'
        '- Advertisements are displayed within the app\n'
        '- The app is provided "as is"\n'
        '- The developer is not responsible for any damages arising from use of the app\n'
        '- The app is suitable for users aged 12 and above'
      : 'Bu uygulamay\u0131 kullanarak a\u015fa\u011f\u0131daki ko\u015fullar\u0131 kabul etmi\u015f olursunuz:\n\n'
        '- Uygulama yaln\u0131zca e\u011flence ama\u00e7l\u0131d\u0131r\n'
        '- Premium \u00f6zellikler tek seferlik sat\u0131n alma ile a\u00e7\u0131l\u0131r\n'
        '- Uygulama i\u00e7i sat\u0131n al\u0131mlar Apple/Google iade politikalar\u0131na tabidir\n'
        '- Uygulama i\u00e7erisinde reklam g\u00f6sterimi yap\u0131lmaktad\u0131r\n'
        '- Uygulama "oldu\u011fu gibi" sunulmaktad\u0131r\n'
        '- Geli\u015ftirici, uygulaman\u0131n kullan\u0131m\u0131ndan do\u011fabilecek zararlardan sorumlu de\u011fildir\n'
        '- Uygulama 12 ya\u015f ve \u00fczeri kullan\u0131c\u0131lar i\u00e7in uygundur';
  String get termsAgreed => _isEn
      ? 'I accept the Terms of Use'
      : 'Kullan\u0131m Ko\u015fullar\u0131n\u0131 kabul ediyorum';
  String get acceptAndContinue => _isEn ? 'ACCEPT & CONTINUE' : 'KABUL ET VE DEVAM ET';

  // ── Role names ─────────────────────────────────
  String getRoleName(String key) {
    final roleNamesTr = {
      'villager': 'K\u00f6yl\u00fc',
      'vampire': 'Vampir',
      'doctor': 'Doktor',
      'seer': 'Kahin',
      'hunter': 'Avc\u0131',
      'witch': 'Cad\u0131',
      'lovers': 'A\u015f\u0131klar',
      'guard': 'Muhaf\u0131z',
      'drunk': 'Sarho\u015f',
    };
    final roleNamesEn = {
      'villager': 'Villager',
      'vampire': 'Vampire',
      'doctor': 'Doctor',
      'seer': 'Seer',
      'hunter': 'Hunter',
      'witch': 'Witch',
      'lovers': 'Lovers',
      'guard': 'Guard',
      'drunk': 'Drunk',
    };
    return (_isEn ? roleNamesEn : roleNamesTr)[key] ?? key;
  }

  // ── Role descriptions ──────────────────────────
  String getRoleDesc(String key) {
    final roleDescsTr = {
      'villagerDesc': 'S\u0131radan bir k\u00f6yl\u00fc. Vampirleri bul ve oy vererek eleyin.',
      'vampireDesc': 'Her gece bir kurban se\u00e7. K\u00f6yl\u00fcleri azalt.',
      'doctorDesc': 'Her gece birini koru. Vampir sald\u0131r\u0131s\u0131n\u0131 engelle.',
      'seerDesc': 'Her gece bir oyuncunun rol\u00fcn\u00fc \u00f6\u011fren.',
      'hunterDesc': '\u00d6ld\u00fc\u011f\u00fcnde birini se\u00e7ip \u00f6ld\u00fcrebilirsin.',
      'witchDesc': 'Bir kurtarma ve bir \u00f6ld\u00fcrme iksirin var.',
      'loversDesc': '\u0130ki oyuncu ba\u011fl\u0131. Biri \u00f6l\u00fcrse di\u011feri de \u00f6l\u00fcr.',
      'guardDesc': 'Her gece birini koru. Ayn\u0131 ki\u015fiyi arka arkaya koruyamazs\u0131n.',
      'drunkDesc': 'Gece kafas\u0131ndan bir rol se\u00e7er ve o rol gibi davran\u0131r. Ancak bu se\u00e7im tamamen kendi hayal g\u00fcc\u00fcne dayan\u0131r.',
    };
    final roleDescsEn = {
      'villagerDesc': 'An ordinary villager. Find the vampires and vote them out.',
      'vampireDesc': 'Choose a victim each night. Reduce the villagers.',
      'doctorDesc': 'Protect someone each night. Block vampire attacks.',
      'seerDesc': 'Learn the role of one player each night.',
      'hunterDesc': 'When you die, you can choose someone to take with you.',
      'witchDesc': 'You have one healing and one killing potion.',
      'loversDesc': 'Two players are bound. If one dies, the other dies too.',
      'guardDesc': 'Protect someone each night. Cannot protect the same person consecutively.',
      'drunkDesc': 'At night, he chooses a role in his mind and behaves as if he were that role. However, this choice is purely imaginary.',
    };
    return (_isEn ? roleDescsEn : roleDescsTr)[key] ?? key;
  }
}

/// Locale-aware log string generator for use in GameProvider (no BuildContext needed).
class LogStrings {
  static String nightPlayerDied(String locale, int nightNum, String player) =>
      locale == 'en' ? 'Night $nightNum: $player died' : 'Gece $nightNum: $player \u00f6ld\u00fc';
  static String nightNobodyDied(String locale, int nightNum) =>
      locale == 'en' ? 'Night $nightNum: Nobody died' : 'Gece $nightNum: Kimse \u00f6lmedi';
  static String voteEliminated(String locale, String player) =>
      locale == 'en' ? 'Vote: $player eliminated' : 'Oylama: $player elendi';
  static String playerDied(String locale, String player) =>
      locale == 'en' ? '$player died' : '$player \u00f6ld\u00fc';
}
