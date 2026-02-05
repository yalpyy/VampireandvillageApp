# Vampire Party Game - PRD (Updated)

## Original Problem Statement
Build a single-device, offline, local-only party game inspired by "Vampire/Werewolf".
- Played on ONE phone passed hand-to-hand
- No backend, no login, no rooms, no realtime networking
- Phone owner is admin/moderator and controls game flow
- Production-ready for Google Play and Apple App Store

## Core Change: Moderator-Based Gameplay
The game is now fully moderator-driven:
- Role owners DO NOT select targets on the phone
- All decisions happen verbally in the room
- The phone acts only as a Moderator console

## User Personas
1. **Moderator (Phone Owner)**: Controls game setup, timer, phase transitions, marks deaths
2. **Players**: View their roles once, participate in verbal discussions and voting

## Core Requirements (Static)
- Single device only
- Offline only
- No backend/Firebase/Supabase
- No user accounts
- No subscriptions (one-time purchase only)
- Clean UI, party-friendly, large buttons
- Privacy first (roles must never leak)
- Moderator-only control panel (no role action UI)

## What's Been Implemented (Jan 2026)

### New Screens
- ✅ HomeScreen - Fullscreen landing with animated "Start Game" button
- ✅ TermsScreen - KVKK & Terms acceptance on first launch
- ✅ ModeratorScreen - Main game hub with timer and player cards

### Moderator Mode Features
- ✅ "Put Everyone to Sleep" button (wolf howl sound)
- ✅ "Wake Everyone Up" button (rooster sound)
- ✅ Timer system with presets (30s, 60s, 90s, 120s for night; 1m, 2m, 3m, 5m for day)
- ✅ Timer auto-starts when Sleep pressed
- ✅ "Time's Up" indicator when timer ends
- ✅ Player cards showing:
  - Name only by default (alive)
  - Crossed out with revealed role (dead)
- ✅ Manual death marking via X button on player cards

### Game Flow (Updated)
- ✅ First night rule: No actions, no deaths (timer only)
- ✅ All nights: No role-action UI (vampire/doctor/seer selections)
- ✅ Moderator controls phase transitions
- ✅ Win conditions unchanged (villagers vs vampires)

### Existing Features (Preserved)
- ✅ Player setup with add/remove
- ✅ Role setup (free + premium roles)
- ✅ Role reveal with math challenge security
- ✅ Sound effects (wolf_howl, rooster, times_up added)
- ✅ Turkish/English localization
- ✅ Premium features (ads removal, all roles, English)
- ✅ Hidden admin override (5-tap logo + PIN)

## Prioritized Backlog

### P0 (Critical)
- Replace placeholder sound files with real audio
- Test full game flow end-to-end
- Configure AdMob production IDs

### P1 (Important)
- Custom timer input (manual minutes/seconds)
- Game log/history persistence

### P2 (Nice to Have)
- Background image assets for home screen
- More visual polish (animations, transitions)
- Accessibility improvements

## Sound Files Required
- wolf_howl.mp3 - Wolf howl for night start
- rooster.mp3 - Rooster crow for day start
- times_up.mp3 - Short alert when timer ends
- death.mp3 - Death sound effect
- game_end.mp3 - Victory/end sound

## Next Tasks
1. Add real sound effect files
2. Test complete game flow
3. Build release APK/IPA
4. Store submission preparation
