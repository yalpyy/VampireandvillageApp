#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════════════
# Vampire Party Game - iOS Project Setup Script
# macOS 13 Ventura + Flutter 3.22.3 + Xcode
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() { echo -e "\n${CYAN}═══ ADIM $1: $2 ═══${NC}\n"; }
print_ok()   { echo -e "${GREEN}✓ $1${NC}"; }
print_warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_err()  { echo -e "${RED}✗ $1${NC}"; }

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_VERSION="3.22.3"
FLUTTER_SDK_PATH="$HOME/flutter"

# ─────────────────────────────────────────────
# ADIM 1: Xcode kontrol
# ─────────────────────────────────────────────
print_step "1" "Xcode kontrol"

if ! xcode-select -p &>/dev/null; then
    print_err "Xcode kurulu degil."
    echo "App Store'dan Xcode yukleyin, ardindan:"
    echo "  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo "  sudo xcodebuild -license accept"
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -1)
print_ok "$XCODE_VERSION bulundu"

sudo xcodebuild -license accept 2>/dev/null || true
print_ok "Xcode lisansi kabul edildi"

# ─────────────────────────────────────────────
# ADIM 2: CocoaPods kontrol / kur
# ─────────────────────────────────────────────
print_step "2" "CocoaPods kontrol"

if ! command -v pod &>/dev/null; then
    print_warn "CocoaPods bulunamadi, kuruluyor..."
    sudo gem install cocoapods
fi

POD_VERSION=$(pod --version)
print_ok "CocoaPods $POD_VERSION bulundu"

# ─────────────────────────────────────────────
# ADIM 3: Flutter 3.22.3 kur (manuel SDK)
# ─────────────────────────────────────────────
print_step "3" "Flutter $FLUTTER_VERSION kurulumu"

NEED_INSTALL=true

if command -v flutter &>/dev/null; then
    CURRENT=$(flutter --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ "$CURRENT" = "$FLUTTER_VERSION" ]; then
        print_ok "Flutter $FLUTTER_VERSION zaten kurulu"
        NEED_INSTALL=false
    else
        print_warn "Flutter $CURRENT bulundu, $FLUTTER_VERSION gerekli"
    fi
fi

if [ "$NEED_INSTALL" = true ]; then
    echo "Flutter $FLUTTER_VERSION indiriliyor..."

    # Mevcut Homebrew Flutter varsa uyar
    if brew list --cask flutter &>/dev/null 2>&1; then
        print_warn "Homebrew Flutter tespit edildi. Manuel SDK kullanilacak."
        echo "Homebrew Flutter'i kaldirmak isterseniz: brew uninstall --cask flutter"
    fi

    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${FLUTTER_VERSION}-stable.zip"
    else
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${FLUTTER_VERSION}-stable.zip"
    fi

    TEMP_ZIP="/tmp/flutter_${FLUTTER_VERSION}.zip"

    if [ -d "$FLUTTER_SDK_PATH" ]; then
        print_warn "Mevcut $FLUTTER_SDK_PATH yedekleniyor..."
        mv "$FLUTTER_SDK_PATH" "${FLUTTER_SDK_PATH}_backup_$(date +%Y%m%d%H%M%S)"
    fi

    curl -L -o "$TEMP_ZIP" "$FLUTTER_URL"
    echo "Cikariliyor..."
    unzip -qo "$TEMP_ZIP" -d "$HOME"
    rm -f "$TEMP_ZIP"

    print_ok "Flutter $FLUTTER_VERSION -> $FLUTTER_SDK_PATH"

    # PATH'e ekle
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    fi

    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "flutter/bin" "$SHELL_RC"; then
            echo "" >> "$SHELL_RC"
            echo "# Flutter SDK" >> "$SHELL_RC"
            echo "export PATH=\"\$HOME/flutter/bin:\$PATH\"" >> "$SHELL_RC"
            print_ok "PATH eklendi: $SHELL_RC"
        fi
    fi

    export PATH="$HOME/flutter/bin:$PATH"
fi

