import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> playNightStart() async {
    await _playSound('night.mp3');
  }

  Future<void> playDayStart() async {
    await _playSound('day.mp3');
  }

  Future<void> playVoteStart() async {
    await _playSound('vote.mp3');
  }

  Future<void> playDeath() async {
    await _playSound('death.mp3');
  }

  Future<void> playGameEnd() async {
    await _playSound('game_end.mp3');
  }

  // New sounds for moderator mode
  Future<void> playWolfHowl() async {
    await _playSound('wolf_howl.mp3');
  }

  Future<void> playRooster() async {
    await _playSound('rooster.mp3');
  }

  Future<void> playTimesUp() async {
    await _playSound('times_up.mp3');
  }

  Future<void> _playSound(String fileName) async {
    if (!_isEnabled) return;

    try {
      // Check if asset exists before playing
      await rootBundle.load('assets/sounds/$fileName');
      await _player.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      // Asset doesn't exist or failed to play - fail gracefully
      // No crash, just skip the sound
    }
  }

  void dispose() {
    _player.dispose();
  }
}
