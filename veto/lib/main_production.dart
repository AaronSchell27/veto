// lib/main_production.dart

import 'package:flutter/widgets.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/app/app.dart';
import 'package:veto/bootstrap.dart';

Future<void> main() async {
  // Ensure native bindings are active before running async platform work
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your production database credentials
  final databaseClient = await SupabaseDatabaseClient.initialize(
    url: 'https://rttcxycxzitlwwkbtnoj.supabase.co/rest/v1/', // Swap with your live prod URL later
    anonKey: 'sb_publishable_FhXgMdId4X-lTiJIDtJgpw_EvyCNdaf', // Swap with your live prod key later
  );

  await bootstrap(
    databaseClient: databaseClient,
    builder: () => App(databaseClient: databaseClient),
  );
}