# Dogrula
flutter --version
DART_VERSION=$(dart --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
print_ok "Dart $DART_VERSION"

# ─────────────────────────────────────────────
# ADIM 4: flutter doctor
# ─────────────────────────────────────────────
print_step "4" "Flutter Doctor"
flutter doctor -v

# ─────────────────────────────────────────────
# ADIM 5: Proje dizinine gec, temizle
# ─────────────────────────────────────────────
print_step "5" "Proje temizligi"
cd "$PROJECT_DIR"
print_ok "Dizin: $PROJECT_DIR"

flutter clean
print_ok "flutter clean tamamlandi"

# ─────────────────────────────────────────────
# ADIM 6: pubspec.lock sil, pub get
# ─────────────────────────────────────────────
print_step "6" "Dependency resolution"
rm -f pubspec.lock
flutter pub get
print_ok "flutter pub get tamamlandi"

# ─────────────────────────────────────────────
# ADIM 7: Localization dosyalarini olustur
# ─────────────────────────────────────────────
print_step "7" "Localization"
flutter gen-l10n
print_ok "flutter gen-l10n tamamlandi"

# ─────────────────────────────────────────────
# ADIM 8: iOS proje dosyalarini olustur
# ─────────────────────────────────────────────
print_step "8" "iOS proje olusturma"

# Info.plist ve ikonlari yedekle
BACKUP_DIR="/tmp/ios_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"

if [ -f "ios/Runner/Info.plist" ]; then
    cp "ios/Runner/Info.plist" "$BACKUP_DIR/Info.plist"
    print_ok "Info.plist yedeklendi"
fi

if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    cp -r "ios/Runner/Assets.xcassets/AppIcon.appiconset" "$BACKUP_DIR/AppIcon.appiconset"
    print_ok "App ikonlari yedeklendi"
fi

# iOS klasorunu sil ve yeniden olustur
rm -rf ios
flutter create --platforms=ios .
print_ok "flutter create --platforms=ios tamamlandi"

# Yedeklenen dosyalari geri koy
if [ -f "$BACKUP_DIR/Info.plist" ]; then
    cp "$BACKUP_DIR/Info.plist" "ios/Runner/Info.plist"
    print_ok "Info.plist geri yuklendi (AdMob + ATT + SKAdNetwork)"
fi

if [ -d "$BACKUP_DIR/AppIcon.appiconset" ]; then
    rm -rf "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    cp -r "$BACKUP_DIR/AppIcon.appiconset" "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    print_ok "App ikonlari geri yuklendi (43 boyut)"
fi

rm -rf "$BACKUP_DIR"

# ─────────────────────────────────────────────
# ADIM 9: Podfile'i yapilandir
# ─────────────────────────────────────────────
print_step "9" "Podfile yapilandirma"

# Minimum iOS 14.0 ayarla (ATT icin gerekli)
sed -i '' "s/# platform :ios, '.*'/platform :ios, '14.0'/" ios/Podfile 2>/dev/null || true
sed -i '' "s/platform :ios, '.*'/platform :ios, '14.0'/" ios/Podfile 2>/dev/null || true

# Eger hala yorum satiriysa, ac
if grep -q "# platform :ios" ios/Podfile; then
    sed -i '' "s/# platform :ios.*/platform :ios, '14.0'/" ios/Podfile
fi

print_ok "iOS minimum deployment target: 14.0"
echo "--- Podfile icerigi ---"
head -5 ios/Podfile
echo "---"

# ─────────────────────────────────────────────
# ADIM 10: pod install
# ─────────────────────────────────────────────
print_step "10" "CocoaPods install"
cd ios
pod install --repo-update
cd ..
print_ok "pod install tamamlandi"

# ─────────────────────────────────────────────
# ADIM 11: Runner.xcworkspace dogrulama
# ─────────────────────────────────────────────
print_step "11" "Dogrulama"

if [ -d "ios/Runner.xcworkspace" ]; then
    print_ok "Runner.xcworkspace MEVCUT"
else
    print_err "Runner.xcworkspace BULUNAMADI"
    exit 1
fi

if [ -d "ios/Runner.xcodeproj" ]; then
    print_ok "Runner.xcodeproj MEVCUT"
fi

if [ -f "ios/Podfile.lock" ]; then
    print_ok "Podfile.lock MEVCUT"
fi

if [ -d "ios/Pods" ]; then
    POD_COUNT=$(ls ios/Pods | wc -l | tr -d ' ')
    print_ok "Pods klasoru MEVCUT ($POD_COUNT pod)"
fi

if [ -f "ios/Runner/AppDelegate.swift" ]; then
    print_ok "AppDelegate.swift MEVCUT"
fi

# ─────────────────────────────────────────────
# ADIM 12: Ozet
# ─────────────────────────────────────────────
print_step "12" "TAMAMLANDI"

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║          iOS PROJE KURULUMU TAMAMLANDI                ║"
echo "╠═══════════════════════════════════════════════════════╣"
echo "║                                                       ║"
echo "║  Xcode'da acmak icin:                                ║"
echo "║  open ios/Runner.xcworkspace                          ║"
echo "║                                                       ║"
echo "║  Terminal'den calistirmak icin:                       ║"
echo "║  flutter run -d ios                                   ║"
echo "║                                                       ║"
echo "║  Xcode'da yapilacaklar:                               ║"
echo "║  1. Runner > Signing & Capabilities                   ║"
echo "║  2. Team: Apple ID hesabini sec                       ║"
echo "║  3. Bundle ID: com.senismin.vampirpartisi             ║"
echo "║  4. + Capability > In-App Purchase ekle               ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"
