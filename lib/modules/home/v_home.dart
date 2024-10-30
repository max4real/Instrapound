import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0XFF262D39),
      body: Center(
        child: Text("This is Home"),
      ),
    );
  }
}
