import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stocks/flashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyD0ZKV8CLRJMfh3Cb8qnVgvAlqSQ2GKTp8',
          appId: '1:22138440089:android:95899a632b94a5a2966b08',
          messagingSenderId: '22138440089',
          projectId: 'stocks-99544'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'stocks',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const flashScreen(),
    );
  }
}
