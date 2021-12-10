import 'package:flutter/foundation.dart';

///Base class if you want to create your own shared preferences impelementations.
///
///See Also:
///* `SharedPreferencesStorePlatform`
abstract class BaseSharedPreferences {
  const BaseSharedPreferences();
  Future<bool> setString(String key, String value) {
    throw UnimplementedError("this method isn't supported in this module.");
  }

  ///Saves a boolean [value] to persistent storage in the background.
  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(String key, bool value) {
    throw UnimplementedError("this method isn't supported in this module.");
  }

  ///Saves a double [value] to persistent storage in the background.
  ///
  ///Android doesn't support storing doubles, so it will be stored as a float.
  Future<bool> setDouble(String key, double value) {
    throw UnimplementedError("this method isn't supported in this module.");
  }

  ///Saves an integer [value] to persistent storage in the background.
  Future<bool> setInt(String key, int value) {
    throw UnimplementedError("this method isn't supported in this module.");
  }

  ///Reads a value of any type from persistent storage.
  Object? get(String key);

  ///Removes an entry from persistent storage.
  Future<bool> remove(String key);

  ///Completes with true once the user preferences for the app has been cleared.
  Future<bool> clear();

  ///Checkes wheather the storage is empty or not.
  ///
  ///See also:
  ///* `SharedPreferences.getKeys()`
  bool isEmpty() {
    throw UnimplementedError("this method isn't supported in this module.");
  }

  @visibleForTesting
  void setMockValue(Map<String, Object> values) {
    throw UnimplementedError("No need to impelement this method outside testing.");
  }
}
