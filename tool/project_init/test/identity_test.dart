import 'package:project_init/project_init.dart';
import 'package:test/test.dart';

void main() {
  final validator = IdentityValidator(reservedPackageNames: {'common', 'dio'});

  group('displayName', () {
    test('accepts names with spaces, accents and punctuation', () {
      for (final name in ['My App', 'Café Délice', "Joe's App", 'A & B']) {
        expect(validator.displayName(name), isNull, reason: name);
      }
    });

    test('rejects values that would break a platform file', () {
      for (final name in [
        '',
        '  ',
        ' leading',
        'trailing ',
        'a\nb',
        r'Pay$',
        'a//b',
        r'a\b',
        '@string/app',
        '?attr',
      ]) {
        expect(validator.displayName(name), isNotNull, reason: name);
      }
    });
  });

  group('packageName', () {
    test('accepts valid Dart package names', () {
      for (final name in ['my_app', 'app2', 'a']) {
        expect(validator.packageName(name), isNull, reason: name);
      }
    });

    test('rejects invalid, reserved and taken names', () {
      for (final name in [
        '',
        'My_App',
        '2app',
        '_app',
        'my-app',
        'class',
        'common',
        'dio',
      ]) {
        expect(validator.packageName(name), isNotNull, reason: name);
      }
    });
  });

  group('androidApplicationId', () {
    test('accepts valid IDs', () {
      for (final id in ['com.company.app', 'io.rootstrap.my_app', 'a.b']) {
        expect(validator.androidApplicationId(id), isNull, reason: id);
      }
    });

    test('rejects invalid IDs', () {
      for (final id in [
        '',
        'app',
        'com..app',
        'com.company.my-app',
        'com.1company.app',
        'com.company.new',
        '.com.app',
      ]) {
        expect(validator.androidApplicationId(id), isNotNull, reason: id);
      }
    });
  });

  group('iosBundleId', () {
    test('accepts valid identifiers, including hyphens', () {
      for (final id in [
        'com.company.app',
        'com.company.my-app',
        'io.rs.App1',
      ]) {
        expect(validator.iosBundleId(id), isNull, reason: id);
      }
    });

    test('rejects invalid identifiers', () {
      for (final id in [
        '',
        'app',
        'com..app',
        'com.company.my_app',
        'com.company.my app',
      ]) {
        expect(validator.iosBundleId(id), isNotNull, reason: id);
      }
    });
  });
}
