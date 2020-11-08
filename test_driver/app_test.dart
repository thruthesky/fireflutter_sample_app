import 'package:faker/faker.dart';
import 'package:fireflutter_sample_app/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Faker faker = Faker();
FlutterDriver driver;
const Duration _timeout = kUnusuallyLongTimeout;

/// Delay
Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

/// Check if a wiget exist.
///
/// ```dart
/// bool ex = await exists('homeScreen');
/// ```
Future<bool> exists(dynamic key) async {
  await delay(100);
  try {
    await driver.waitFor(find.byValueKey(key),
        timeout: Duration(milliseconds: 250));
    return true;
  } catch (e) {
    return false;
  }
}

/// Helper class
///
/// A simple alias function of `driver.tap`
Future<void> tap(dynamic key) async {
  await delay(100);
  await driver.tap(find.byValueKey(key), timeout: _timeout);
}

/// Helper class
///
/// A simple alias of `driver.waitFor`
Future<void> waitFor(dynamic key) async {
  await delay(100);
  await driver.waitFor(find.byValueKey(key), timeout: _timeout);
}

/// Helper class
///
/// A simple alias of `driver.enterText`
Future<void> enterText(dynamic key, String text) async {
  await delay(100);

  await driver.tap(find.byValueKey(key));
  await driver.enterText(text);
}

/// Go back until a wiget of the key found.
///
/// You may use it for going back to home page.
/// ```dart
/// await goBackUntil('homeScreen');
/// ```
Future<void> goBackUntil(dynamic key) async {
  bool ex = await exists(key);
  if (ex) {
    return;
  }
  await driver.tap(find.pageBack());
  await goBackUntil(key);
}

void main() {
  group('Testing App Performance Tests', () {
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Go home screen', () async {
      await delay();
      await goBackUntil(Keys.homeScreen);
    });

    test('Go register screen', () async {
      await tap(Keys.rButton);
      await waitFor(Keys.rsButton);
    });

    test('Fill registration form', () async {
      await enterText(Keys.riEmail, faker.internet.email());
      await enterText(Keys.riPassword, '12345a');
      await enterText(Keys.riDisplayName, 'name');
      await enterText(Keys.riColor, 'blue');
    });

    test('Submit registration form', () async {
      await tap(Keys.rsButton);
    });

    test('Test email and color', () async {
      await waitFor(Keys.homeScreen);
      String text = await driver.getText(find.byValueKey('hinfo'));
      print('text: $text');
    });
  });
}
