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

  // Since flutter_localizations requires running flutter gen-l10n,
  // we provide a fallback implementation for Turkish strings
  // that works out of the box. When flutter gen-l10n is run,
  // this can be replaced with AppLocalizations.

  String get appTitle => 'Vampir Partisi';
  String get playerSetup => 'Oyuncu Ayarları';
  String get enterPlayerCount => 'Oyuncu sayısını girin';
  String get playerName => 'Oyuncu Adı';
  String get addPlayer => 'Ekle';
  String get removePlayer => 'Kaldır';
  String get continueButton => 'Devam Et';
  String get roleSetup => 'Rol Ayarları';
  String get totalRolesMustMatch => 'Toplam rol sayısı oyuncu sayısına eşit olmalı';
  String rolesSelected(int count) => '$count rol seçildi';
  String playersCount(int count) => '$count oyuncu';
  String get freeRoles => 'Ücretsiz Roller';
  String get premiumRoles => 'Premium Roller';
  String get locked => 'Kilitli';
  String get premiumRole => 'Premium Rol';
  String get unlockPremium => 'Premium Paketi Aç';
  String get premiumRequired => 'Bu rol için premium gerekli';
  String get nextPlayer => 'Sıradaki Oyuncu';
  String get solveMath => 'Rolünü görmek için çöz';
  String get yourRole => 'Senin Rolün';
  String get iSawIt => 'Gördüm';
  String get allPlayersSawRoles => 'Tüm oyuncular rollerini gördü';
  String get startNight => 'Herkesi Uyut (Gece Başlasın)';
  String get nightPhase => 'Gece Fazı';
  String get dayPhase => 'Gündüz Fazı';
  String get votePhase => 'Oylama Fazı';
  String get vampireSelectTarget => 'Vampir: Hedef seç';
  String get doctorSelectProtection => 'Doktor: Koruyacağın kişiyi seç';
  String get seerPeekRole => 'Kahin: Rolünü görmek istediğin kişiyi seç';
  String seerResult(String player, String role) => '$player rolü: $role';
  String get endNight => 'Geceyi Bitir';
  String playerDied(String player) => '$player öldü!';
  String get nobodyDied => 'Bu gece kimse ölmedi.';
  String get alivePlayers => 'Hayatta Kalanlar';
  String get eventLog => 'Olay Günlüğü';
  String get startVoting => 'Oylamayı Başlat';
  String get selectPlayerToEliminate => 'Elemine edilecek oyuncuyu seç';
  String get eliminate => 'Elemine Et';
  String get skip => 'Atla';
  String get villagersWin => 'Köylüler Kazandı!';
  String get vampiresWin => 'Vampirler Kazandı!';
  String get newGame => 'Yeni Oyun';
  String get settings => 'Ayarlar';
  String get soundEffects => 'Ses Efektleri';
  String get language => 'Dil';
  String get turkish => 'Türkçe';
  String get english => 'English';
  String get premiumOnly => 'Sadece Premium';
  String get restorePurchases => 'Satın Alımları Geri Yükle';
  String get purchaseRestored => 'Satın alımlar geri yüklendi';
  String get noPurchasesToRestore => 'Geri yüklenecek satın alım yok';
  String get about => 'Hakkında';
  String get version => 'Versiyon';
  String get premiumPackTitle => 'Premium Parti Paketi';
  String get premiumPackDesc => 'Tüm rolleri aç, reklamları kaldır ve İngilizce dil desteği kazan!';
  String get premiumPackPrice => 'Tek Seferlik Satın Al';
  String get purchase => 'Satın Al';
  String get alreadyPremium => 'Zaten Premium';
  String get adminPanel => 'Yönetici Paneli';
  String get controlPanel => 'Kontrol Paneli';
  String get backToSetup => 'Ayarlara Dön';
  String get confirm => 'Onayla';
  String get cancel => 'İptal';
  String get warning => 'Uyarı';
  String get ok => 'Tamam';
  String get dead => 'Öldü';
  String get alive => 'Hayatta';
  String get player => 'Oyuncu';
  String get role => 'Rol';
  String get night => 'Gece';
  String get day => 'Gündüz';
  String get enterPin => 'PIN Girin';
  String get incorrectPin => 'Yanlış PIN';
  String get adminOverrideEnabled => 'Yönetici yetkisi etkinleştirildi';

  // Role names
  String getRoleName(String key) {
    final roleNames = {
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
    return roleNames[key] ?? key;
  }

  // Role descriptions
  String getRoleDesc(String key) {
    final roleDescs = {
      'villagerDesc': 'Sıradan bir köylü. Vampirleri bul ve oy vererek eleyin.',
      'vampireDesc': 'Her gece bir kurban seç. Köylüleri azalt.',
      'doctorDesc': 'Her gece birini koru. Vampir saldırısını engelle.',
      'seerDesc': 'Her gece bir oyuncunun rolünü öğren.',
      'hunterDesc': 'Öldüğünde birini seçip öldürebilirsin.',
      'witchDesc': 'Bir kurtarma ve bir öldürme iksirin var.',
      'loversDesc': 'İki oyuncu bağlı. Biri ölürse diğeri de ölür.',
      'guardDesc': 'Her gece birini koru. Aynı kişiyi arka arkaya koruyamazsın.',
      'drunkDesc': 'Rolünü oyunun ortasına kadar bilmezsin.',
    };
    return roleDescs[key] ?? key;
  }
}
