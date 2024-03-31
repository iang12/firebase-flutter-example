import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/pages/controller/todo_controller.dart';
import 'package:flutterfirebaseapp/service/firestore_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/controller/loading_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
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
