import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_utilities/preferences_utilities.dart';

///Matches for [NotSupportedTypeToSaveException]
final Matcher isNotSupportedTypeToSaveException = throwsA(isA<NotSupportedTypeToSaveException>());

class MockSharedPrefrences extends Mock implements BaseSharedPreferences {}

void main() {
  group("PreferencesUtilities", () {
    final string = "hello_world";
    final _int = 5;

    late BaseSharedPreferences preferences;
    late PreferencesUtilities instance;
    setUp(() {
      preferences = MockSharedPrefrences();
      PreferencesUtilities.init(preferences);
      instance = PreferencesUtilities.instance!;
    });

    tearDown(() {
      PreferencesUtilities.clearInstance();
    });

    group("getValueWithKey()", () {
      test("gets value with correct [String]", () {
        when(() => preferences.get("string_value")).thenReturn(string);
        expect(instance.getValueWithKey<String>("string_value"), string);
      });
      test("gets value with correct [int]", () {
        when(() => preferences.get("int_value")).thenReturn(_int);
        expect(instance.getValueWithKey<int>("int_value"), _int);
      });
      test(
          "throws value casting exception "
          "when returning type doesn't match "
          "the saved value type", () {
        when(() => preferences.get("int_value")).thenReturn(_int);
        expect(() => instance.getValueWithKey<String>("int_value"), throwsA(isA<TypeDoesNotMatch>()));
      });

      test("returns null value when isn't value", () {
        when(() => preferences.get("null_test")).thenReturn(null);
        expect(instance.getValueWithKey<String>("null_test"), isNull);
      });
    });
    group("saveValueWithKey()", () {
      test("saves [String] Values to local storage", () {
        when(() => preferences.setString(any(), any())).thenAnswer((_) async => true);
        expect(
          instance.saveValueWithKey<String>("string_key", "string_value"),
          completion(isTrue),
        );
      });
      test("saves [bool] Values to local storage", () {
        when(() => preferences.setBool(any(), any())).thenAnswer((_) async => true);
        expect(
          instance.saveValueWithKey<bool>("bool_key", true),
          completion(isTrue),
        );
      });
      test("saves [double] Values to local storage", () {
        when(() => preferences.setDouble(any(), any())).thenAnswer((_) async => true);
        expect(
          instance.saveValueWithKey<double>("double_key", 56.6),
          completion(isTrue),
        );
      });
      test("saves [int] Values to local storage", () {
        when(() => preferences.setInt(any(), any())).thenAnswer((_) async => true);
        expect(
          instance.saveValueWithKey<int>("int_key", 5),
          completion(isTrue),
        );
      });
      test("throws when the saved type isn't supported", () {
        expect(
          instance.saveValueWithKey<Map>("map_key", {}),
          isNotSupportedTypeToSaveException,
        );
      });
    });
    test("clearAll()", () {
      when(() => preferences.clear()).thenAnswer((_) async => true);
      expect(instance.clearAll(), completion(isTrue));
    });

    group("removeValueWithKey()", () {
      test("returns [true] if saved value doesn't exist", () {
        when(() => preferences.get(any())).thenReturn(null);
        expect(instance.removeValueWithKey("key"), completion(isTrue));
      });
      test("returns [true] if succeeded", () {
        when(() => preferences.get(any())).thenReturn("value");
        when(() => preferences.remove(any())).thenAnswer((_) async => true);
        expect(instance.removeValueWithKey("key"), completion(isTrue));
      });
    });
    test("removeMultipleValuesWithKeys()", () async {
      final keys = List.generate(3, (index) => "key_index_$index");
      when(() => preferences.get(any())).thenReturn("expected");
      when(() => preferences.remove(any())).thenAnswer((_) async => true);

      await expectLater(instance.removeMultipleValuesWithKeys(keys), completes);
      verify(() => preferences.remove("key_index_1")).called(1);
      verify(() => preferences.get("key_index_1")).called(1);
    });
  });
}
