import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/providers/providers.dart';
import 'package:rate/views/LoginPage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// ...

void main() async {
  runApp(ProviderScope(child: const MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ref.watch(themeProvider),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
