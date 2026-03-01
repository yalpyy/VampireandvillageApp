# Vampire Party Game - Xcode & iOS Kurulum Rehberi

> MacBook Pro 2017 + macOS 13 Ventura + Flutter 3.22.3 + Xcode

---

## UYUMLULUK TABLOSU

| Bilesen | Surum | Not |
|---------|-------|-----|
| macOS | 13 Ventura | Yukseltme GEREKMEZ |
| Xcode | 15.2 | macOS 13 ile uyumlu son surum |
| Flutter | 3.22.3 (stable) | Manuel SDK kurulumu |
| Dart | 3.4.4 (bundled) | Flutter ile birlikte gelir |
| CocoaPods | 1.15+ | gem veya brew ile |
| iOS target | 14.0 | ATT icin minimum |
| Ruby | Sistem Ruby | macOS ile birlikte gelir |

---

## HIZLI KURULUM (Tek Script)

Tum adimlari otomatik yapan script:

```bash
cd ~/Developer/VampireandvillageApp
chmod +x scripts/setup_ios.sh
./scripts/setup_ios.sh
```

Script su islemleri yapar:
1. Xcode ve CocoaPods kontrol
2. Flutter 3.22.3 indir ve kur
3. Projeyi temizle, dependency'leri yukle
4. iOS klasorunu sil ve yeniden olustur
5. Info.plist ve ikonlari yedekle/geri yukle
6. Podfile'i yapilandir (iOS 14.0)
7. pod install calistir
8. Runner.xcworkspace olusturulmus mu dogrula

Asagida her adimin manuel aciklamasi var.

---

## ADIM 1: XCODE 15.2 KURULUMU

macOS 13 Ventura icin Xcode 15.2 son uyumlu surumdur. Xcode 16+ macOS 14 gerektirir.

### 1.1 - Xcode'u Indir

```bash
# Mac App Store'dan "Xcode" ara ve yukle
# VEYA developer.apple.com/download/more/ adresinden Xcode 15.2 indir
```

### 1.2 - Lisans ve CLI Tools

```bash
sudo xcodebuild -license accept
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 1.3 - iOS Simulator Kur

```bash
# Xcode → Settings (⌘,) → Platforms → + → iOS 17.2 Simulator indir
```

### 1.4 - Dogrula

```bash
xcodebuild -version
# Beklenen: Xcode 15.2

xcrun simctl list devices available
```

---

## ADIM 2: COCOAPODS KURULUMU

```bash
sudo gem install cocoapods
```

Eger hata verirse:

```bash
brew install cocoapods
```

Dogrula:

```bash
pod --version
# Beklenen: 1.15.x veya ustu
```

---

## ADIM 3: FLUTTER 3.22.3 KURULUMU (Manuel SDK)

Homebrew KULLANMA. Manuel SDK kurulumu gerekli.

### 3.1 - Mevcut Flutter'i Kontrol Et

```bash
which flutter
flutter --version 2>/dev/null
```

Eger farkli bir surum veya Homebrew ile kuruluysa, o surumu kaldirmaya gerek yok. Yeni SDK PATH'te onde olacak.

### 3.2 - Flutter 3.22.3 Indir

```bash
# Apple Silicon (M1/M2) icin:
curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.22.3-stable.zip

# Intel Mac icin (MacBook Pro 2017):
curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.22.3-stable.zip
```

### 3.3 - Cikar ve Kur

```bash
# Mevcut flutter klasoru varsa yedekle
[ -d "$HOME/flutter" ] && mv "$HOME/flutter" "$HOME/flutter_backup_$(date +%s)"

# Cikar
unzip -qo flutter_macos_*3.22.3*.zip -d "$HOME"
rm -f flutter_macos_*3.22.3*.zip
```

### 3.4 - PATH'e Ekle

```bash
# .zshrc'ye ekle (macOS varsayilan shell zsh)
echo '' >> ~/.zshrc
echo '# Flutter SDK' >> ~/.zshrc
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc

# Aktif terminalde hemen kullan
export PATH="$HOME/flutter/bin:$PATH"
```

### 3.5 - Dogrula

```bash
flutter --version
```

Beklenen cikti:

```
Flutter 3.22.3 • channel stable
Framework • revision xxxxxxxxxx
Engine • revision xxxxxxxxxx
Tools • Dart 3.4.4 • DevTools 2.34.3
```

### 3.6 - Flutter Doctor

```bash
flutter doctor -v
```

Beklenen:

```
[✓] Flutter (Channel stable, 3.22.3)
[✓] Xcode - develop for iOS and macOS (Xcode 15.2)
[✓] Chrome - develop for the web
[✓] Connected device
[✓] Network resources
```

Xcode satirinda hata varsa:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

---

## ADIM 4: PROJEYI MAC'E ALMA

### 4.1 - Klonla

```bash
mkdir -p ~/Developer
cd ~/Developer
git clone https://github.com/yalpyy/VampireandvillageApp.git
cd VampireandvillageApp
```

### 4.2 - Dependency'leri Yukle

```bash
flutter clean
rm -f pubspec.lock
flutter pub get
```

### 4.3 - Localization Dosyalari

```bash
flutter gen-l10n
```

---

## ADIM 5: iOS PROJE DOSYALARINI OLUSTURMA

### 5.1 - Mevcut Dosyalari Yedekle

```bash
cd ~/Developer/VampireandvillageApp

# Info.plist ve ikonlari yedekle
mkdir -p /tmp/ios_backup
cp ios/Runner/Info.plist /tmp/ios_backup/
cp -r ios/Runner/Assets.xcassets/AppIcon.appiconset /tmp/ios_backup/
```

### 5.2 - iOS Klasorunu Sil ve Yeniden Olustur

```bash
rm -rf ios
flutter create --platforms=ios .
```

### 5.3 - Yedeklenen Dosyalari Geri Yukle

```bash
# Info.plist (AdMob + ATT + SKAdNetwork ayarlari)
cp /tmp/ios_backup/Info.plist ios/Runner/Info.plist

# App ikonlari (43 boyut)
rm -rf ios/Runner/Assets.xcassets/AppIcon.appiconset
cp -r /tmp/ios_backup/AppIcon.appiconset ios/Runner/Assets.xcassets/

# Yedegi temizle
rm -rf /tmp/ios_backup
```

### 5.4 - Podfile'i Yapilandir

```bash
# iOS minimum target'i 14.0 yap
sed -i '' "s/# platform :ios, '.*'/platform :ios, '14.0'/" ios/Podfile
sed -i '' "s/platform :ios, '.*'/platform :ios, '14.0'/" ios/Podfile
```

Dogrula:

```bash
head -5 ios/Podfile
# "platform :ios, '14.0'" gormalisin
```

### 5.5 - Pod Install

```bash
cd ios
pod install --repo-update
cd ..
```

### 5.6 - Dogrula

```bash
ls -la ios/Runner.xcworkspace
ls -la ios/Runner.xcodeproj
ls -la ios/Podfile.lock
ls -la ios/Pods
ls -la ios/Runner/AppDelegate.swift
```

Olusmus olmasi gereken yapi:

```
ios/
├── Runner.xcodeproj/          ← Xcode proje dosyasi
├── Runner.xcworkspace/        ← BUNU AC
├── Podfile                    ← iOS 14.0 target
├── Podfile.lock               ← Kilitlenmis surum listesi
├── Pods/                      ← Indirilen native kutuphaneler
├── Runner/
│   ├── AppDelegate.swift      ← Uygulama giris noktasi
│   ├── GeneratedPluginRegistrant.m
│   ├── Info.plist             ← AdMob + ATT + SKAdNetwork (geri yuklendi)
│   ├── Runner-Bridging-Header.h
│   └── Assets.xcassets/
│       ├── AppIcon.appiconset/ ← 43 ikon (geri yuklendi)
│       └── LaunchImage.imageset/
└── Flutter/
    ├── Debug.xcconfig
    ├── Release.xcconfig
    └── AppFrameworkInfo.plist
