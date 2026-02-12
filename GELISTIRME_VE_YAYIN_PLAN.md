# Vampir Partisi - Gelistirme ve Yayin Plani

> **Proje:** VampireandvillageApp (Vampir Partisi)
> **Tur:** Flutter Offline Parti Oyunu (Vampir/Koyluleri temel alan moderator modu)
> **Mevcut Durum:** Gelistirme asamasinda, test reklam ID'leri ile calisiyor
> **Hedef:** AdMob aktif, Apple App Store'da yayinlanmaya hazir

---

## BOLUM 1: PROJE ANALIZI VE MEVCUT DURUM

### 1.1 Genel Yapi

```
lib/
  main.dart                          # Uygulama giris noktasi
  models/     (3 dosya)              # GameState, Player, Role
  providers/  (1 dosya)              # GameProvider (ChangeNotifier)
  services/   (9 dosya)              # AdService, PurchaseService, SoundService, AdminOverride
  screens/    (14 dosya)             # Home, PlayerSetup, RoleSetup, RoleReveal, Night, Day, Vote, Result, Settings, Terms, About, Moderator, AdminControl
  widgets/    (5 dosya)              # AdBannerWidget, PaywallDialog
  utils/      (3 dosya)              # AppTheme, LocalizationHelper
  l10n/       (2 dosya)              # Turkce (tr) ve Ingilizce (en) lokalizasyonlar
assets/
  images/     (2 dosya)              # home_background.png, moderator_background.png
  sounds/     (10 dosya)             # Oyun ses efektleri (mp3)
  fonts/                             # Bos (README.txt mevcut)
ios/
  Runner/Info.plist                  # TEK iOS dosyasi - proje iskeleti EKSIK
android/                             # Tam yapilandirilmis
web/                                 # Web platformu dosyalari mevcut
```

### 1.2 pubspec.yaml Analizi

**Mevcut Paketler:**
| Paket | Versiyon | Durum |
|---|---|---|
| provider | ^6.1.1 | OK |
| shared_preferences | ^2.2.2 | OK |
| google_mobile_ads | ^4.0.0 | OK - Test ID'leri ile |
| in_app_purchase | ^3.1.13 | OK |
| audioplayers | ^5.2.1 | OK |
| intl | ^0.20.2 | OK |
| crypto | ^3.0.3 | OK |
| flutter_lints | ^3.0.1 | OK (dev) |

**EKSIK Paketler (Eklenmeli):**
| Paket | Amac | Oncelik |
|---|---|---|
| `app_tracking_transparency: ^2.0.6` | iOS 14+ ATT izni icin zorunlu | **KRITIK** |
| `package_info_plus: ^8.0.0` | Uygulama versiyon bilgisi (About ekrani) | Orta |
| `url_launcher: ^6.2.5` | Gizlilik politikasi ve destek linkleri icin | Yuksek |

### 1.3 Kritik Eksiklikler Ozeti

| # | Eksiklik | Etki | Oncelik |
|---|---|---|---|
| 1 | iOS proje iskeleti yok (Podfile, xcodeproj, AppDelegate) | Derleme imkansiz | **KRITIK** |
| 2 | ATT (App Tracking Transparency) entegrasyonu yok | Apple reddeder | **KRITIK** |
| 3 | SKAdNetworkItems listesi eksik (sadece 1 adet var) | Reklam geliri duser | **YUKSEK** |
| 4 | Uygulama ikonu yok (1024x1024 App Store icin) | Store reddeder | **KRITIK** |
| 5 | iOS ikon seti (AppIcon.appiconset) yok | Derlemede hata | **KRITIK** |
| 6 | Interstitial reklam implemetasyonu yok | Gelir optimizasyonu | Orta |
| 7 | Gizlilik politikasi URL'si yok | Apple reddeder | **YUKSEK** |
| 8 | Test AdMob ID'leri uretimde kullaniliyor | Reklam geliri yok | **KRITIK** |
| 9 | NSUserTrackingUsageDescription eksik | ATT calismiyor | **KRITIK** |
| 10 | Launch screen uygun degil | UX sorunu | Orta |

---

## BOLUM 2: ADMOB VE iOS YAPILANDIRMASI

### 2.1 Info.plist Guncellemeleri

Mevcut `ios/Runner/Info.plist` dosyasina asagidaki bloklar eklenmeli:

