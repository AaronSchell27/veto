// lib/main_staging.dart

import 'package:flutter/widgets.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/app/app.dart';
import 'package:veto/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your staging database credentials
  final databaseClient = await SupabaseDatabaseClient.initialize(
    url: 'https://rttcxycxzitlwwkbtnoj.supabase.co/rest/v1/',
    anonKey: 'sb_publishable_FhXgMdId4X-lTiJIDtJgpw_EvyCNdaf',
  );

  await bootstrap(
    databaseClient: databaseClient,
    builder: () => App(databaseClient: databaseClient),
  );
}
