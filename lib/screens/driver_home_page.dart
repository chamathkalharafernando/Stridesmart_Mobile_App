import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/screens/landing_page.dart';
import 'package:login_signup_flow_app/screens/history_page.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  Widget _buildInteractiveBox(String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the landing page when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
        return false; // Prevents the default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: const Text(
            'Our Services',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme:
              const IconThemeData(color: Colors.white), // White arrow color
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInteractiveBox('Product Order Deliver', () {
                // Add navigation or functionality for this box
              }),
              _buildInteractiveBox('Raw Material Deliver', () {
                // Add navigation or functionality for this box
              }),
              _buildInteractiveBox('History', () {
                // Navigate to HistoryPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                ); // Add navigation or functionality for this box
              }),
            ],
          ),
        ),
      ),
    );
  }
}