#### 2.1.1 ATT Izin Mesaji (ZORUNLU - iOS 14+)

```xml
<!-- App Tracking Transparency -->
<key>NSUserTrackingUsageDescription</key>
<string>Bu uygulama, size daha uygun reklamlar gosterebilmek icin cihaz tanimlayicinizi kullanmak istemektedir. Verileriniz ucuncu taraflarla paylasilmayacaktir.</string>
```

#### 2.1.2 GADApplicationIdentifier (GUNCELLENMELI)

Mevcut test ID'si:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>  <!-- TEST -->
```

Uretim icin AdMob Console'dan alinacak gercek ID ile degistirilmeli:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>  <!-- GERCEK -->
```

#### 2.1.3 SKAdNetworkItems Tam Listesi

Google AdMob icin gereken SKAdNetwork tanimlayicilari (mevcut olan tek girdi yetersiz):

```xml
<key>SKAdNetworkItems</key>
<array>
  <!-- Google -->
  <dict><key>SKAdNetworkIdentifier</key><string>cstr6suwn9.skadnetwork</string></dict>
  <!-- Google Ads -->
  <dict><key>SKAdNetworkIdentifier</key><string>4fzdc2evr5.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>4pfyvq9l8r.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>2fnua5tdw4.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>ydx93a7ass.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>5a6flpkh64.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>p78ahlhg29.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>v72qych5uu.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>ludvb6z3bs.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>cp8zw746q7.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>3sh42y64q3.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>c6k4g5qg8m.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>s39g8k73mm.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>3qy4746246.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>f38h382jlk.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>hs6bdukanm.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>v4nxqhlyqp.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>wzmmz9fp6w.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>su67r6k2v3.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>yclnxrl5pm.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>4468km3ulz.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>e5fvkxwrpn.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>8s468mfl3y.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>av6w8kgt66.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>klf5c3l5u5.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>ppxm28t8ap.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>424m5254lk.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>ecpz2srf59.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>uw77j35x4d.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>mlmmfzh3r3.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>578prtvx9j.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>22mmun2rn5.skadnetwork</string></dict>
  <dict><key>SKAdNetworkIdentifier</key><string>gta9lk7p23.skadnetwork</string></dict>
</array>
```

> **NOT:** Google, SKAdNetwork listesini duzgun olarak guncellemektedir.
> Yayin oncesi https://developers.google.com/admob/ios/quick-start adresinden
> guncel listeyi kontrol edin.

### 2.2 ATT (App Tracking Transparency) Entegrasyonu

#### 2.2.1 pubspec.yaml'a Paket Ekleme

```yaml
dependencies:
  # ... mevcut paketler ...
  app_tracking_transparency: ^2.0.6
```

#### 2.2.2 ATT Izin Isteme - Kod Degisikligi

`lib/main.dart` dosyasindaki `main()` fonksiyonu guncellenecek:

```dart
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS 14+ ATT izni iste (reklamlardan once)
  if (!kIsWeb && Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // iOS bir gecikme gerektirir
      await Future.delayed(const Duration(seconds: 1));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // Sonra AdMob initialize
  try {
    await AdService().initialize();
  } catch (e) {
    // AdMob yapilandirilmamis olabilir
  }

  // ... geri kalan kod ayni ...
}
```

> **ONEMLI:** ATT izni, `MobileAds.instance.initialize()` ONCE istenmelidir.
> Apple, uygulamanin izin istemeden once tracking yapmasini reddeder.

### 2.3 Reklam Tipleri ve Yerlestirme

#### 2.3.1 Mevcut Durum: Banner Reklam

Banner reklam zaten implemente edilmis (`ad_service.dart`, `ad_banner_widget.dart`).
Ancak `AdBannerWidget` kullanimi ekranlarda **gorulmuyor**. Asagidaki ekranlara eklenmeli:

| Ekran | Yerlestirme | Aciklama |
|---|---|---|
| `home_screen.dart` | Alt kisim (bottomNavigationBar alani) | Ana ekran banner |
| `day_screen.dart` | Ust veya alt kisim | Gunduz tartisma ekrani |
| `result_screen.dart` | Sonuc ekraninda banner | Oyun bittikten sonra |

