import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_shared_preferences.dart';

part '_production_prefs.dart';

///Throwes when you try to save unsupported DataType into [SharedPreferences]
class NotSupportedTypeToSaveException implements Exception {}

///Throwes when retrieved value type deosn't match the givin type.
class TypeDoesNotMatch implements Exception {}

Logger _logger = Logger(level: Level.nothing);

///Acts as a wraper for [SharedPreferences] to make saving and geting saved value
///as easy as possible in addition of adding more cool feature like removing
///muliple values at once.
class PreferencesUtilities {
  PreferencesUtilities._();

  static BaseSharedPreferences? _preferences;
  static final PreferencesUtilities _instance = PreferencesUtilities._();

  //Retuns an instance of the class to interface with.
  static PreferencesUtilities get instance {
    assert(_preferences != null, "Did you forget to call [PreferencesUtilities.init()]?");
    return _instance;
  }

  /// init the class in `main` function.
  ///
  /// if [preferences] never specified, a default shared prefrences instance
  /// is provided.
  ///
  static Future<void> init([BaseSharedPreferences? preferences]) async {
    _preferences ??= preferences ?? await _ProductionSharedPreferences.getInstance();
  }

  @visibleForTesting
  BaseSharedPreferences? get preferences => _preferences;

  ///Clear the given prefrences instance to test.
  ///
  @visibleForTesting
  static void clearInstance() => _preferences = null;

  ///Change the logger level. defaults to `Level.nothing`
  void setLoggerMode(Level level) {
    _logger = Logger(level: level);
  }

  /// `T` is the  `runTimeType` data which you are trying to save (`bool` - `String` - `double`)
  Future<bool> saveValueWithKey<T>(String key, T value) async {
    _logger.d("SharedPreferences: [Saving data] -> key: $key, value: $value");

    if (value is String) {
      return _preferences!.setString(key, value);
    } else if (value is bool) {
      return _preferences!.setBool(key, value);
    } else if (value is double) {
      return _preferences!.setDouble(key, value);
    } else if (value is int) {
      return _preferences!.setInt(key, value);
    }
    throw NotSupportedTypeToSaveException();
  }

  ///Get a saved value using given `Key`.
  ///
  ///if value does not exist returns `null`.
  E? getValueWithKey<E>(String key) {
    final value = _preferences!.get(key);
    _logger.d("SharedPreferences: [Reading data] -> key: $key, value: $value");
    if (value == null) return null;
    if (value is E) return value as E;
    throw TypeDoesNotMatch();
  }

  ///Remove saved value with `Key` form local DB.
  Future<bool> removeValueWithKey(String key) async {
    final value = _preferences?.get(key);
    if (value == null) return true;
    _logger.d("SharedPreferences: [Removing data] -> key: $key, value: $value");
    return _preferences!.remove(key);
  }

  ///Remove saved values with `Keys` form local DB.
  Future<void> removeMultipleValuesWithKeys(List<String> keys) async {
    dynamic value;
    for (final String key in keys) {
      value = _preferences!.get(key);
      if (value == null) {
        _logger.i("SharedPreferences: [Removing data] -> key: $key, value: {ERROR 'null' value}");
        _logger.i("Skipping...");
      } else {
        await _preferences!.remove(key);
        _logger.d("SharedPreferences: [Removing data] -> key: $key, value: $value");
      }
    }
    return;
  }

  ///Clear all app saved preferences.
  Future<bool> clearAll() async {
    return _preferences!.clear();
  }

  ///Retuns `true` if the local storage is empty.
  bool isEmpty() {
    return _preferences!.isEmpty();
  }
}
