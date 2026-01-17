import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirebaseGuard {
  static bool _configured = false;

  static bool get isConfigured => _configured;

  static bool get hasValidOptions {
    final options = DefaultFirebaseOptions.currentPlatform;
    final values = <String>[
      options.apiKey,
      options.appId,
      options.messagingSenderId,
      options.projectId,
      if (options.storageBucket != null) options.storageBucket!,
      if (options.iosBundleId != null) options.iosBundleId!,
    ];
    return values.every(
      (value) => value.isNotEmpty && !value.startsWith('YOUR_'),
    );
  }

  static Future<void> initialize() async {
    if (!hasValidOptions) {
      debugPrint(
        '[Firebase] Skipped initialization: firebase_options.dart has placeholders.',
      );
      _configured = false;
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _configured = true;
    } catch (error) {
      debugPrint('[Firebase] Initialization failed: $error');
      _configured = false;
    }
  }
}
