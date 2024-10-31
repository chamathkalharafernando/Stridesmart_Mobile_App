import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart';
import 'otp_page.dart'; // Import the OTPScreen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Function to validate the email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegEx = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegEx.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Function to send OTP and navigate to OTP screen
  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Log the API request
      print('Sending OTP to ${_emailController.text}');

      // Call the API service to send the OTP
      final result = await ApiService.sendOtp(_emailController.text);

      // Log the response
      print('API response: $result');

      // Show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to send OTP')),
      );

      if (result['success'] == true) {
        // Log successful OTP send and navigate to OTPScreen
        print('OTP sent successfully, navigating to OTPScreen');

        // Navigate to OTPScreen and pass the email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(email: _emailController.text),
          ),
        );
      } else {
        // Log if OTP sending failed
        print('Failed to send OTP: ${result['message']}');
      }
    } catch (e) {
      // Log the error and show a message
      print('Error sending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5), // Softer light purple color
      appBar: AppBar(
        backgroundColor: Color(0xFF7B1FA2), // Dark purple for app bar
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: 'Audiowide',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6A1B9A), // Vibrant purple color
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email address to receive a verification code.",
                  style: TextStyle(
                    color: Color(0xFF000000), // Black color for text
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              0xFF6A1B9A)), // Vibrant purple for focused border
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: _validateEmail, // Email validation
                ),
                const SizedBox(height: 30),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF6A1B9A), // Vibrant purple for button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Send Code",
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }
}
