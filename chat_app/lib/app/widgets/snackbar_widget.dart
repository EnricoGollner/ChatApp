import 'package:flutter/material.dart';

class SnackBarInfo extends StatelessWidget {
  const SnackBarInfo(
      {super.key, required this.message, required this.backgroundColor});

  final String message;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldMessenger(
        child: SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
