import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fullstack/firebase_options.dart';
import 'package:fullstack/providers/user_provider.dart';
import 'package:fullstack/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            fontFamily: "Poppins"),
        home: SplashScreen(),
      ),
    );
  }
}
