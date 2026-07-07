// lib/app/view/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/features/home/view/home_page.dart';
import 'package:veto/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    required this.databaseClient, // Added required dependency parameter
    super.key,
  });

  final SupabaseDatabaseClient databaseClient; // Defined instance variable

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SupabaseDatabaseClient>.value(
      value: databaseClient,
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
