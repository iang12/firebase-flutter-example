import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfirebaseapp/errors/failure.dart';
import 'package:flutterfirebaseapp/models/user_model.dart';

import '../../di/di_setup.dart';
import '../../service/sentry_service.dart';

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no_data.svg',
            height: 250,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Tasks List is Empty!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'You don\'t have any active tasks right\nnow. Try to add some!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseCrashlytics.instance.crash();
            },
            child: const Text('Gerar falha'),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                throw ErrorSaveTodo();
              } catch (error, stack) {
                final sentryService = getIt<SentryService>();
                if (sentryService.isInitialized) {
                  sentryService.captureException(error, stackTrace: stack);

                  sentryService.setUser(
                    UserModel('2', 'joao@mail.com', '86994324465'),
                  );
                }
              }
            },
            child: const Text('Gerar falha 02'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Future.microtask(
                  () => throw StateError('Failure in a microtask'),
                );
              } catch (error, stack) {
                final sentryService = getIt<SentryService>();
                if (sentryService.isInitialized) {
                  sentryService.captureException(error, stackTrace: stack);

                  sentryService.setUser(
                    UserModel('2', 'joao@mail.com', '86994324465'),
                  );
                }
              }
            },
            child: const Text('Gerar falha 03 - microtask'),
          ),
        ],
      ),
    );
  }
}

class TooltipButton extends StatelessWidget {
  final String text;
  final String buttonTitle;
  final void Function()? onPressed;

  const TooltipButton({
    required this.onPressed,
    required this.buttonTitle,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      child: ElevatedButton(
        onPressed: onPressed,
        key: key,
        child: Text(buttonTitle),
      ),
    );
  }
}
