import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'models/child_profile.dart';
import 'models/milestone_record.dart';
import 'providers/child_provider.dart';
import 'providers/milestone_provider.dart';
import 'screens/main_screen.dart';
import 'screens/profile_registration_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(ChildProfileAdapter());
  Hive.registerAdapter(MilestoneRecordAdapter());

  // Initialize database service
  await DatabaseService.initialize();

  runApp(const FirstStepsApp());
}

class FirstStepsApp extends StatelessWidget {
  const FirstStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProvider(create: (_) => MilestoneProvider()),
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
