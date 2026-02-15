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

  String get appTitle => _isEn ? 'Vampire Party' : 'Vampir Partisi';
  String get playerSetup => _isEn ? 'Player Setup' : 'Oyuncu Ayarları';
  String get enterPlayerCount => _isEn ? 'Enter player count' : 'Oyuncu sayısını girin';
  String get playerName => _isEn ? 'Player Name' : 'Oyuncu Adı';
  String get addPlayer => _isEn ? 'Add' : 'Ekle';
  String get removePlayer => _isEn ? 'Remove' : 'Kaldır';
  String get continueButton => _isEn ? 'Continue' : 'Devam Et';
  String get roleSetup => _isEn ? 'Role Setup' : 'Rol Ayarları';
  String get totalRolesMustMatch => _isEn ? 'Total roles must match player count' : 'Toplam rol sayısı oyuncu sayısına eşit olmalı';
  String rolesSelected(int count) => _isEn ? '$count roles selected' : '$count rol seçildi';
  String playersCount(int count) => _isEn ? '$count players' : '$count oyuncu';
  String get freeRoles => _isEn ? 'Free Roles' : 'Ücretsiz Roller';
  String get premiumRoles => _isEn ? 'Premium Roles' : 'Premium Roller';
  String get locked => _isEn ? 'Locked' : 'Kilitli';
  String get premiumRole => _isEn ? 'Premium Role' : 'Premium Rol';
  String get unlockPremium => _isEn ? 'Unlock Premium' : 'Premium Paketi Aç';
  String get premiumRequired => _isEn ? 'Premium required for this role' : 'Bu rol için premium gerekli';
  String get nextPlayer => _isEn ? 'Next Player' : 'Sıradaki Oyuncu';
  String get solveMath => _isEn ? 'Solve to see your role' : 'Rolünü görmek için çöz';
  String get yourRole => _isEn ? 'Your Role' : 'Senin Rolün';
  String get iSawIt => _isEn ? 'I Saw It' : 'Gördüm';
  String get allPlayersSawRoles => _isEn ? 'All players saw their roles' : 'Tüm oyuncular rollerini gördü';
  String get startNight => _isEn ? 'Put Everyone to Sleep (Start Night)' : 'Herkesi Uyut (Gece Başlasın)';
  String get nightPhase => _isEn ? 'Night Phase' : 'Gece Fazı';
  String get dayPhase => _isEn ? 'Day Phase' : 'Gündüz Fazı';
  String get votePhase => _isEn ? 'Voting Phase' : 'Oylama Fazı';
  String get vampireSelectTarget => _isEn ? 'Vampire: Select target' : 'Vampir: Hedef seç';
  String get doctorSelectProtection => _isEn ? 'Doctor: Select who to protect' : 'Doktor: Koruyacağın kişiyi seç';
  String get seerPeekRole => _isEn ? 'Seer: Select who to peek at' : 'Kahin: Rolünü görmek istediğin kişiyi seç';
  String seerResult(String player, String role) => _isEn ? '$player\'s role: $role' : '$player rolü: $role';
  String get endNight => _isEn ? 'End Night' : 'Geceyi Bitir';
  String playerDied(String player) => _isEn ? '$player died!' : '$player öldü!';
  String get nobodyDied => _isEn ? 'Nobody died tonight.' : 'Bu gece kimse ölmedi.';
  String get alivePlayers => _isEn ? 'Alive Players' : 'Hayatta Kalanlar';
  String get eventLog => _isEn ? 'Event Log' : 'Olay Günlüğü';
  String get startVoting => _isEn ? 'Start Voting' : 'Oylamayı Başlat';
  String get selectPlayerToEliminate => _isEn ? 'Select a player to eliminate' : 'Elemine edilecek oyuncuyu seç';
  String get eliminate => _isEn ? 'Eliminate' : 'Elemine Et';
  String get skip => _isEn ? 'Skip' : 'Atla';
  String get villagersWin => _isEn ? 'Villagers Win!' : 'Köylüler Kazandı!';
  String get vampiresWin => _isEn ? 'Vampires Win!' : 'Vampirler Kazandı!';
  String get newGame => _isEn ? 'New Game' : 'Yeni Oyun';
  String get settings => _isEn ? 'Settings' : 'Ayarlar';
  String get soundEffects => _isEn ? 'Sound Effects' : 'Ses Efektleri';
  String get language => _isEn ? 'Language' : 'Dil';
  String get turkish => 'Türkçe';
  String get english => 'English';
  String get premiumOnly => _isEn ? 'Premium Only' : 'Sadece Premium';
  String get restorePurchases => _isEn ? 'Restore Purchases' : 'Satın Alımları Geri Yükle';
  String get purchaseRestored => _isEn ? 'Purchases restored' : 'Satın alımlar geri yüklendi';
  String get noPurchasesToRestore => _isEn ? 'No purchases to restore' : 'Geri yüklenecek satın alım yok';
  String get about => _isEn ? 'About' : 'Hakkında';
  String get version => _isEn ? 'Version' : 'Versiyon';
  String get premiumPackTitle => _isEn ? 'Premium Party Pack' : 'Premium Parti Paketi';
  String get premiumPackDesc => _isEn ? 'Unlock all roles, remove ads!' : 'Tüm rolleri aç, reklamları kaldır!';
  String get premiumPackPrice => _isEn ? 'Buy Once' : 'Tek Seferlik Satın Al';
  String get purchase => _isEn ? 'Purchase' : 'Satın Al';
  String get alreadyPremium => _isEn ? 'Already Premium' : 'Zaten Premium';
  String get adminPanel => _isEn ? 'Admin Panel' : 'Yönetici Paneli';
  String get controlPanel => _isEn ? 'Control Panel' : 'Kontrol Paneli';
  String get backToSetup => _isEn ? 'Back to Setup' : 'Ayarlara Dön';
  String get confirm => _isEn ? 'Confirm' : 'Onayla';
  String get cancel => _isEn ? 'Cancel' : 'İptal';
  String get warning => _isEn ? 'Warning' : 'Uyarı';
  String get ok => _isEn ? 'OK' : 'Tamam';
  String get dead => _isEn ? 'Dead' : 'Öldü';
  String get alive => _isEn ? 'Alive' : 'Hayatta';
  String get player => _isEn ? 'Player' : 'Oyuncu';
  String get role => _isEn ? 'Role' : 'Rol';
  String get night => _isEn ? 'Night' : 'Gece';
  String get day => _isEn ? 'Day' : 'Gündüz';
  String get enterPin => _isEn ? 'Enter PIN' : 'PIN Girin';
  String get incorrectPin => _isEn ? 'Incorrect PIN' : 'Yanlış PIN';
  String get adminOverrideEnabled => _isEn ? 'Admin override enabled' : 'Yönetici yetkisi etkinleştirildi';
  String get privacyPolicy => _isEn ? 'Privacy Policy' : 'Gizlilik Politikası';
  String get termsOfUse => _isEn ? 'Terms of Use' : 'Kullanım Koşulları';
  String get guardSelectProtection => _isEn ? 'Guard: Select who to protect' : 'Muhafız: Koruyacağın kişiyi seç';

  // Role names
  String getRoleName(String key) {
    final roleNamesTr = {
      'villager': 'Köylü',
      'vampire': 'Vampir',
      'doctor': 'Doktor',
      'seer': 'Kahin',
      'hunter': 'Avcı',
      'witch': 'Cadı',
      'lovers': 'Aşıklar',
      'guard': 'Muhafız',
      'drunk': 'Sarhoş',
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

  // Role descriptions
  String getRoleDesc(String key) {
    final roleDescsTr = {
      'villagerDesc': 'Sıradan bir köylü. Vampirleri bul ve oy vererek eleyin.',
      'vampireDesc': 'Her gece bir kurban seç. Köylüleri azalt.',
      'doctorDesc': 'Her gece birini koru. Vampir saldırısını engelle.',
      'seerDesc': 'Her gece bir oyuncunun rolünü öğren.',
      'hunterDesc': 'Öldüğünde birini seçip öldürebilirsin.',
      'witchDesc': 'Bir kurtarma ve bir öldürme iksirin var.',
      'loversDesc': 'İki oyuncu bağlı. Biri ölürse diğeri de ölür.',
      'guardDesc': 'Her gece birini koru. Aynı kişiyi arka arkaya koruyamazsın.',
      'drunkDesc': 'Gece kafasından bir rol seçer ve o rol gibi davranır. Ancak bu seçim tamamen kendi hayal gücüne dayanır.',
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
