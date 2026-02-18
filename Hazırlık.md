# iOS Test & Yayinlama Hazirlik Checklist

## 1. Apple Developer Hesap Ayarlari
- [ ] Apple Developer Program hesabi aktif ($99/yil)
- [ ] App Store Connect'te uygulama olusturuldu
- [ ] Bundle ID tanimli: `ios/Runner.xcodeproj` icindeki `PRODUCT_BUNDLE_IDENTIFIER` gercek degerle degistirildi
- [ ] Team ID ve Signing Certificate ayarlandi (Xcode > Signing & Capabilities)
- [ ] Provisioning Profile olusturuldu (Development + Distribution)

## 2. Xcode Proje Ayarlari
- [ ] `ios/Runner.xcodeproj` Xcode'da acildi ve hatasiz build oluyor
- [ ] Minimum iOS Deployment Target belirlendi (iOS 14.0 onerilen - ATT icin)
- [ ] Device Orientation sadece Portrait olarak sinirlandirildi (parti oyunu icin)
  - Info.plist'te simdi Landscape da var - sadece Portrait kalmali
- [ ] App Icon (1024x1024) `ios/Runner/Assets.xcassets/AppIcon.appiconset/` icine eklendi
  - Tum boyutlar mevcut olmali (20pt, 29pt, 40pt, 58pt, 60pt, 76pt, 80pt, 87pt, 120pt, 152pt, 167pt, 180pt, 1024pt)
- [ ] Launch Screen / Splash Screen duzenle (`ios/Runner/LaunchScreen.storyboard`)

## 3. AdMob Konfigurasyonu
- [ ] **KRITIK:** Info.plist'teki `GADApplicationIdentifier` test ID'den gercek ID'ye degistirildi
  - Simdi test: `ca-app-pub-3940256099942544~1458002511`
  - Gercek AdMob App ID ile degistir
- [ ] AdMob hesabinda uygulama olusturuldu ve onaylandi
- [ ] Banner Ad Unit ID olusturuldu - `lib/services/ad_service.dart` guncellendi
- [ ] Interstitial Ad Unit ID olusturuldu - `lib/services/ad_service.dart` guncellendi
- [ ] Test cihazlarinda reklamlar dogru gorunuyor

## 4. In-App Purchase (Satin Alma)
- [ ] App Store Connect'te In-App Purchase urunu olusturuldu
  - Tip: Non-Consumable (tek seferlik Premium)
  - Product ID: `lib/services/purchase_service.dart` icindeki ID ile eslestirildi
- [ ] Sandbox test hesabi olusturuldu
- [ ] Satin alma akisi test edildi (Sandbox ortaminda)
- [ ] Restore Purchases calisiyor
- [ ] Premium ozelliklerin kilidi satin alma sonrasi aciliyor

## 5. App Tracking Transparency (ATT)
- [ ] Info.plist'te `NSUserTrackingUsageDescription` mesaji dogru ve Turkce
  - **NOT:** Ingilizce ceviri de eklenmeli (Localizations ile)
- [ ] iOS 14+ cihazlarda ATT popup gorunuyor
- [ ] Kullanici reddettikten sonra uygulama normal calismaya devam ediyor
- [ ] `att_helper.dart` calisma durumu test edildi

## 6. Lokalizasyon Kontrolu
- [x] Turkce tum ekranlarda calisiyor
- [x] Ingilizce tum ekranlarda calisiyor
- [x] Dil degisikligi aninda uygulanabiliyor (Settings ekrani)
- [x] Rol isimleri ve aciklamalari iki dilde mevcut
- [x] Terms/KVKK ekrani iki dilde calisiyor
- [ ] Info.plist `CFBundleDisplayName` dil destegiyle coklu eklenmeli (Localizable.strings)
- [ ] ATT mesaji icin InfoPlist.strings dosyasi eklenmeli (EN + TR)

## 7. Ses ve Asset Kontrolu
- [x] `assets/sounds/rooster_crow.mp3` mevcut
- [ ] Tum ses dosyalari (`wolf_howl`, `death`, `vote_start`, `day_start`, `times_up`, `game_end`) assets/sounds/ icinde mevcut
- [ ] Ses dosyalarinin boyutlari makul (toplam <5MB onerilen)
- [ ] `assets/images/Homebackground_new.jpeg` mevcut
- [ ] `assets/images/app_icon.png` mevcut
- [ ] `assets/images/moderator_background.png` mevcut veya errorBuilder calisiyor

## 8. UI/UX Test Checklist
- [ ] iPhone SE (kucuk ekran) - tum ekranlar tasiyor, metin kesmiyor
- [ ] iPhone 15 Pro (standart ekran) - layout dogru
- [ ] iPhone 15 Pro Max (buyuk ekran) - layout dogru
- [ ] iPad - landscape/portrait gorunumu kabul edilebilir
- [ ] Safe Area tum ekranlarda dogru (notch, Dynamic Island)
- [ ] Dark mode / Light mode cakismasi yok (uygulama kendi temasini kullaniyor)
- [ ] Klavye acildiginda input alanlari gorunuyor (Player Setup)

