import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase options for current platform.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return android; // Use Android config for Windows
      case TargetPlatform.linux:
        return android; // Use Android config for Linux
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3qF1pJ8Upb3WtfHE0Ds22qgtwEW_T8h8',
    appId: '1:776057320321:android:a311775a67c5bcfc1c2e80',
    messagingSenderId: '776057320321',
    projectId: 'first-steps-7d383',
    storageBucket: 'first-steps-7d383.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArjw6kW5uLGzKacx_JYlQEFKrbpHlbrjk',
    appId: '1:776057320321:ios:817b3b8cd8b3aa471c2e80',
    messagingSenderId: '776057320321',
    projectId: 'first-steps-7d383',
    storageBucket: 'first-steps-7d383.firebasestorage.app',
    iosBundleId: 'com.example.firstSteps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArjw6kW5uLGzKacx_JYlQEFKrbpHlbrjk',
    appId: '1:776057320321:ios:817b3b8cd8b3aa471c2e80',
    messagingSenderId: '776057320321',
    projectId: 'first-steps-7d383',
    storageBucket: 'first-steps-7d383.firebasestorage.app',
    iosBundleId: 'com.example.firstSteps',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3qF1pJ8Upb3WtfHE0Ds22qgtwEW_T8h8',
    appId: '1:776057320321:android:a311775a67c5bcfc1c2e80',
    messagingSenderId: '776057320321',
    projectId: 'first-steps-7d383',
    storageBucket: 'first-steps-7d383.firebasestorage.app',
    authDomain: 'first-steps-7d383.firebaseapp.com',
  );
}
