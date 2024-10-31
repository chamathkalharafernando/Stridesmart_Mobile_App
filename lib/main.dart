import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/screens/landing_page.dart';
import 'package:login_signup_flow_app/screens/home_page.dart';
import 'package:login_signup_flow_app/screens/driver_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const LandingPage(), // Root route for landing page
        '/employee_home': (context) => const HomePage(),
        '/driver_home': (context) => const DriverHomePage(),
      },
    );
  }
}
