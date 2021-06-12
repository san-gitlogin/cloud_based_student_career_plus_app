import 'package:flutter/material.dart';
import 'package:theme_patrol/theme_patrol.dart';
import 'welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemePatrol(
      light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          accentColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useTextSelectionTheme: true),
      dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          accentColor: Colors.red,
          toggleableActiveColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useTextSelectionTheme: true),
      mode: ThemeMode.system,
      builder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Panimalar Student App',
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          home: WelcomeScreen(),
        );
      },
    );
  }
}