Ornek kullanim:
```dart
// Herhangi bir Scaffold'un body'sinde:
Column(
  children: [
    Expanded(child: /* mevcut icerik */),
    if (gameProvider.adsEnabled) const AdBannerWidget(),
  ],
)
```

#### 2.3.2 Eklenmeli: Interstitial Reklam

Interstitial reklamlar asagidaki gecislerde gosterilmeli:
- Oyun bittiginde (`result_screen.dart` acilmadan once)
- Her 3. oyundan sonra (cok sik gosterme - Apple reddedebilir)

`ad_service.dart` ve `ad_service_mobile.dart` dosyalarina interstitial destegi eklenmeli:

```dart
// ad_service.dart icine eklenecek:
class AdConfig {
  // Mevcut banner ID'leri...

  // Interstitial Test Ad Unit IDs
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910';
}
```

```dart
// ad_service_mobile.dart icine eklenecek:
InterstitialAd? _interstitialAd;

Future<void> loadInterstitial() async {
  final adUnitId = Platform.isAndroid
      ? AdConfig.androidInterstitialAdUnitId
      : AdConfig.iosInterstitialAdUnitId;

  await InterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) => _interstitialAd = ad,
      onAdFailedToLoad: (error) => _interstitialAd = null,
    ),
  );
}

Future<void> showInterstitial() async {
  if (_interstitialAd != null) {
    await _interstitialAd!.show();
    _interstitialAd = null;
    await loadInterstitial(); // Bir sonraki icin yukle
  }
}
```

### 2.4 AdMob Uretim ID'lerinin Alinmasi

1. https://admob.google.com adresine gidin
2. "Uygulamalar" > "Uygulama Ekle" > iOS secin
3. Uygulama adini "Vampir Partisi" olarak girin
4. Olusturulan **App ID**'yi `Info.plist` icindeki `GADApplicationIdentifier`'a yazin
5. "Reklam birimleri" > "Reklam birimi olustur":
   - Banner reklam birimi olusturun > ID'yi `AdConfig.iosBannerAdUnitId`'ye yazin
   - Interstitial reklam birimi olusturun > ID'yi `AdConfig.iosInterstitialAdUnitId`'ye yazin
6. Ayni islemi Android icin de tekrarlayin

---

## BOLUM 3: iOS PROJE ISKELETI VE YAPILANDIRMA

### 3.1 iOS Proje Iskeletinin Olusturulmasi

iOS klasorunde sadece `Runner/Info.plist` mevcut. Tam iOS proje iskeleti olusturulmali:

```bash
# Proje kok dizininde calistirin:
flutter create . --org com.vampireparty --project-name vampire_party_game

# Bu komut eksik iOS dosyalarini olusturacak:
# - ios/Podfile
# - ios/Runner.xcodeproj/
# - ios/Runner.xcworkspace/
# - ios/Runner/AppDelegate.swift
# - ios/Runner/Assets.xcassets/
# - ios/Runner/LaunchScreen.storyboard
# - ios/Runner/Base.lproj/
# - vs.
```

> **UYARI:** `flutter create .` mevcut `Info.plist`'i uzerine yazabilir.
> Calistirmadan once `Info.plist` dosyasini yedekleyin ve sonrasinda
> guncellemelerimizi yeniden uygulayin.

### 3.2 Bundle ID ve Xcode Yapilandirmasi