```

---

## ADIM 6: XCODE'DA ACMA

### 6.1 - Workspace Ac

```bash
open ios/Runner.xcworkspace
```

**ONEMLI:** `.xcworkspace` ac, `.xcodeproj` DEGIL. CocoaPods kullanildigindan workspace gerekli.

### 6.2 - Xcode Arayuzu

```
┌──────────────────────────────────────────────────────┐
│  ▶ Run   ⏹ Stop   │ Runner > iPhone 15 Pro │ Status │  ← Toolbar
├──────┬───────────────────────────────────────────────┤
│      │                                               │
│ Nav  │              Editor Area                      │
│ Bar  │         (Kod/Ayarlar burada gorunur)          │
│      │                                               │
│ Runner                                               │
│ ├ Runner                                             │
│ ├ Pods                                               │
│ └ Products                                           │
│      │                                               │
├──────┴───────────────────────────────────────────────┤
│                   Debug Console                       │
└──────────────────────────────────────────────────────┘
```

### 6.3 - Proje Ayarlari

Sol panelde **Runner** (mavi ikon) tikla → **TARGETS** → **Runner** → **General**:

| Ayar | Deger |
|------|-------|
| Display Name | `Vampir Partisi` |
| Bundle Identifier | `com.seninfirman.vampirpartisi` |
| Version | `1.0.0` |
| Build | `1` |
| Minimum Deployments | `iOS 14.0` |

---

## ADIM 7: SIGNING & CERTIFICATES

### 7.1 - Apple ID Ekle

Xcode → **Settings** (⌘,) → **Accounts** → **+** → Apple ID gir

### 7.2 - Automatic Signing

1. Sol panel → **Runner** (mavi ikon)
2. **TARGETS** → **Runner** → **Signing & Capabilities**
3. **Automatically manage signing** ✓ isaretle
4. **Team** → Apple ID hesabini sec
5. **Bundle Identifier** → benzersiz ID yaz: `com.senismin.vampirpartisi`

### 7.3 - In-App Purchase Capability

**Signing & Capabilities** → **+ Capability** → **In-App Purchase** ekle

---

## ADIM 8: SIMULATORDE CALISTIRMA

### 8.1 - Terminal ile (Onerilen)

```bash
flutter run -d ios
```

### 8.2 - Xcode ile

1. Toolbar'da simulator sec (iPhone 15 Pro)
2. ▶ Play (⌘R)

### 8.3 - Hot Reload

Uygulama calisirken terminalde:
- **r** → Hot Reload
- **R** → Hot Restart
- **q** → Durdur

---

## ADIM 9: GERCEK IPHONE'DA TEST

### 9.1 - iPhone Hazirla

1. USB ile bagla
2. iPhone → **Ayarlar → Gizlilik ve Guvenlik → Gelistirici Modu** → Ac
3. "Bu bilgisayara guven" → **Guven**

### 9.2 - Calistir

```bash
flutter devices
flutter run
```

### 9.3 - Guvenilmeyen Gelistirici Hatasi

iPhone → **Ayarlar → Genel → VPN ve Aygit Yonetimi** → Gelistirici hesabina **Guven**

---

## ADIM 10: ADMOB

### Test ID'leri (Gelistirme)

| Tur | Test ID |
|-----|---------|
| iOS App ID | `ca-app-pub-3940256099942544~1458002511` |
| iOS Banner | `ca-app-pub-3940256099942544/2934735716` |
| iOS Interstitial | `ca-app-pub-3940256099942544/4411468910` |

### Gercek ID'lere Gecis (Yayin Oncesi)

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

## ADIM 11: IN-APP PURCHASE

### App Store Connect'te Urun Olustur

1. appstoreconnect.apple.com → Uygulamalar → Olustur/Sec
2. **Ozellikler** → **Uygulama Ici Satin Alma Ogeleri** → **+**

| Alan | Deger |
|------|-------|
| Tur | Non-Consumable |
| Referans Adi | Premium Party Pack |
| Urun Kimligi | `premium_party_pack` |
| Fiyat | Belirledigin fiyat |

### Sandbox Test

1. App Store Connect → **Kullanicilar ve Erisim** → **Sandbox**
2. Test hesabi ekle
3. iPhone → **Ayarlar → App Store → Sandbox Hesabi** gir

---

## ADIM 12: RELEASE BUILD

### Kontrol Listesi

- [ ] Bundle Identifier benzersiz
- [ ] Version/Build numarasi guncel
- [ ] AdMob ID'leri gercek
- [ ] App ikonlari mevcut (43 boyut ✓)
- [ ] Info.plist izin aciklamalari ✓
- [ ] Team ve Signing tamam
- [ ] In-App Purchase Capability ekli

### Build

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

### Archive (Xcode)

1. Cihaz: **Any iOS Device (arm64)**
2. **Product → Archive**
3. Organizer acilir → **Distribute App**

### Archive (Terminal)

```bash
flutter build ipa --release
# Cikti: build/ios/ipa/
```

---

## ADIM 13: APP STORE YUKLEME

### Xcode Organizer

1. **Distribute App** tikla
2. **App Store Connect** → **Upload**
3. Signing onayla
4. **Upload**

### Terminal

```bash
xcrun altool --upload-app --type ios \
  --file build/ios/ipa/vampire_party_game.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

