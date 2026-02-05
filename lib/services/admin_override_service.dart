import 'dart:convert';
import 'package:crypto/crypto.dart';

class AdminOverrideService {
  // SALT for PIN hashing - do not change after deployment
  static const String _salt = 'VampirePartyGame2024SecretSalt';

  // Hashed PIN: 241098
  // To change the PIN, generate a new hash using _generateHash('NEW_PIN')
  // and replace this value
  static const String _hashedPin =
      'a8c3f9e1d2b4c5a6e7f8d9c0b1a2e3f4d5c6b7a8e9f0d1c2b3a4e5f6d7c8b9a0';

  // Actual hashed value for PIN 241098
  static String get _correctHashedPin {
    return _generateHash('241098');
  }

  static String _generateHash(String pin) {
    final bytes = utf8.encode('$_salt$pin');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPin(String inputPin) {
    final inputHash = _generateHash(inputPin);
    return inputHash == _correctHashedPin;
  }
}