## 9. Oyun Akisi Test
- [ ] Ana Ekran > Player Setup > Role Setup > Role Reveal > Moderator akisi sorunsuz
- [ ] 3 oyuncuyla minimum oyun testi
- [ ] 8+ oyuncuyla buyuk oyun testi
- [ ] Vampirler kazanma senaryosu test
- [ ] Koylular kazanma senaryosu test
- [ ] Tum roller (Doktor, Kahin, Avci, Cadi, Asiklar, Muhafiz, Sarhos) test
- [ ] Moderator timer calisiyor (30s, 60s, 90s, 120s)
- [ ] Gece/Gunduz gecisleri sorunsuz
- [ ] Oylama sonrasi dogru navigasyon
- [ ] Oyun sonu ekrani dogru gosteriyor
- [ ] Yeni Oyun butonu oyunu sifirliyor

## 10. Performans ve Kararllik
- [ ] `flutter build ios --release` hatasiz tamamlaniyor
- [ ] Release modda uygulama crash olmuyor
- [ ] Memory leak kontrolu (uzun oyun seanslari)
- [ ] Uygulama arka plana atilip geri donunce durum korunuyor

## 11. App Store Connect Hazirlik
- [ ] Uygulama adi: "Vampir Partisi - Party Game" (veya benzeri)
- [ ] Alt baslik (subtitle): "Offline Vampire Party Game"
- [ ] Aciklama (TR + EN)
- [ ] Anahtar kelimeler: vampir, parti, oyun, werewolf, village, gece, koy, rol
- [ ] Kategori: Games > Party
- [ ] Yas sinifi: 12+ (orta duzeyde korku temalari)
- [ ] Ekran goruntuleri hazir:
  - [ ] 6.7" (iPhone 15 Pro Max) - en az 3 screenshot
  - [ ] 6.1" (iPhone 15 Pro) - en az 3 screenshot
  - [ ] 5.5" (iPhone 8 Plus) - en az 3 screenshot (opsiyonel)
  - [ ] iPad Pro 12.9" - en az 3 screenshot (opsiyonel)
- [ ] App Preview video (opsiyonel ama onerilen)
- [ ] Gizlilik Politikasi URL'si: App Store Connect'e eklendi
- [ ] Destek URL'si eklendi

## 12. Gizlilik ve Yasal
- [ ] Privacy Policy sayfasi canli URL'de yayinda
  - URL: `https://vampireparty.github.io/privacy-policy` (veya kendi domaininiz)
- [ ] App Privacy Labels (Data Collection) App Store Connect'te dolduruldu:
  - Data Used to Track You: Device ID (AdMob)
  - Data Linked to You: Purchases
  - Data Not Linked to You: Diagnostics
- [ ] KVKK aydinlatma metni uygulama icinde mevcut (Terms ekrani)

## 13. Son Kontroller
- [ ] `flutter clean && flutter pub get` sonrasi temiz build
- [ ] `flutter analyze` hata vermiyor
- [ ] `flutter test` (varsa testler) geciyor
- [ ] Version numarasi guncellendi: `pubspec.yaml` > version: 1.0.0+1
- [ ] Git'e tum degisiklikler commit edildi
- [ ] Archive & Upload to App Store Connect
- [ ] TestFlight'a build yuklendi
- [ ] Internal test grubu ile test yapildi
- [ ] Review'a gonderildi

---

## Eksikler ve Yapilacaklar (Oncelik Sirasina Gore)

### YUKSEK ONCELIK
1. **AdMob gercek ID'ler** - Test ID'leri gercek ID'lerle degistir
2. **In-App Purchase Product ID** - App Store Connect'te urun olustur, kodu esle
3. **App Icon** - Tum iOS boyutlarinda icon asset'leri olustur
4. **Bundle ID** - Gercek bundle identifier belirle ve Xcode'da ayarla
5. **Signing** - Apple Developer Certificate ve Provisioning Profile ayarla

### ORTA ONCELIK
6. **Orientation Lock** - Info.plist'ten Landscape kaldirarak sadece Portrait yap
7. **Launch Screen** - Splash screen gorseli olustur
8. **Privacy Policy URL** - Canli bir gizlilik politikasi sayfasi olustur
9. **ATT mesaji Ingilizce cevirisi** - InfoPlist.strings ile lokalize et
10. **Ses dosyalari kontrolu** - Tum ses asset'lerinin mevcut oldugunu dogrula

### DUSUK ONCELIK
11. **iPad uyumluluk** - iPad layoutlarini test et
12. **App Store screenshots** - Ekran goruntuleri ve tanitim materyalleri hazirla
13. **App Store aciklama** - TR/EN magaza aciklamasi yaz
14. **TestFlight** - Beta test grubu olustur
