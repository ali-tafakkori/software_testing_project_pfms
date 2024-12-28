import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
    );
    return MaterialApp(
      title: "PFMS",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}
