import 'package:flutter/material.dart';
import 'package:learn_api/pages/home_page_stateless_future_builder.dart';
import 'package:learn_api/pages/login_page.dart';
import 'package:learn_api/pages/register_page.dart';
import 'package:learn_api/pages/home_page_stateful.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest Api Flutter',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) =>HomePage(),
      },
    );
  }
}
