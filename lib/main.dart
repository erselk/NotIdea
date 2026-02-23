import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:notidea/app.dart';
import 'package:notidea/config/env.dart';
import 'package:notidea/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await Env.load();
  await SupabaseConfig.initialize();

  timeago.setLocaleMessages('tr', timeago.TrMessages());

  runApp(const ProviderScope(child: NotIdeaApp()));
}
