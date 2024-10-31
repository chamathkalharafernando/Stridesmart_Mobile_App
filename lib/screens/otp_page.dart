import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart';
import 'create_password_page.dart'; // Import the CreatePasswordScreen
import 'package:pinput/pinput.dart'; // Import Pinput for OTP input

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  // Function to verify OTP
  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API service to verify OTP
      final result =
          await ApiService.verifyOtp(widget.email, _otpController.text);

      if (result['success'] == true) {
        // If OTP is verified, navigate to the CreatePasswordScreen
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => CreatePasswordScreen(
                email: widget
                    .email), // Corrected the navigation to CreatePasswordScreen
          ),
        );
      } else {
        // Show error message if OTP is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Invalid OTP')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to verify OTP")),
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
// Title text color

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontFamily: 'Audiowide',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 105, 54, 244),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the verification code we just sent to your email address.",
                  style: TextStyle(
                    color: Color.fromARGB(172, 0, 3, 7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Pinput(
                  controller: _otpController,
                  length: 6, // Set OTP length to 6
                  onCompleted: (otp) {
                    // Auto-verify OTP once entered
                    _verifyOtp();
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _verifyOtp, // Disable button during loading
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
                            "Verify OTP",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
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
    _otpController.dispose();
    super.dispose();
  }
}
