import 'package:chat_app/app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      home: const ChatPage(),
    );
  }
}
