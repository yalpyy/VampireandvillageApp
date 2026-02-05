# Vampire Party Game - PRD

## Original Problem Statement
Build a single-device, offline, local-only party game inspired by "Vampire/Werewolf". 
- Played on ONE phone passed hand-to-hand
- No backend, no login, no rooms, no realtime networking
- Phone owner is admin and controls game flow
- Production-ready for Google Play and Apple App Store

## User Personas
1. **Party Host (Admin)**: Controls game setup, manages phases, passes phone
2. **Players**: View their roles, participate in day discussions and voting

## Core Requirements (Static)
- Single device only
- Offline only
- No backend/Firebase/Supabase
- No user accounts
- No subscriptions (one-time purchase only)
- Clean UI, party-friendly, large buttons
- Privacy first (roles must never leak)

## What's Been Implemented (Jan 2026)

### Game Flow
- ✅ Player Setup Screen (add/remove players)
- ✅ Role Setup Screen (free + premium roles)
- ✅ Role Distribution with math challenge security
- ✅ Admin Control Panel
- ✅ Night Phase (Vampire, Doctor, Seer, Guard actions)
- ✅ Day Phase with event log
- ✅ Vote Phase for elimination
- ✅ Result Screen with role reveal

### Roles Implemented
- Free: Villager, Vampire, Doctor
- Premium: Seer, Hunter, Witch, Lovers, Guard, Drunk

### Monetization
- ✅ AdMob banner ads (test IDs configured)
- ✅ In-app purchase setup (premium_party_pack)
- ✅ Ads placement: setup screens, result screen, under New Game
- ✅ No ads on: role reveal, math lock, night screens

### Features
- ✅ Sound effects with graceful fallback
- ✅ Turkish localization (default)
- ✅ English localization (premium only)
- ✅ Settings screen (sound toggle, language)
- ✅ Hidden admin override (5-tap logo + PIN)
- ✅ Restore purchases functionality

### Technical
- ✅ Provider state management
- ✅ SharedPreferences for local storage
- ✅ Fisher-Yates shuffle for role assignment
- ✅ SHA256 + salt PIN hashing

## Prioritized Backlog

### P0 (Critical)
- Replace test AdMob IDs with production IDs
- Add actual sound effect files
- Configure in-app purchase products in stores

### P1 (Important)
- Add Hunter death action (shoot when eliminated)
- Add Witch save/kill actions in night phase
- Add Lovers mechanics (both die together)
- Add Drunk role reveal mid-game

### P2 (Nice to Have)
- Custom themes/color schemes
- Game history/statistics
- Tutorial/onboarding screens
- Accessibility improvements

## Next Tasks
1. Replace placeholder sound files with actual audio
2. Set up AdMob production account
3. Configure Google Play Console in-app products
4. Configure App Store Connect in-app purchases
5. Build release APK and IPA for store submission
