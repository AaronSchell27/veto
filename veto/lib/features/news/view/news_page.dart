// lib/features/news/view/news_page.dart
import 'package:flutter/material.dart';
import 'package:veto/features/news/view/news_view.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a plain Widget. Later, you'll wrap NewsView in a BlocProvider here.
    return const NewsView();
  }
}
