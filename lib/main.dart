import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:notidea/app.dart';
import 'package:notidea/config/env.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/core/database/app_database.dart';
import 'package:notidea/core/services/notification_service.dart';

/// FCM arka plan mesajlarını handle eder (top-level, isolate dışında çalışır).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

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
  await AppDatabase.instance.init();
  await SupabaseConfig.initialize();

  // Firebase + FCM — web'de yapılandırma olmadığından atlanır
  if (!kIsWeb) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService.instance.init();
  }

  timeago.setLocaleMessages('tr', timeago.TrMessages());

  // Sentry — production crash reporting
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://e2d070d5a95bc7c10799ec29818f66b0@o4510955845058560.ingest.de.sentry.io/4510955859279952';
      options.tracesSampleRate = 0.2;
      options.environment = kDebugMode ? 'debug' : 'production';
      options.attachStacktrace = true;
    },
    appRunner: () => runApp(const ProviderScope(child: NotIdeaApp())),
  );
}
