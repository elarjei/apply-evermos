import 'package:flutter/material.dart';
import 'myapp.dart';

Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}
