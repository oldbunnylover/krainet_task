import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:krainet_task/firebase_options.dart';
import 'package:krainet_task/presentation/app/app.dart';
import 'package:krainet_task/presentation/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initInjector();
  runApp(const App());
}