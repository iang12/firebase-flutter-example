import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/pages/controller/todo_controller.dart';
import 'package:flutterfirebaseapp/service/analytics_service.dart';
import 'package:flutterfirebaseapp/service/crashlytics_service.dart';
import 'package:flutterfirebaseapp/service/firestore_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/controller/loading_provider.dart';
import 'pages/home_page.dart';

void main() async {
  // Garante a inicialização dos serviços Flutter
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Inicializa o Firebase Crashlytics
  await CrashlytcsService.initializeFlutterFire();
  // Inicializa o Firebase Analytics
  final exaAnalyticsService = CustomAnalyticsService();

  exaAnalyticsService.initAnalytics();

  runApp(
    MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
        )
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (_) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoController(
            loadingProvider:
                Provider.of<LoadingProvider>(context, listen: false),
            dbService: FirestoreService(
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
      ], child: const HomePage()),
    ),
  );
}
