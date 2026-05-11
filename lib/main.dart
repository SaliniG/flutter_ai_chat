import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const FlutterAiChatApp());
}

class FlutterAiChatApp extends StatelessWidget {
  const FlutterAiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}