### App Store Connect'te Yayinla

1. appstoreconnect.apple.com → Uygulama sec
2. Ekran goruntuleri, aciklama, anahtar kelimeler, gizlilik politikasi ekle
3. **Incelemeye Gonder**
4. Apple incelemesi: 24-48 saat

---

## ADIM 14: SIK KARSILASILAN HATALAR

### "Signing requires a development team"

```bash
# Xcode → Runner → Signing & Capabilities → Team sec
```

---

### "CocoaPods not installed"

```bash
sudo gem install cocoapods
```

---

### "No such module 'google_mobile_ads'"

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

### "Deployment target" uyusmazligi

```bash
# ios/Podfile icinde:
# platform :ios, '14.0'
cd ios && pod install && cd ..
```

---

### "Unable to boot device"

```bash
xcrun simctl shutdown all
xcrun simctl erase all
```

---

### Build cok uzun suruyor

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

---

### "Untrusted Developer" (iPhone'da)

iPhone → Ayarlar → Genel → VPN ve Aygit Yonetimi → Gelistirici → Guven

---

### Ses calmiyor (Simulator)

Normal. Gercek cihazda test et.

---

### "Xcode 16 required" hatasi

macOS 13 ile Xcode 15.2 kullaniliyor, bu yeterli. Flutter 3.22.3 Xcode 15 ile uyumlu.

---

### "intl version solving failed"

```bash
rm -f pubspec.lock
flutter pub get
```

pubspec.yaml'da `intl: ^0.20.2` ve `package_info_plus: ^6.0.0` oldugunu dogrula.

---

## HIZLI REFERANS

```bash
# Tek satirda setup (script ile)
cd ~/Developer/VampireandvillageApp && ./scripts/setup_ios.sh

# Xcode'da ac
open ios/Runner.xcworkspace

# Simulatorde calistir
flutter run -d ios

# Gercek cihazda calistir
flutter run

# Release build
flutter build ios --release

# IPA olustur
flutter build ipa --release

# Pod'lari yeniden yukle
cd ios && pod install --repo-update && cd ..

# Temiz build
flutter clean && flutter pub get && cd ios && pod install && cd ..

# Flutter doctor
flutter doctor -v

# Simulator ac
open -a Simulator
```

---

## PROJE DOSYA HARITASI

```
VampireandvillageApp/
├── lib/                           ← Dart/Flutter kaynak kodu
│   ├── main.dart                  ← Uygulama giris noktasi
│   ├── screens/                   ← Tum ekranlar
│   ├── providers/                 ← State management
│   ├── models/                    ← Veri modelleri
│   ├── services/
│   │   ├── ad_service.dart        ← AdMob ID'leri BURADA
│   │   ├── ad_service_mobile.dart ← iOS/Android reklam kodu
│   │   ├── purchase_service.dart  ← IAP yapilandirmasi
│   │   └── sound_service.dart     ← Ses efektleri
│   ├── utils/
│   │   ├── att_helper_mobile.dart ← iOS Tracking izni
│   │   └── app_theme.dart         ← Tema renkleri
│   └── l10n/                      ← Dil dosyalari (TR/EN)
├── ios/                           ← iOS PROJE DOSYALARI
│   ├── Runner.xcworkspace/        ← BUNU AC (Xcode'da)
│   ├── Runner/
│   │   ├── Info.plist             ← iOS yapilandirma + AdMob App ID
│   │   └── Assets.xcassets/       ← App ikonlari (43 boyut)
│   ├── Podfile                    ← iOS bagimliliklari
│   └── Pods/                      ← Yuklenen iOS kutuphaneleri
├── assets/
│   ├── images/                    ← Arka plan gorselleri
│   └── sounds/                    ← Ses efektleri (mp3)
├── scripts/
│   └── setup_ios.sh               ← Otomatik iOS kurulum scripti
├── pubspec.yaml                   ← Flutter bagimliliklari
└── Xcode.md                      ← Bu dosya
```

---

## CI/CD NOTU

GitHub Actions workflow'u (`deploy_pages.yml`) Flutter 3.22.3'e sabitlendi.
Boylece lokal ve CI ayni Flutter surumunu kullanir, uyumsuzluk olmaz.

```yaml
# .github/workflows/deploy_pages.yml icinde:
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.22.3'
    channel: stable
```
