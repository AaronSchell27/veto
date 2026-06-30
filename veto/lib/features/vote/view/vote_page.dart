// lib/features/vote/view/vote_page.dart
import 'package:flutter/material.dart';
import 'package:veto/features/vote/view/vote_view.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a plain Widget. Later, you'll wrap VoteView in a BlocProvider here.
    return const VoteView();
  }
}
