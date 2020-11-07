import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<void> delay([int milliseconds = 250]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds));
}

void main() {
  group('Testing App Performance Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Find home screen', () async {
      await delay();
      await driver.waitFor(find.byValueKey('homeScreen'));
    });

    test('Open register screen', () async {
      await delay();
      await driver.tap(find.byValueKey('registerButton'));
      await driver.waitFor(find.byValueKey('registerScreen'));

      await delay();
      await driver.tap(find.byValueKey('emailInput'));
      await driver.enterText('abc@gmail.com');

      await driver.tap(find.byValueKey('passwordInput'));
      await driver.enterText('12345a');
      await delay(10000);
    });
  });
}
