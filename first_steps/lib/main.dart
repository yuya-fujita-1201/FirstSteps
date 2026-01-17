import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'models/child_profile.dart';
import 'models/milestone_record.dart';
import 'providers/child_provider.dart';
import 'providers/milestone_provider.dart';
import 'providers/purchase_provider.dart';
import 'screens/main_screen.dart';
import 'screens/profile_registration_screen.dart';
import 'services/database_service.dart';
import 'services/ad_service.dart';
import 'services/firebase_guard.dart';

void main() async {
  try {
    print('[INIT] 1. WidgetsFlutterBinding.ensureInitialized()');
    WidgetsFlutterBinding.ensureInitialized();

    print('[INIT] 2. FirebaseGuard.initialize()');
    await FirebaseGuard.initialize();

    print('[INIT] 3. MobileAds.instance.initialize()');
    await MobileAds.instance.initialize();

    print('[INIT] 4. AdService().loadInterstitialAd()');
    AdService().loadInterstitialAd();

    print('[INIT] 5. Hive.initFlutter()');
    await Hive.initFlutter();

    print('[INIT] 6. Hive.registerAdapter(ChildProfileAdapter)');
    Hive.registerAdapter(ChildProfileAdapter());

    print('[INIT] 7. Hive.registerAdapter(MilestoneRecordAdapter)');
    Hive.registerAdapter(MilestoneRecordAdapter());

    print('[INIT] 8. DatabaseService.initialize()');
    await DatabaseService.initialize();

    print('[INIT] 9. runApp()');
    runApp(const FirstStepsApp());
  } catch (e, stackTrace) {
    print('[INIT ERROR] $e');
    print('[INIT STACK] $stackTrace');
  }
}

class FirstStepsApp extends StatelessWidget {
  const FirstStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProxyProvider<ChildProvider, MilestoneProvider>(
          create: (_) => MilestoneProvider(),
          update: (_, childProvider, milestoneProvider) {
            milestoneProvider ??= MilestoneProvider();
            milestoneProvider.updateCurrentChildKey(
              childProvider.currentChildKey,
            );
            return milestoneProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
      ],
      child: MaterialApp(
        title: 'はじめてメモ ~First Steps~',
        theme: AppTheme.lightTheme,
        locale: const Locale('ja'),
        supportedLocales: const [
          Locale('ja'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FutureBuilder<bool>(
          future: _checkIfProfileExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final hasProfile = snapshot.data ?? false;
            if (hasProfile) {
              return const MainScreen();
            } else {
              return const ProfileRegistrationScreen();
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkIfProfileExists() async {
    final box = await Hive.openBox<ChildProfile>('child_profile');
    return box.isNotEmpty;
  }
}
