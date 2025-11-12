import 'dart:async';

/// Additional method to track custom events with a specific type.
/// Follow the naming convention for event types.
/// Future trackInitLoginFlow() => trackEvent('init_login', properties: {...});
/// Future trackErrorLogin() => trackEvent('error_login', properties: {...});

abstract class AnalyticsClient {
  /// Tracks an event with a function call and a name.
  /// This is useful for tracking events that are triggered by specific actions.
  /// Example usage:
  /// trackFunction(() => loginWithEmailPassword(email, password), 'login_triggered', properties: {email: email});
  Future trackFunction(
    FutureOr<void> Function() fn,
    String name, {
    Map<String, dynamic>? properties,
  });

  Future trackEvent(String name, {Map<String, dynamic>? properties});

  Future setUserId(String? userId);

  Future setUserProperties(Map<String, dynamic> properties);

  Future setUserProperty(String name, String value);

  Future reset();

  Future trackAppCreated();

  Future trackAppUpdated();

  Future trackAppDeleted();
}
