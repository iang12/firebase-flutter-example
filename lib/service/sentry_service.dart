// Dart imports:
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

import '../models/user_model.dart';

abstract class ObservabilityService {
  Future<String> captureException(
    dynamic throwable, {
    dynamic stackTrace,
    Map<String, String>? tags,
  });

  void setUser(UserModel? user);

  Future<void> init(ObservabilityOptions options);

  bool get isInitialized;

  ObservabilityOptions? get options;
}

RouteObserver<PageRoute<dynamic>> observabilityNavigatorObserver() =>
    SentryNavigatorObserver();

class SentryService implements ObservabilityService {
  bool _isInitialized = false;
  ObservabilityOptions? _observabilityOptions;

  @override
  Future<String> captureException(
    throwable, {
    stackTrace,
    Map<String, String>? tags,
  }) async {
    if (!_isInitialized) {
      throw Exception('ObservabilityService not Initialized');
    }
    var id = await Sentry.captureException(throwable, stackTrace: stackTrace,
        withScope: (s) {
      if (tags != null) {
        tags.forEach((k, v) {
          s.setTag(k, v);
        });
      }
    });

    return Future.value(id.toString());
  }

  @override
  Future<void> init(ObservabilityOptions options) async {
    await SentryFlutter.init(
      (config) {
        config.debug = options.debug;
        config.dsn = options.url;
        config.sampleRate = 1.0;
        config.tracesSampleRate = 1;

        config.autoSessionTrackingInterval =
            const Duration(milliseconds: 30000);
        config.enableDeduplication = true;
        config.considerInAppFramesByDefault = true;
        config.attachScreenshot = true;
        config.screenshotQuality = SentryScreenshotQuality.low;
        config.attachViewHierarchy = true;
        config.reportPackages = false;

        // we do not want sentry-trace in headers
        config.tracePropagationTargets.clear();
        config.tracePropagationTargets.add('https://nconfig.sentry.trace');

        config.addIntegration(LoggingIntegration());
      },
    );

    _observabilityOptions = options;
    _isInitialized = true;
  }

  @override
  void setUser(UserModel? user) {
    if (!_isInitialized) {
      throw Exception('ObservabilityService not Initialized');
    }
    Sentry.configureScope((s) {
      if (user == null) {
        s.setUser(null);
      } else {
        s.setUser(SentryUser(id: user.id, email: user.email, data: {
          'phone': user.phone,
        }));
      }
    });
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  ObservabilityOptions? get options => _observabilityOptions;
}

class ObservabilityOptions {
  final String url;
  final bool debug;

  ObservabilityOptions({
    required this.url,
    this.debug = false,
  });
}
