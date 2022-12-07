import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/ui_view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fyp_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:fyp_project/utils/themeChoice.dart';
import 'package:fyp_project/utils/themeModeNotifier.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences.getInstance().then((prefs) {
    var themeMode = prefs.getInt('themeMode') ?? 0;

    runApp(
      ChangeNotifierProvider<ThemeModeNotifier>(
        create: (_) =>
            ThemeModeNotifier(ThemeMode.values[themeMode]),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider(),),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.getThemeMode(),
          title: "Tour Guide App",
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return const BottomBarView(selectedIndex: 0,);

                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Login();
            },
          ),
        ),
    );
  }
}



