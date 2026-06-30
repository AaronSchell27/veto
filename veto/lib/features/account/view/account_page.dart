// lib/features/account/view/account_page.dart
import 'package:flutter/material.dart';
import 'package:veto/features/account/view/account_view.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a plain Widget. Later, you'll wrap AccountView in a BlocProvider here.
    return const AccountView();
  }
}
