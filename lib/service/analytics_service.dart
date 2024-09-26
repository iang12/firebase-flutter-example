import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfirebaseapp/errors/failure.dart';
import 'analytics_service_interface.dart';

/// A class that extends [AnalyticsService] to log events and
/// screen views for Google and Firebase Analytics
class CustomAnalyticsService implements AnalyticsService {
  final _firebaseAnalytics = FirebaseAnalytics.instance;
  @override
  Future<void> initAnalytics() async {
    await _firebaseAnalytics.setAnalyticsCollectionEnabled(!kDebugMode);
  }

  @override
  Future<int?> getSessionId() async {
    try {
      return await _firebaseAnalytics.getSessionId();
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried get session id from analytics: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<bool> isSupported() async {
    try {
      return await _firebaseAnalytics.isSupported();
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried check if analytics is supported: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> logAppOpen({Map<String, Object>? parameters}) async {
    try {
      await _firebaseAnalytics.logAppOpen(parameters: parameters);
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register a log for app open: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register a event: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> logScreenView({
    String? screenClass,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _firebaseAnalytics.logScreenView(
        screenClass: screenClass,
        screenName: screenName,
        parameters: parameters,
      );
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register a event for Screen View: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> logSignUp({
    required String signUpMethod,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _firebaseAnalytics.logSignUp(
        signUpMethod: signUpMethod,
        parameters: parameters,
      );
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register a log for sign up: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    try {
      await _firebaseAnalytics.resetAnalyticsData();
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried reset log from analytics data: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> setDefaultEventParameters(
    Map<String, Object?>? defaultParameters,
  ) async {
    try {
      await _firebaseAnalytics.setDefaultEventParameters(defaultParameters);
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried set default event parameters on analytics: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> setSessionTimeoutDuration(Duration timeout) async {
    try {
      await _firebaseAnalytics.setSessionTimeoutDuration(timeout);
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried set session timeout on analytics: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> setUserId({String? id}) async {
    try {
      await _firebaseAnalytics.setUserId(id: id);
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register user id on analytics: exception $exception stackTrace: $stackTrace",
      );
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _firebaseAnalytics.setUserProperty(name: name, value: value);
    } catch (exception, stackTrace) {
      throw AnalyticsException(
        "Error when tried register user property on analytics: exception $exception stackTrace: $stackTrace",
      );
    }
  }
}
