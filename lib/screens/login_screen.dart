import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data'; // Add this import

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String decryptPassword(String encryptedData, String username) {
    final parts = encryptedData.split(':');

    final encryptedPassword = parts[0];
    final ivString = parts[1];
    final keyBytes = md5.convert(utf8.encode(username)).bytes;
    final keyUint8List = Uint8List.fromList(keyBytes);
    final key = encrypt.Key(keyUint8List);

    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter
        .decrypt(encrypt.Encrypted.fromBase64(encryptedPassword), iv: iv);

    return decrypted;
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final db = await DBHelper().database;

    // First, get the user by username only
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [_usernameController.text],
    );

    if (result.isNotEmpty) {
      final storedUser = result.first;
      final storedEncryptedPassword = storedUser['password'] as String;

      // Decrypt the stored password
      final decryptedPassword =
          decryptPassword(storedEncryptedPassword, _usernameController.text);

      // Compare with user input
      if (decryptedPassword == _passwordController.text) {
        final userId = storedUser['id'] as int;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
