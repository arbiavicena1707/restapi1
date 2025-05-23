import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    final url = Uri.parse('https://reqres.in/api/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1', 
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Token: $token')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMsg = errorBody['error'] ?? 'Registrasi gagal';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
