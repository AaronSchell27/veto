// lib/features/vote/view/vote_view.dart
import 'package:flutter/material.dart';

class VoteView extends StatelessWidget {
  const VoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vote')),
      body: const Center(
        child: Text('Vote Screen UI Content'),
      ),
    );
  }
}
