import 'package:flutter/material.dart';
import 'package:mobile_quran/views/home.dart';
import 'package:mobile_quran/views/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_quran/models/user.dart';

main() async {
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(UserAdapter());
  // Opening the box
  await Hive.openBox('userBox');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Al-Quran',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
