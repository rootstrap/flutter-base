import 'dart:async';

import 'package:common/analytics/abstract/analytics_client.dart';

class FirebaseAnalytics implements AnalyticsClient {
  @override
  Future reset() {
    // TODO: implement reset
    throw UnimplementedError();
  }

  @override
  Future setUserId(String? userId) {
    // TODO: implement setUserId
    throw UnimplementedError();
  }

  @override
  Future setUserProperties(Map<String, dynamic> properties) {
    // TODO: implement setUserProperties
    throw UnimplementedError();
  }

  @override
  Future setUserProperty(String name, String value) {
    // TODO: implement setUserProperty
    throw UnimplementedError();
  }

  @override
  Future trackAppCreated() {
    // TODO: implement trackAppCreated
    throw UnimplementedError();
  }

  @override
  Future trackAppDeleted() {
    // TODO: implement trackAppDeleted
    throw UnimplementedError();
  }

  @override
  Future trackAppUpdated() {
    // TODO: implement trackAppUpdated
    throw UnimplementedError();
  }

  @override
  Future trackEvent(String name, {Map<String, dynamic>? properties}) {
    // TODO: implement trackEvent
    throw UnimplementedError();
  }

  @override
  Future trackFunction(
    FutureOr<void> Function() fn,
    String name, {
    Map<String, dynamic>? properties,
  }) =>
      Future.value(fn()).then((_) => trackEvent(name, properties: properties));
}
