part of 'preferences.dart';

///Production wraper for [SharedPreferences].
class _ProductionSharedPreferences extends BaseSharedPreferences {
  _ProductionSharedPreferences._();

  static late SharedPreferences? _sharedPreferences;

  static _ProductionSharedPreferences? _instance;

  ///Loads and parses the [SharedPreferences] for this app from disk.
  static Future<_ProductionSharedPreferences> getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _instance ??= _ProductionSharedPreferences._();
    return _instance!;
  }

  ///Completes with true once the user preferences for the app has been cleared.
  @override
  Future<bool> clear() {
    return _sharedPreferences!.clear();
  }

  ///Reads a value of any type from persistent storage.
  @override
  Object? get(String key) {
    return _sharedPreferences!.get(key);
  }

  ///Removes an entry from persistent storage.
  @override
  Future<bool> remove(String key) {
    return _sharedPreferences!.remove(key);
  }

  ///Saves a boolean [value] to persistent storage in the background.
  @override
  Future<bool> setBool(String key, bool value) {
    return _sharedPreferences!.setBool(key, value);
  }

  ///Saves a double [value] to persistent storage in the background.
  ///
  ///Android doesn't support storing doubles, so it will be stored as a float.
  @override
  Future<bool> setDouble(String key, double value) {
    return _sharedPreferences!.setDouble(key, value);
  }

  ///Saves an integer [value] to persistent storage in the background.
  @override
  Future<bool> setInt(String key, int value) {
    return _sharedPreferences!.setInt(key, value);
  }

  ///Saves a string [value] to persistent storage in the background.
  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreferences!.setString(key, value);
  }

  ///Checkes wheather the storage is empty or not.
  ///
  ///See also:
  ///* `SharedPreferences.getKeys()`
  @override
  bool isEmpty() {
    return _sharedPreferences!.getKeys().isEmpty;
  }
}
