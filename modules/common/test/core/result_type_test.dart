import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultType.mapError', () {
    test('invokes the callback with the error of a TError', () {
      final failure = UnexpectedFailure('boom');
      Exception? received;

      TError<int>(failure).mapError((error) => received = error);

      expect(received, same(failure));
    });

    test('keeps the original error when the callback returns no Exception',
        () {
      final failure = UnexpectedFailure('boom');

      final result = TError<int>(failure).mapError((_) {});

      expect(result, isA<TError<int>>());
      expect((result as TError<int>).error, same(failure));
    });

    test('replaces the error when the callback returns an Exception', () {
      final mapped = ConnectionFailure('offline');

      final result = TError<int>(UnexpectedFailure()).mapError((_) => mapped);

      expect((result as TError<int>).error, same(mapped));
    });

    test('does not invoke the callback for a TSuccess', () {
      var called = false;

      final result = TSuccess(1).mapError((_) => called = true);

      expect(called, isFalse);
      expect((result as TSuccess<int>).data, 1);
    });
  });

  group('ResultType.mapSuccess', () {
    test('invokes the callback with the data of a TSuccess', () {
      int? received;

      TSuccess(42).mapSuccess((data) => received = data);

      expect(received, 42);
    });

    test('does not invoke the callback for a TError', () {
      var called = false;

      TError<int>(UnexpectedFailure()).mapSuccess((_) => called = true);

      expect(called, isFalse);
    });
  });
}
