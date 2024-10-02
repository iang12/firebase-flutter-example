import 'package:flutter/foundation.dart';

import '../service/crashlytics_service.dart';

abstract class Failure implements Exception {
  final String errorMessage;

  Failure({
    StackTrace? stackTrace,
    String? label,
    dynamic exception,
    this.errorMessage = '',
  }) {
    // Loga a stack trace apenas no modo debug para evitar poluição de logs em produção.
    if (stackTrace != null && kDebugMode) {
      debugPrintStack(label: label, stackTrace: stackTrace);
    }

    // Reporta o erro ao Crashlytics se houver exception
    ErrorReport.externalFailureError(exception, stackTrace, label);
  }
}

class UnknownError extends Failure {
  UnknownError({
    String? label,
    dynamic exception,
    StackTrace? stackTrace,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage:
              'Unknown Error', // Passa a mensagem diretamente para a classe base
        );
}

class ErrorSaveTodo extends Failure {
  ErrorSaveTodo({
    String? label,
    dynamic exception,
    StackTrace? stackTrace,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage:
              'ErrorSaveTodo', // Passa a mensagem diretamente para a classe base
        );
}

class AnalyticsException {
  AnalyticsException(String? message);
}
