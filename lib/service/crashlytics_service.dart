import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlytcsService {
  static Future<void> initializeFlutterFire() async {
    try {
      // Ativa o Crashlytics apenas no modo release.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Captura erros em isolados
      Isolate.current.addErrorListener(ErrorReport.isolateErrorListener);
    } catch (error) {
      debugPrint(
        'Couldn’t load FirebaseCrashlytics. $error',
      );
    }
  }
}

class ErrorReport {
  static Future<void> _report(
    dynamic exception,
    StackTrace stackTrace,
    String tag,
  ) async {
    if (exception != null) {
      // Exibe a stack trace no console local
      debugPrintStack(label: tag, stackTrace: stackTrace);

      // Adiciona chaves personalizadas com contexto adicional
      await FirebaseCrashlytics.instance.setCustomKey('Error_Tag', tag);
      await FirebaseCrashlytics.instance
          .setCustomKey('Exception_Type', exception.runtimeType.toString());
      await FirebaseCrashlytics.instance
          .setCustomKey('StackTrace', stackTrace.toString());

      // Loga o erro e a exceção
      await FirebaseCrashlytics.instance
          .log('Error occurred: ${exception.toString()}');
      await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    }
  }

  static void externalFailureError(
      dynamic exception, StackTrace? stackTrace, String? reportTag) {
    if (stackTrace != null && reportTag != null) {
      _report(exception, stackTrace, 'EXTERNAL_FAILURE: $reportTag');
    }
  }

  // Listener para capturar erros em isolados
  static SendPort get isolateErrorListener {
    return RawReceivePort((pair) async {
      final List errorAndStacktrace = pair;
      final exception = errorAndStacktrace[0];
      final stackTrace = errorAndStacktrace[1];
      await _report(exception, stackTrace, 'ISOLATE');
    }).sendPort;
  }
}
