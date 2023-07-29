import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limerick Generator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LimerickPage(
          title: 'Limerick generator for Google event or program'),
    );
  }
}