#### 3.2.1 Bundle Identifier
- **Onerimiz:** `com.vampireparty.game`
- Bu deger Android ile tutarli olmali (AndroidManifest.xml'de zaten bu deger var)
- Xcode'da: Runner > Targets > Runner > General > Bundle Identifier

#### 3.2.2 Xcode Signing & Capabilities

Xcode'da asagidaki adimlari izleyin:

1. **Runner.xcworkspace** dosyasini acin (xcodeproj degil!)
2. **Targets > Runner > Signing & Capabilities** sekmesine gidin
3. Asagidaki ayarlari yapin:

| Ayar | Deger |
|---|---|
| Team | Apple Developer hesabiniz (gerekli: $99/yil) |
| Bundle Identifier | `com.vampireparty.game` |
| Provisioning Profile | Automatic |
| Signing Certificate | Apple Distribution |

4. **+ Capability** butonuna basarak asagidakileri ekleyin:
   - **In-App Purchase** (premium_party_pack icin zorunlu)
   - **Push Notifications** (gelecekte gerekebilir)

#### 3.2.3 Minimum iOS Versiyonu

`ios/Podfile` dosyasinda minimum iOS versiyonunu ayarlayin:
```ruby
platform :ios, '14.0'
```

> iOS 14.0 secildi cunku:
> - ATT (App Tracking Transparency) iOS 14+ gerektirir
> - google_mobile_ads ^4.0.0 minimum iOS 12 gerektirir
> - Kullanici tabaninin %99+ iOS 14+ kullaniyor

### 3.3 App Store Ikon Seti

App Store icin asagidaki ikon boyutlari gereklidir:

| Boyut | Kullanim |
|---|---|
| 1024x1024 | App Store listing (ZORUNLU) |
| 180x180 | iPhone @3x (60pt) |
| 120x120 | iPhone @2x (60pt) |
| 167x167 | iPad Pro @2x (83.5pt) |
| 152x152 | iPad @2x (76pt) |
| 80x80 | Spotlight @2x |
| 120x120 | Spotlight @3x |
| 87x87 | Settings @3x |
| 58x58 | Settings @2x |
| 40x40 | Notification @2x |
| 60x60 | Notification @3x |

**Yapilmasi gerekenler:**

1. 1024x1024 piksel, kare, seffaf arka plansiz (alpha kanali olmamal!) bir uygulama ikonu tasarlayin
2. Ikon icerigi onerisi: Koyu mor/kirmizi arka plan, vampir temalik bir sembol
3. Asagidaki araclardan biriyle tum boyutlari uretin:
   - https://www.appicon.co (ucretsiz)
   - Xcode'un Assets.xcassets > AppIcon editoru
4. Uretilen ikonlari `ios/Runner/Assets.xcassets/AppIcon.appiconset/` altina koyun

> **UYARI:** App Store ikonu alpha kanali (seffaflik) iceremez. Apple bunu reddeder.

---

## BOLUM 4: APPLE APP STORE YAYIN HAZIRLIGI

### 4.1 App Store Connect Ayarlari

#### 4.1.1 On Kosullar
- [x] Apple Developer Program uyeliginiz olmali ($99/yil)
- [ ] App Store Connect'te uygulama kaydini olusturun
- [ ] Bundle ID'yi Apple Developer Portal'da tanimlayin

#### 4.1.2 App Store Connect'te Yeni Uygulama

1. https://appstoreconnect.apple.com adresine gidin
2. "My Apps" > "+" > "New App" secin
3. Asagidaki bilgileri girin:

| Alan | Deger |
|---|---|
| Platform | iOS |
| Name | Vampir Partisi |
| Primary Language | Turkish |
| Bundle ID | com.vampireparty.game |
| SKU | vampir-partisi-001 |

#### 4.1.3 Uygulama Bilgileri

| Alan | Deger/Oneri |
|---|---|
| Subtitle | Vampir Koyluleri Parti Oyunu |
| Category | Games > Party |
| Secondary Category | Entertainment |
| Age Rating | 12+ (vampir temasi nedeniyle) |
| Price | Free (Freemium model) |
| Content Rights | Bu icerigin tum haklari bize aittir |

#### 4.1.4 Gerekli Ekran Goruntuleri

| Cihaz | Boyut | Adet |
|---|---|---|
| iPhone 6.7" (15 Pro Max) | 1290 x 2796 | Min 3, max 10 |
| iPhone 6.5" (11 Pro Max) | 1242 x 2688 | Min 3, max 10 |
| iPad Pro 12.9" (6th Gen) | 2048 x 2732 | Min 3, max 10 (iPad destekleniyorsa) |

> Ekran goruntuleri Simulator'dan alinabilir veya Figma/Canva ile tasarlanabilir.

### 4.2 Apple Reddetme (Rejection) Sebepleri Analizi

Projeniz icin yuksek riskli reddetme sebepleri:

#### 4.2.1 KRITIK - Kesinlikle Duzeltilmeli

| # | Guideline | Sorun | Cozum |
|---|---|---|---|
| 1 | **5.1.1 - Data Collection and Storage** | Gizlilik politikasi URL'si yok | Web sitesinde gizlilik politikasi sayfasi olusturun ve App Store Connect'e ekleyin |
| 2 | **5.1.2 - Data Use and Sharing** | ATT izni olmadan reklam SDK'si var | ATT entegrasyonunu tamamlayin (Bolum 2.2) |
| 3 | **2.1 - App Completeness** | Test reklam ID'leri uretimde calismiyor | Gercek AdMob ID'leri ile degistirin |
| 4 | **2.3.3 - Accurate Metadata** | Eksik ikon seti | 1024x1024 App Store ikonu + tum boyutlar |
| 5 | **3.1.1 - In-App Purchase** | IAP test edilmemis olabilir | Sandbox ortaminda test edin |

#### 4.2.2 YUKSEK RISK - Buyuk Olasilikla Kontrol Edilecek

| # | Guideline | Sorun | Cozum |
|---|---|---|---|
| 6 | **5.1.1 - Privacy Policy** | Terms ekraninda gizlilik politikasi linki yok | Settings veya About ekranina gizlilik politikasi linki ekleyin |
| 7 | **2.3.7 - 3rd Party Auth** | Gizlilik politikasi 3. parti SDK'lari kapsamiyor | Gizlilik politikasinda AdMob ve IAP'yi belirtin |
| 8 | **4.0 - Design** | iPad destegi belirtilmis ama test edilmemis | iPad'de test edin veya iPad destegini kaldirin |
| 9 | **3.1.2 - Subscriptions** | Restore Purchases butonu TODO olarak birakilmis | `PurchaseService().restorePurchases()` cagrisini aktif edin |
| 10 | **2.3 - Accurate Screenshots** | Ekran goruntuleri mevcut degil | Gercek uygulama ekran goruntuleri alin |

#### 4.2.3 ORTA RISK - Muhtemel Kontrol

| # | Guideline | Sorun | Cozum |
|---|---|---|---|
| 11 | **4.2.3 - Minimum Functionality** | Uygulama basit gorunebilir | Tum ozelliklerin calistigini gosterecek ekran goruntuleri ve aciklama yazin |
| 12 | **1.3 - Kids Category** | Vampir temasi 12+ gerektirir | Age Rating'i dogru secin |
| 13 | **2.5.1 - Software Requirements** | Minimum iOS versiyonu uyumu | iOS 14.0 olarak ayarlayin |

### 4.3 Gizlilik Politikasi

Apple, TUM uygulamalar icin gizlilik politikasi URL'si gerektirir. Asagidaki bilgileri iceren bir gizlilik politikasi sayfasi olusturulmali:

**Icermesi gereken maddeler:**
1. Uygulama adi ve gelistirici bilgileri
2. Toplanan veriler:
   - Uygulama icinde kisisel veri TOPLANMIYOR
   - AdMob (Google) reklam amacli cihaz bilgisi toplayabilir
   - In-App Purchase islemleri Apple tarafindan islenir
3. KVKK uyumu (Turkiye icin)
4. GDPR uyumu (AB kullanicilari icin gerekli olabilir)
5. Iletisim bilgileri
6. Veri silme hakki

**Onerimiz:** GitHub Pages veya basit bir web sitesinde barindirilabilir.
Ornek URL: `https://vampireparty.github.io/privacy-policy`

### 4.4 App Privacy (App Store Connect)

App Store Connect'te "App Privacy" bolumunde asagidaki beyanlari yapmaniz gerekir:

| Veri Tipi | Toplaniyor mu? | Baglaniyor mu? | Takip icin mi? |
|---|---|---|---|
| Identifiers (Device ID) | Evet (AdMob) | Hayir | Evet (reklam) |
| Usage Data | Evet (AdMob) | Hayir | Evet (reklam) |
| Diagnostics | Hayir | - | - |
| Purchases | Evet (IAP) | Hayir | Hayir |

---

## BOLUM 5: KOD OPTIMIZASYONU VE IYILESTIRMELER

### 5.1 Oncelikli Kod Degisiklikleri

#### 5.1.1 Restore Purchases Duzeltmesi

`lib/screens/settings_screen.dart` - Satir 71:
```dart
// MEVCUT (calismayan):
onTap: () async {
  // TODO: Call purchase service restore
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l.purchaseRestored)),
  );
},

// OLMASI GEREKEN:
onTap: () async {
  final restored = await PurchaseService().restorePurchases();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        restored ? l.purchaseRestored : 'Satin alma bulunamadi',
      )),
    );
  }
},
```

#### 5.1.2 `withOpacity()` Kullanimi

Flutter'in yeni versiyonlarinda `withOpacity()` yerine `withValues(alpha: ...)` onerilir.
Bu bir uyari olusturur ancak mevcut durumda calisiyor. Ileriki guncellemelerde duzeltilmeli.

### 5.2 Banner Reklam Yerlestirme

Su anda `AdBannerWidget` hicbir ekranda kullanilmiyor. Asagidaki ekranlara eklenmeli:

**home_screen.dart:**
```dart
// Scaffold body'nin en altina:
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: Consumer<GameProvider>(
    builder: (context, gp, _) =>
        gp.adsEnabled ? const AdBannerWidget() : const SizedBox.shrink(),
  ),
),
```

**result_screen.dart:**
```dart
// Sonuc ekraninin en altina:
if (gameProvider.adsEnabled) const AdBannerWidget(),
```

---

## BOLUM 6: ADIM ADIM UYGULAMA PLANI

### Faz 1: iOS Proje Temeli

- [ ] 1.1 `Info.plist` dosyasini yedekleyin
- [ ] 1.2 `flutter create . --org com.vampireparty --project-name vampire_party_game` calistirin
- [ ] 1.3 Yedeklenen `Info.plist` icindeki ozel ayarlari geri uygulayin
- [ ] 1.4 `ios/Podfile`'da minimum iOS versiyonunu 14.0 olarak ayarlayin
- [ ] 1.5 `flutter pub get` ve `cd ios && pod install` calistirin

### Faz 2: AdMob ve ATT Entegrasyonu

- [ ] 2.1 `pubspec.yaml`'a `app_tracking_transparency: ^2.0.6` ekleyin
- [ ] 2.2 `Info.plist`'e `NSUserTrackingUsageDescription` ekleyin
- [ ] 2.3 `Info.plist`'teki SKAdNetworkItems listesini genisletin
- [ ] 2.4 `main.dart`'a ATT izin isteme kodunu ekleyin (AdMob init'ten ONCE)
- [ ] 2.5 Interstitial reklam desteGini `ad_service.dart` ve `ad_service_mobile.dart`'a ekleyin
- [ ] 2.6 Banner reklamlari ilgili ekranlara yerlestirin (home, result, day)
- [ ] 2.7 AdMob Console'dan uretim reklam ID'lerini alin ve degistirin

