import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/ingredient_scanner_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Transparent status bar for full-screen camera experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const KinRaiDeeApp());
}

class KinRaiDeeApp extends StatelessWidget {
  const KinRaiDeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'กินไรดี',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9100), // Vibrant Orange
          primary: const Color(0xFFFF9100),
        ),
        fontFamily: 'Roboto', // Fallback
      ),
      home: const IngredientScannerScreen(),
    );
  }
}
