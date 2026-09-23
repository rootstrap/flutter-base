import 'package:domain/env/env_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => EnvConfig.env = EnvConfig.kDevEnv);

  group('EnvConfig.apiUrl', () {
    test('reads the unsuffixed API_URL of a per-flavor file', () {
      dotenv.loadFromString(envString: 'API_URL=https://dev.example.com');
      EnvConfig.env = EnvConfig.kDevEnv;

      expect(EnvConfig.apiUrl, 'https://dev.example.com');
    });

    test('reads the key suffixed with the active flavor', () {
      dotenv.loadFromString(
        envString:
            'API_URL_DEV=https://dev.example.com\n'
            'API_URL_QA=https://qa.example.com',
      );
      EnvConfig.env = EnvConfig.kQaEnv;

      expect(EnvConfig.apiUrl, 'https://qa.example.com');
    });

    test('prefers the suffixed key over the unsuffixed one', () {
      dotenv.loadFromString(
        envString:
            'API_URL=https://fallback.example.com\n'
            'API_URL_PROD=https://prod.example.com',
      );
      EnvConfig.env = EnvConfig.kProdEnv;

      expect(EnvConfig.apiUrl, 'https://prod.example.com');
    });

    test('is empty when no API_URL key is defined', () {
      dotenv.loadFromString(envString: 'ENV=dev');

      expect(EnvConfig.apiUrl, isEmpty);
    });
  });
}
