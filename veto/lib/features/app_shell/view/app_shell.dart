// lib/features/app_shell/view/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/app_shell/view/app_shell_view.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    // It still serves its VGV architectural purpose: injecting the Bloc.
    // But now its name correctly states it is the persistent layout shell.
    return BlocProvider(
      create: (context) => HomeBloc(), 
      child: const AppShellView(),
    );
  }
}
