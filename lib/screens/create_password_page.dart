import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart';
import 'package:login_signup_flow_app/screens/password_created_page.dart'; // For navigating to Password Created page

class CreatePasswordScreen extends StatefulWidget {
  final String email;

  const CreatePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Function to reset password
  Future<void> _resetPassword() async {
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the ApiService to reset the password
      final result = await ApiService.resetPassword(
          widget.email, _passwordController.text);

      if (result['success'] == true) {
        // Navigate to PasswordCreatedScreen after successful password reset
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PasswordCreatedScreen(),
          ),
        );
      } else {
        // Show error message from API response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Failed to reset password')),
        );
      }
    } catch (e) {
      // Log the error and display a snackbar
      if (kDebugMode) {
        print("Error resetting password: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to reset password")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Color(0xFFF3E5F5); // Softer light purple color
    final Color appBarColor = Color(0xFF7B1FA2); // Dark purple for app bar
    final Color buttonColor = Color(0xFF6A1B9A); // Vibrant purple for buttons
    final Color textColor =
        Color.fromARGB(255, 105, 54, 244); // Title text color

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Create New Password",
                  style: TextStyle(
                    fontFamily: 'Audiowide',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 105, 54, 244),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Your new password must be unique from those previously used.",
                  style: TextStyle(
                    color: Color.fromARGB(172, 0, 3, 7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(color: textColor), // Color for label
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(color: textColor), // Color for label
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Vibrant purple for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
