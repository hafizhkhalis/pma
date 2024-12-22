import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
  getDatabasePath();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
      },
    );
  }
}

Future<void> getDatabasePath() async {
  final dbPath = await getDatabasesPath();
  print('$dbPath');
}
