# Vampire Party Game - Xcode & iOS Kurulum Rehberi

> MacBook'ta sifirdan Xcode kurulumu, Flutter iOS build ve App Store'a kadar tum asamalar.

---

## ICINDEKILER

1. [Onkoşullar - Mac Hazırlığı](#1-onkosullar---mac-hazirligi)
2. [Xcode Kurulumu](#2-xcode-kurulumu)
3. [Flutter iOS Ortamı](#3-flutter-ios-ortami)
4. [Projeyi Mac'e Alma](#4-projeyi-mace-alma)
5. [iOS Proje Dosyalarını Oluşturma](#5-ios-proje-dosyalarini-olusturma)
6. [Xcode'da Projeyi Açma](#6-xcodeda-projeyi-acma)
7. [Signing & Certificates (İmzalama)](#7-signing--certificates-imzalama)
8. [Simülatörde Test Etme](#8-simulatorde-test-etme)
9. [Gerçek iPhone'da Test Etme](#9-gercek-iphoneda-test-etme)
10. [AdMob Yapılandırması](#10-admob-yapılandirmasi)
11. [In-App Purchase Yapılandırması](#11-in-app-purchase-yapılandirmasi)
12. [Release Build (IPA) Oluşturma](#12-release-build-ipa-olusturma)
13. [App Store Connect'e Yükleme](#13-app-store-connecte-yukleme)
14. [Sık Karşılaşılan Hatalar](#14-sik-karsilasilan-hatalar)

---

## 1. ONKOSULLAR - MAC HAZIRLIGI

### Minimum Gereksinimler

| Gereksinim | Minimum | Önerilen |
|------------|---------|----------|
| macOS | Ventura 13.0+ | Sonoma 14.0+ veya Sequoia 15+ |
| Disk alanı | 30 GB boş | 50 GB boş |
| RAM | 8 GB | 16 GB |
| Xcode | 15.0+ | 16.0+ (en güncel) |
| Apple ID | Ücretsiz hesap | Apple Developer Program ($99/yıl) |

### Apple Developer Hesabı

- **Sadece test için**: Ücretsiz Apple ID yeterli (7 gün sertifika süresi, App Store'a yükleyemezsin)
- **App Store yayını için**: [developer.apple.com](https://developer.apple.com/programs/) - Yıllık $99 Developer Program üyeliği gerekli
- In-App Purchase ve AdMob test etmek için Developer Program **zorunlu**

---

## 2. XCODE KURULUMU

### Adım 2.1 - Xcode'u İndir

```bash
# YONTEM 1: Mac App Store'dan (önerilen)
# App Store'u aç → "Xcode" ara → "İndir" (yaklaşık 12-15 GB)

# YONTEM 2: Terminal ile
xcode-select --install
```

> **Not:** App Store'dan indirmen önerilir. Tam Xcode gerekli, sadece Command Line Tools yetmez.

### Adım 2.2 - Xcode Lisansını Kabul Et

```bash
sudo xcodebuild -license accept
```

### Adım 2.3 - Command Line Tools Kur

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### Adım 2.4 - iOS Simülatör Kur

Xcode'u aç → **Settings** (⌘,) → **Platforms** → **+** butonu → **iOS xx.x Simulator** indir

> En az bir iOS Simulator runtime indirmen gerekiyor. En güncel iOS sürümünü seç.

### Adım 2.5 - Kurulumu Doğrula

```bash
xcodebuild -version
# Beklenen çıktı: Xcode 16.x, Build version ...

xcrun simctl list devices
# Simülatör listesini gösterir
```

---

## 3. FLUTTER iOS ORTAMI

### Adım 3.1 - Flutter'ı Kur (Eğer Mac'te yoksa)

```bash
# Flutter'ı indir ve kur
# https://docs.flutter.dev/get-started/install/macos

# Homebrew ile (en kolay):
brew install --cask flutter

# veya manuel:
# 1. flutter.dev'den SDK indir
# 2. Zip'i aç, PATH'e ekle
```

### Adım 3.2 - CocoaPods Kur

```bash
# CocoaPods - iOS dependency manager (ZORUNLU)
sudo gem install cocoapods

# Eğer gem hata verirse:
brew install cocoapods
```

### Adım 3.3 - Flutter Doctor ile Kontrol

```bash
flutter doctor -v
```

**Tüm onay işaretleri (✓) yeşil olmalı:**

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain (isteğe bağlı)
[✓] Xcode - develop for iOS and macOS (Xcode 16.x)
[✓] Chrome - develop for the web
[✓] VS Code / Android Studio (isteğe bağlı)
[✓] Connected device
[✓] Network resources
```

**Eğer Xcode satırında hata varsa:**

```bash
# Genellikle bu komutlar çözer:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# CocoaPods eksikse:
sudo gem install cocoapods
```

---

## 4. PROJEYI MAC'E ALMA

### Adım 4.1 - Repoyu Klonla

```bash
cd ~/Developer   # veya istediğin klasör
git clone https://github.com/yalpyy/VampireandvillageApp.git
cd VampireandvillageApp
```

### Adım 4.2 - Flutter Bağımlılıklarını Yükle

```bash
flutter pub get
```

### Adım 4.3 - Localization Dosyalarını Oluştur

```bash
flutter gen-l10n
```

---

## 5. IOS PROJE DOSYALARINI OLUSTURMA

> **Önemli:** Şu an iOS klasöründe sadece `Info.plist` ve app ikonları var.
> Xcode proje dosyaları Flutter tarafından otomatik oluşturulacak.

### Adım 5.1 - iOS Platformunu Oluştur

```bash
# Proje kök dizininde çalıştır:
cd ~/Developer/VampireandvillageApp

# iOS proje dosyalarını oluştur
flutter create --platforms=ios .
```

> Bu komut eksik dosyaları oluşturur: `Runner.xcodeproj`, `Runner.xcworkspace`, `Podfile`, `AppDelegate.swift` vb.
> Mevcut `Info.plist` ve icon dosyalarını **korur**.

### Adım 5.2 - CocoaPods Bağımlılıklarını Yükle

```bash
cd ios
pod install
cd ..
```

**Eğer pod install hata verirse:**

```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

### Adım 5.3 - Oluşturulan Yapıyı Doğrula

```bash
ls ios/
```

**Şu dosya/klasörler oluşmuş olmalı:**

```
ios/
├── Runner.xcodeproj/          ← Xcode proje dosyası
├── Runner.xcworkspace/        ← Xcode workspace (BUNU AÇ)
├── Podfile                    ← CocoaPods bağımlılık dosyası
├── Podfile.lock
├── Pods/                      ← İndirilen iOS kütüphaneleri
├── Runner/
│   ├── AppDelegate.swift      ← iOS uygulama giriş noktası
│   ├── GeneratedPluginRegistrant.m
│   ├── Info.plist             ← Uygulama yapılandırması (mevcut)
│   ├── Runner-Bridging-Header.h
│   └── Assets.xcassets/       ← Uygulama ikonları (mevcut)
│       ├── AppIcon.appiconset/
│       └── LaunchImage.imageset/
└── Flutter/
    ├── Debug.xcconfig
    ├── Release.xcconfig
    └── AppFrameworkInfo.plist
```

---

## 6. XCODE'DA PROJEYI ACMA

### Adım 6.1 - Workspace'i Aç

```bash
# ÖNEMLİ: .xcworkspace dosyasını aç, .xcodeproj DEĞİL!
open ios/Runner.xcworkspace
```

> **Neden .xcworkspace?** CocoaPods kullandığımız için workspace açılmalı.
> `.xcodeproj` açarsan pod'lar (google_mobile_ads, audioplayers vb.) bulunamaz.

### Adım 6.2 - Xcode Arayüzünü Tanı

Xcode açıldığında şu bölümleri göreceksin:

```
┌──────────────────────────────────────────────────────┐
│  ▶ Run   ⏹ Stop   │ Runner > iPhone 16 Pro │ Status │  ← Toolbar
├──────┬───────────────────────────────────────────────┤
│      │                                               │
│ Nav  │              Editor Area                      │
│ Bar  │         (Kod/Ayarlar burada görünür)          │
│      │                                               │
│ Runner│                                              │
│ ├ Runner                                             │
│ ├ Pods                                               │
│ └ Products                                           │
│      │                                               │
├──────┴───────────────────────────────────────────────┤
│                   Debug Console                       │  ← Alt panel
└──────────────────────────────────────────────────────┘
```

### Adım 6.3 - Proje Ayarlarını Kontrol Et

1. Sol panelde **Runner** (mavi ikon) tıkla
2. Ortada **TARGETS** altında **Runner** seç
3. **General** sekmesi:

| Ayar | Değer |
|------|-------|
| Display Name | `Vampir Partisi` |
| Bundle Identifier | `com.seninfirman.vampirepartisi` (kendi ID'ni koy) |
| Version | `1.0.0` |
| Build | `1` |
| Minimum Deployments | `iOS 13.0` (veya `iOS 14.0` önerilir) |

### Adım 6.4 - Minimum iOS Sürümünü Ayarla

**Podfile'da** (ios/Podfile):

```ruby
# Bu satırı bul ve güncelle:
platform :ios, '14.0'
```

> iOS 14.0 önerilir çünkü App Tracking Transparency (ATT) iOS 14+ gerektirir.

Değiştirdikten sonra:

```bash
cd ios && pod install && cd ..
```

---

## 7. SIGNING & CERTIFICATES (IMZALAMA)

> Bu adım iPhone'da test ve App Store yayını için **zorunlu**.

### Adım 7.1 - Apple ID'ni Xcode'a Ekle

1. Xcode → **Settings** (⌘,) → **Accounts** sekmesi
2. Sol altta **+** → **Apple ID** seç
3. Apple ID ve şifreni gir
4. Hesabın listede görünecek

### Adım 7.2 - Automatic Signing Aç

1. Sol panelde **Runner** (mavi ikon) tıkla
2. **TARGETS** → **Runner** → **Signing & Capabilities** sekmesi
3. **Automatically manage signing** kutusunu işaretle ✓
4. **Team** dropdown'dan Apple ID hesabını seç
5. **Bundle Identifier** alanına benzersiz bir ID yaz:
   ```
   com.senismin.vampirpartisi
   ```

> Xcode otomatik olarak Development sertifikası ve Provisioning Profile oluşturacak.

### Adım 7.3 - Capabilities Ekle (Gerekirse)

**Signing & Capabilities** sekmesinde **+ Capability** butonuyla:

- **In-App Purchase** → Ekle (premium_party_pack için gerekli)
- Push Notifications → Gerekmez (bu projede yok)

---

## 8. SIMULATORDE TEST ETME

### Adım 8.1 - Simülatör Seç

1. Xcode üst toolbar'da cihaz seçici dropdown'a tıkla
2. **iOS Simulators** altından bir cihaz seç (ör: **iPhone 16 Pro**)

### Adım 8.2 - Çalıştır

**Yöntem 1 - Xcode ile:**
- ▶ (Play) butonuna bas veya **⌘R**
- İlk build 3-5 dakika sürebilir

**Yöntem 2 - Terminal ile (önerilen):**

```bash
# Simülatörde çalıştır
flutter run -d ios

# Belirli bir simülatör seç
flutter devices                    # Mevcut cihazları listele
flutter run -d "iPhone 16 Pro"     # Belirli simülatörde çalıştır
```

### Adım 8.3 - Hot Reload & Hot Restart

Uygulama çalışırken terminal'de:
- **r** tuşu → Hot Reload (değişiklikleri anında yükle)
- **R** tuşu → Hot Restart (uygulamayı yeniden başlat)
- **q** tuşu → Durdur

---

## 9. GERCEK IPHONE'DA TEST ETME

### Adım 9.1 - iPhone'u Hazırla

1. iPhone'u USB kabloyla Mac'e bağla
2. iPhone'da **Ayarlar → Gizlilik ve Güvenlik → Geliştirici Modu** → Aç
3. iPhone'da "Bu bilgisayara güvenin" sorusuna **Güven** de

### Adım 9.2 - Xcode'da iPhone'u Seç

1. Üst toolbar'da cihaz dropdown → bağlı iPhone'un görünecek
2. iPhone'u seç

### Adım 9.3 - Çalıştır

```bash
flutter run -d <iphone-id>
# veya
flutter run   # Bağlı tek cihaz varsa otomatik seçer
```

**İlk seferde iPhone'da:**
1. Uygulama yüklenecek ama "Güvenilmeyen Geliştirici" hatası çıkabilir
2. iPhone → **Ayarlar → Genel → VPN ve Aygıt Yönetimi**
3. Geliştirici hesabına tıkla → **Güven** de
4. Uygulamayı tekrar aç

---

## 10. ADMOB YAPILANDIRMASI

### Mevcut Durum

Projede **TEST** AdMob ID'leri kullanılıyor. Yayın öncesi gerçek ID'lerle değiştirilmeli.

### Adım 10.1 - Test ID'leri (Geliştirme İçin)

Şu an kullanılan test ID'leri:

| Tür | Test ID |
|-----|---------|
| iOS App ID | `ca-app-pub-3940256099942544~1458002511` |
| iOS Banner | `ca-app-pub-3940256099942544/2934735716` |
| iOS Interstitial | `ca-app-pub-3940256099942544/4411468910` |

> Test ID'leriyle geliştirme yaparken gerçek reklam görünmez, test reklamları görünür. Bu normaldir.

### Adım 10.2 - Gerçek ID'lere Geçiş (Yayın Öncesi)

1. [admob.google.com](https://admob.google.com) → Yeni uygulama ekle
2. iOS platformu seç
3. Oluşturulan gerçek ID'leri şu dosyalarda güncelle:

**Dosya 1:** `ios/Runner/Info.plist`
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-SENIN_GERCEK_APP_ID</string>
```

**Dosya 2:** `lib/services/ad_service.dart`
```dart
static const String iosBannerAdUnitId = 'ca-app-pub-SENIN_ID/BANNER_ID';
static const String iosInterstitialAdUnitId = 'ca-app-pub-SENIN_ID/INTERSTITIAL_ID';
```

---

## 11. IN-APP PURCHASE YAPILANDIRMASI

### Adım 11.1 - App Store Connect'te Ürün Oluştur

1. [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → Uygulamalar
2. Uygulamanı oluştur/seç
3. Sol menüde **Özellikler** → **Uygulama İçi Satın Alma Öğeleri**
4. **+** butonuyla yeni ürün ekle:

| Alan | Değer |
|------|-------|
| Tür | Non-Consumable (Tüketilemeyen) |
| Referans Adı | Premium Party Pack |
| Ürün Kimliği | `premium_party_pack` |
| Fiyat | Belirlediğin fiyat (ör: $2.99) |

### Adım 11.2 - Sandbox Test Hesabı

1. App Store Connect → **Kullanıcılar ve Erişim** → **Sandbox** sekmesi
2. **Test Hesabı** ekle (test için sahte Apple ID)
3. iPhone'da **Ayarlar → App Store → Sandbox Hesabı** kısmına bu hesabı gir

---

## 12. RELEASE BUILD (IPA) OLUSTURMA

### Adım 12.1 - Yayın Öncesi Kontrol Listesi

- [ ] Bundle Identifier benzersiz ve doğru
- [ ] Version ve Build numarası güncel
- [ ] AdMob ID'leri gerçek ID'lerle değiştirildi
- [ ] App ikonları tüm boyutlarda mevcut (43 ikon - zaten var ✓)
- [ ] Info.plist'te tüm izin açıklamaları Türkçe yazılmış ✓
- [ ] SKAdNetwork ID'leri güncel ✓
- [ ] Team ve Signing doğru yapılandırılmış
- [ ] In-App Purchase Capability eklenmiş

### Adım 12.2 - Release Build

```bash
# Temiz build (önerilir)
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Release build
flutter build ios --release
```

### Adım 12.3 - Xcode'dan Archive Oluştur

1. Xcode'da cihaz olarak **Any iOS Device (arm64)** seç
2. Menü: **Product → Archive** (⌘ Shift B ile build, sonra Product → Archive)
3. Archive tamamlandığında **Organizer** penceresi açılır
4. **Distribute App** butonuna tıkla

### Adım 12.4 - Archive Alternatif (Terminal)

```bash
flutter build ipa --release
```

> Bu komut `build/ios/ipa/` klasörüne `.ipa` dosyası oluşturur.

---

## 13. APP STORE CONNECT'E YUKLEME

### Adım 13.1 - Xcode Organizer ile

1. Archive sonrası **Distribute App** tıkla
2. **App Store Connect** seç → **Upload**
3. Signing seçeneklerini onayla
4. **Upload** tıkla
5. 5-10 dakika bekle (Apple sunucularına yüklenir)

### Adım 13.2 - Terminal ile (Alternatif)

```bash
# xcrun ile yükle
xcrun altool --upload-app --type ios \
  --file build/ios/ipa/vampire_party_game.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

### Adım 13.3 - App Store Connect'te Yayınla

1. [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Uygulamanı seç → Build yüklendiğini doğrula
3. Gerekli bilgileri doldur:
   - Ekran görüntüleri (6.7", 6.5", 5.5" ve iPad)
   - Açıklama (Türkçe + İngilizce)
   - Anahtar kelimeler
   - Gizlilik politikası URL'si
   - Yaş sınıflandırması
   - İletişim bilgileri
4. **İncelemeye Gönder** butonuna tıkla
5. Apple incelemesi genellikle 24-48 saat sürer

---

## 14. SIK KARSILASILAN HATALAR

### Hata: "No Provisioning Profile"

```
Signing for "Runner" requires a development team.
```

**Çözüm:** Xcode → Runner → Signing & Capabilities → Team seç

---

### Hata: "CocoaPods not installed"

```
CocoaPods not installed or not in valid state.
```

**Çözüm:**
```bash
sudo gem install cocoapods
# veya
brew install cocoapods
```

---

### Hata: "Module not found" (google_mobile_ads vb.)

```
No such module 'google_mobile_ads'
```

**Çözüm:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

---

### Hata: "Minimum deployment target"

```
The iOS deployment target is set to X.0, but the range of supported deployment
target versions is Y.0 to Z.0
```

**Çözüm:** `ios/Podfile` dosyasında:
```ruby
platform :ios, '14.0'
```
Sonra: `cd ios && pod install && cd ..`

---

### Hata: "Unable to boot device in current state"

**Çözüm:**
```bash
# Simülatörleri sıfırla
xcrun simctl shutdown all
xcrun simctl erase all
```

---

### Hata: Build süresi çok uzun

**Çözüm:**
```bash
# DerivedData temizle
rm -rf ~/Library/Developer/Xcode/DerivedData

# Flutter temizle
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

---

### Hata: "Untrusted Developer" (iPhone'da)

**Çözüm:** iPhone → Ayarlar → Genel → VPN ve Aygıt Yönetimi → Geliştirici hesabına güven

---

### Hata: audioplayers ses çalmıyor (Simülatörde)

Simülatörde ses sorunları olabilir, bu normaldir. Gerçek cihazda test et.

---

## HIZLI REFERANS - EN COK KULLANILAN KOMUTLAR

```bash
# Projeyi simülatörde çalıştır
flutter run -d ios

# Bağlı cihazları listele
flutter devices

# iOS release build
flutter build ios --release

# IPA oluştur
flutter build ipa --release

# Pod'ları yeniden yükle
cd ios && pod install --repo-update && cd ..

# Temiz build
flutter clean && flutter pub get && cd ios && pod install && cd ..

# Flutter durumunu kontrol et
flutter doctor -v

# Simülatör aç
open -a Simulator
```

---

## PROJE DOSYA HARITASI

```
VampireandvillageApp/
├── lib/                           ← Dart/Flutter kaynak kodu
│   ├── main.dart                  ← Uygulama giriş noktası
│   ├── screens/                   ← Tüm ekranlar
│   ├── providers/                 ← State management
│   ├── models/                    ← Veri modelleri
│   ├── services/
│   │   ├── ad_service.dart        ← AdMob ID'leri BURADA
│   │   ├── ad_service_mobile.dart ← iOS/Android reklam kodu
│   │   ├── purchase_service.dart  ← IAP yapılandırması
│   │   └── sound_service.dart     ← Ses efektleri
│   ├── utils/
│   │   ├── att_helper_mobile.dart ← iOS Tracking izni
│   │   └── app_theme.dart         ← Tema renkleri
│   └── l10n/                      ← Dil dosyaları (TR/EN)
├── ios/                           ← iOS PROJE DOSYALARI
│   ├── Runner.xcworkspace/        ← BUNU AÇ (Xcode'da)
│   ├── Runner/
│   │   ├── Info.plist             ← iOS yapılandırma + AdMob App ID
│   │   └── Assets.xcassets/       ← App ikonları (43 boyut)
│   ├── Podfile                    ← iOS bağımlılıkları
│   └── Pods/                      ← Yüklenen iOS kütüphaneleri
├── assets/
│   ├── images/                    ← Arka plan görselleri
│   └── sounds/                    ← Ses efektleri (mp3)
├── pubspec.yaml                   ← Flutter bağımlılıkları
└── Xcode.md                      ← Bu dosya
```
