// lib/features/account/view/account_view.dart
import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: const Center(
        child: Text('Account Screen UI Content'),
      ),
    );
  }
}
