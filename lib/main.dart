// lib/main.dart

import 'package:flutter/material.dart';
import 'home_page.dart';

// Serviço de notificações
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o sistema de notificações (iOS)
  await NotificationService.instance.initialize();

  runApp(const StoryApp());
}

class StoryApp extends StatelessWidget {
  const StoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}
