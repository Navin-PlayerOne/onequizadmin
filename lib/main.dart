import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onequizadmin/models/test.dart';
import 'package:onequizadmin/pages/home_page.dart';
import 'package:onequizadmin/pages/questionpage.dart';
import 'package:onequizadmin/pages/testdetails.dart';
import 'package:onequizadmin/services/authstate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //       apiKey: "", appId: "", messagingSenderId: "", projectId: ""),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.dark,
                  seedColor: Colors.black,
                ),
          ),
          routes: {
            '/': (context) => AuthService().handleAuthState(),
            '/home' :(context) => HomePage(),
            '/question': ((context) => QuestionPageBuilder()),
            '/test': (context) => TestDetails(),
          },
        );
      },
    );
  }
}
