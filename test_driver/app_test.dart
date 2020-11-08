import 'package:faker/faker.dart';
import 'package:fireflutter_sample_app/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Faker faker = Faker();
String email, password, displayName, color;
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
Future<void> tap(dynamic key, [timeout]) async {
  await delay(100);
  await driver.tap(find.byValueKey(key), timeout: timeout ?? _timeout);
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

/// Check if the widget of the key has [search] string.
///
/// expect(await has(Keys.hPleaseLogin, 'login'), true);
Future<bool> has(dynamic key, String search) async {
  await delay(100);
  String text = await driver.getText(find.byValueKey(key));
  return text.indexOf(search) != -1;
}

void main() {
  email = faker.internet.email();
  password = '12345a';
  displayName = faker.person.name();
  color = faker.food.dish();
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
      await enterText(Keys.riEmail, email);
      await enterText(Keys.riPassword, password);
      await enterText(Keys.riDisplayName, displayName);
      await enterText(Keys.riColor, color);
    });

    test('Submit registration form', () async {
      await tap(Keys.rsButton, Duration(seconds: 10));
    });

    test('Test email and color', () async {
      await waitFor(Keys.homeScreen);
      String text = await driver.getText(find.byValueKey(Keys.hInfo));
      expect(text.indexOf(email) >= 0, true);
      expect(text.indexOf(displayName) >= 0, true);
      expect(text.indexOf(color) >= 0, true);
    });

    test('Logout', () async {
      await tap(Keys.hLogoutButton);
      expect(await has(Keys.hPleaseLogin, 'login'), true);
    });

    test('Login', () async {
      await tap(Keys.hLoginButton);
      await waitFor(Keys.lfSubmitButton);
      await enterText(Keys.lfEmail, email);
      await enterText(Keys.lfPassword, password);
      await tap(Keys.lfSubmitButton);

      await waitFor(Keys.homeScreen);
      String text = await driver.getText(find.byValueKey(Keys.hInfo));
      expect(text.indexOf(email) >= 0, true);
      expect(text.indexOf(displayName) >= 0, true);
      expect(text.indexOf(color) >= 0, true);
    });

    test('Update Profile', () async {
      await tap(Keys.hProfileButotn);
      await waitFor(Keys.pfSubmitButton);
      await enterText(Keys.pfDisplayName, 'Nickname Updated(2)');
      await enterText(Keys.pfColor, 'Orange');
      await tap(Keys.pfSubmitButton);

      await goBackUntil(Keys.homeScreen);
      await delay();
      String text = await driver.getText(find.byValueKey(Keys.hInfo));
      expect(text.indexOf('Nickname Updated(2)') >= 0, true);

      expect(await has(Keys.hInfo, 'Blue'), false);
      expect(await has(Keys.hInfo, 'Orange'), true);
    });
  });
}
