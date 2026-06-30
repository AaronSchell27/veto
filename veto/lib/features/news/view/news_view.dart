// lib/features/news/view/news_view.dart
import 'package:flutter/material.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: const Center(
        child: Text('News Screen UI Content'),
      ),
    );
  }
}