### Faz 3: Ikon ve Gorseller

- [ ] 3.1 1024x1024 uygulama ikonu tasarlayin (alpha kanali olmamali!)
- [ ] 3.2 appicon.co veya benzeri aracla tum iOS boyutlarini uretin
- [ ] 3.3 `ios/Runner/Assets.xcassets/AppIcon.appiconset/` klasorune yerlestirin
- [ ] 3.4 LaunchScreen.storyboard'u guncelleyin

### Faz 4: Kod Duzeltmeleri

- [ ] 4.1 Restore Purchases butonunu aktif edin (`settings_screen.dart`)
- [ ] 4.2 Gizlilik politikasi linkini About veya Settings ekranina ekleyin
- [ ] 4.3 `url_launcher` paketini ekleyin ve gizlilik politikasi linkini acilabilir yapin
- [ ] 4.4 iPad uyumluluGunu test edin veya iPad destegini kaldirin

### Faz 5: Test

- [ ] 5.1 iOS Simulator'da uygulamayi calistirin
- [ ] 5.2 Gercek iOS cihazda test edin
- [ ] 5.3 ATT dialog'unun dogru goruntulendigini dogrulayin
- [ ] 5.4 Banner reklamlarin dogru yerlestirdigini dogrulayin (test ID'leri ile)
- [ ] 5.5 In-App Purchase'i Sandbox ortaminda test edin
- [ ] 5.6 Tum ekranlari kontrol edin (crash, layout, vs.)
- [ ] 5.7 iPad'de layout kontrolu yapin

### Faz 6: App Store Yayin

- [ ] 6.1 AdMob'da uretim reklam ID'lerini olusturun ve koda yerlestirin
- [ ] 6.2 Gizlilik politikasi sayfasini yayinlayin
- [ ] 6.3 App Store Connect'te uygulamayi tanimlayin
- [ ] 6.4 Ekran goruntuleri alin (iPhone + iPad)
- [ ] 6.5 App Privacy beyanlarini doldurun
- [ ] 6.6 Xcode'da Archive olusturun
- [ ] 6.7 App Store Connect'e yukleyin
- [ ] 6.8 Review icin gonderin

---

## BOLUM 7: XCODE ARCHIVE VE YUKLEME REHBERI

### 7.1 Build Ayarlari

Xcode'da asagidaki ayarlarin dogru oldugundan emin olun:

```
Runner > Build Settings:
  - iOS Deployment Target: 14.0
  - Valid Architectures: arm64
  - Build Active Architecture Only: No (Release icin)
  - Code Signing Identity: Apple Distribution
  - Provisioning Profile: Automatic
```

### 7.2 Archive Olusturma

```bash
# Terminal'den:
flutter build ios --release

# Sonra Xcode'da:
# Product > Archive > Distribute App > App Store Connect > Upload
```

### 7.3 Upload Oncesi Kontrol Listesi

- [ ] Tum test ID'leri uretim ID'leri ile degistirildi
- [ ] Bundle ID dogru: `com.vampireparty.game`
- [ ] Versiyon numarasi dogru (1.0.0)
- [ ] Build numarasi arttirildi
- [ ] App Store ikonu (1024x1024) mevcut ve alpha kanali yok
- [ ] Bitcode: Disabled (Flutter icin gerekli)
- [ ] Minimum iOS: 14.0
- [ ] ATT izin mesaji dogru dilde
- [ ] Gizlilik politikasi URL'si calisiyor
- [ ] Restore Purchases butonu calisiyor

---

## BOLUM 8: URETIM ONCESI SON KONTROLLER

### 8.1 Degistirilmesi Gereken Test ID'leri

| Dosya | Satir | Mevcut (Test) | Degistirilecek |
|---|---|---|---|
| `Info.plist` | 46 | `ca-app-pub-3940256099942544~1458002511` | Gercek iOS App ID |
| `AndroidManifest.xml` | 11 | `ca-app-pub-3940256099942544~3347511713` | Gercek Android App ID |
| `ad_service.dart` | 15 | `ca-app-pub-3940256099942544/6300978111` | Gercek Android Banner ID |
| `ad_service.dart` | 16 | `ca-app-pub-3940256099942544/2934735716` | Gercek iOS Banner ID |

### 8.2 Onemli Notlar

1. **Apple Review suresi:** Genellikle 24-48 saat, ilk basvuruda 1 haftaya kadar cikar
2. **Reddetme durumunda:** Resolution Center uzerinden itiraz edin veya gereken duzeltmeleri yapin
3. **TestFlight:** Yayin oncesi TestFlight ile beta test yapin
4. **KVKK/GDPR:** Turkiye'deki kullanicilar icin KVKK, AB kullanicilari icin GDPR uyumu gerekli
5. **AdMob Policy:** Kendi reklamlariniza tiklamayin, yapay trafik olusturmayin

---

## EK: DOSYA DEGISIKLIK OZETI

| Dosya | Islem |
|---|---|
| `pubspec.yaml` | `app_tracking_transparency`, `url_launcher`, `package_info_plus` ekle |
| `ios/Runner/Info.plist` | ATT mesaji, SKAdNetworkItems genislet, gercek AdMob ID |
| `lib/main.dart` | ATT izin isteme kodu ekle |
| `lib/services/ad_service.dart` | Interstitial config ekle |
| `lib/services/ad_service_mobile.dart` | Interstitial yukle/goster fonksiyonlari ekle |
| `lib/services/ad_service_stub.dart` | Interstitial stub'lari ekle |
| `lib/screens/home_screen.dart` | Banner reklam yerlestir |
| `lib/screens/result_screen.dart` | Banner reklam yerlestir |
| `lib/screens/settings_screen.dart` | Restore Purchases'i aktif et |
| `lib/screens/about_screen.dart` | Gizlilik politikasi linki ekle |
| `ios/Runner/Assets.xcassets/` | Uygulama ikon seti ekle |

---

*Bu plan, VampireandvillageApp projesinin mevcut durumunun kapsamli analizine dayalidir.*
*Her faz sirasiyla uygulanmali, bir sonraki faza gecmeden once mevcut faz tamamlanmalidir.*
