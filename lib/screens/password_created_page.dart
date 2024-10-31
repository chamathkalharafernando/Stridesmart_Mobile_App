import 'package:flutter/material.dart';
import 'sign_in_page.dart'; // Import SignInPage

class PasswordCreatedScreen extends StatelessWidget {
  const PasswordCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Color(0xFFF3E5F5); // Softer light purple color
// Title text color
    final Color buttonColor = Color(0xFF6A1B9A); // Vibrant purple for buttons

    return Scaffold(
      backgroundColor: backgroundColor, // Updated background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/tick.png",
              height: 100, // Adjust height as needed
              width: 100, // Adjust width as needed
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Password Changed!",
                style: TextStyle(
                  color: Color(0xFF4CAF50), // Green for success message
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Your password has been changed successfully.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            // Go to Login Button with round shape
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  color: buttonColor, // Updated button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Circular shape
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SignInPage(), // Navigate to SignInPage
                      ),
                    );
                  },
                  minWidth: 180, // Fixed width to maintain same width
                  height: 50,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Text(
                      "LOGIN", // Reduced text
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ), // Height for the round effect
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
