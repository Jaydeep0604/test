import 'package:flutter/material.dart';
import 'repo/base_dio_helper.dart';
import 'resources/colors.dart';
import 'screens/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
        scaffoldBackgroundColor: colorWhite,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
