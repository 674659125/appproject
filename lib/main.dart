import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page1/page1_scanner_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          seedColor: const Color(0xFFFF9100),
          primary: const Color(0xFFFF9100),
        ),
      ),
      home: const Page1ScannerScreen(),
    );
  }
}
