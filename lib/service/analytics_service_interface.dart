abstract class AnalyticsService {
  /// If analytics is supported on the current platform.
  Future<void> initAnalytics();

  /// If analytics is supported on the current platform.
  Future<bool> isSupported();

  /// Retrieves the session id from the client. Returns null if analyticsStorageConsentGranted is false or session is expired.
  Future<int?> getSessionId();

  /// Logs the standard `app_open` event.
  Future<void> logAppOpen();

  /// Logs events customizeds with the given [name] and [parameters].
  /// [name] is the name of the event.
  /// [parameters] are the optional parameters.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Logs the standard `screen_view` event.
  /// [screenClass] is the class of the screen.
  /// [screenName] is the name of the screen.
  /// [parameters] are the optional parameters.
  Future<void> logScreenView({
    String? screenClass,
    String? screenName,
    Map<String, Object>? parameters,
  });

  /// Logs the standard `sign_up` event.
  /// [signInMethod] is the method used to sign up.
  /// [parameters] are the optional parameters.
  Future<void> logSignUp({
    required String signUpMethod,
    Map<String, Object>? parameters,
  });

  /// Clears all analytics data for this app from the device and resets the app instance id.
  Future<void> resetAnalyticsData();

  /// Adds parameters that will be set on every event logged from the SDK, including automatic ones.
  /// [defaultParameters] are the default parameters.
  Future<void> setDefaultEventParameters(
    Map<String, Object?>? defaultParameters,
  );

  /// Sets the duration of inactivity that terminates the current session.
  /// [timeout] is the duration of inactivity that terminates the current session.
  Future<void> setSessionTimeoutDuration(Duration timeout);

  /// Sets the user id.
  /// [id] is the user id.
  Future<void> setUserId({String? id});

  /// Sets the user property.
  /// [name] is the name of the property.
  /// [value] is the value of the property.
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}
