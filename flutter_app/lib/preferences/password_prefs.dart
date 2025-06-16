import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PasswordPrefs {
  double length;
  bool useUpper, useLower, useDigits, useSymbols;
  int minDigits, minSymbols;
  static const _prefsKey = 'password_generator_prefs';

  PasswordPrefs({
    required this.length,
    required this.useUpper,
    required this.useLower,
    required this.useDigits,
    required this.useSymbols,
    required this.minDigits,
    required this.minSymbols,
  });

  /// Defaults if no saved prefs exist.
  factory PasswordPrefs.defaults() => PasswordPrefs(
    length: 35,
    useUpper: true,
    useLower: true,
    useDigits: true,
    useSymbols: true,
    minDigits: 5,
    minSymbols: 5,
  );

  factory PasswordPrefs.fromJson(Map<String, dynamic> j) => PasswordPrefs(
    length: (j['length'] as num).toDouble(),
    useUpper: j['useUpper'] as bool,
    useLower: j['useLower'] as bool,
    useDigits: j['useDigits'] as bool,
    useSymbols: j['useSymbols'] as bool,
    minDigits: j['minDigits'] as int,
    minSymbols: j['minSymbols'] as int,
  );

  Map<String, dynamic> toJson() => {
    'length': length,
    'useUpper': useUpper,
    'useLower': useLower,
    'useDigits': useDigits,
    'useSymbols': useSymbols,
    'minDigits': minDigits,
    'minSymbols': minSymbols,
  };

  static Future<PasswordPrefs> loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(_prefsKey);
    if (jsonString == null) {
      return PasswordPrefs.defaults();
    }
    try {
      final Map<String, dynamic> map = json.decode(jsonString);
      return PasswordPrefs.fromJson(map);
    } catch (_) {
      // If parsing fails, fall back to defaults
      return PasswordPrefs.defaults();
    }
  }

  static Future<void> savePrefs(PasswordPrefs prefs) async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = json.encode(prefs.toJson());
    await sp.setString(_prefsKey, jsonString);
  }
}
