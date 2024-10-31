import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  double _passwordStrength = 0; // Variable to store password strength

  // Function to check password strength
  void _checkPasswordStrength(String password) {
    double strength = 0;

    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.25;

    setState(() {
      _passwordStrength = strength; // Update the strength value
    });
  }

  // Function to get color based on strength
  Color _getStrengthColor(double strength) {
    if (strength == 0) return Colors.white;
    if (strength <= 0.25) return Colors.red;
    if (strength <= 0.50) return Colors.orange;
    if (strength <= 0.75) return Colors.yellow;
    return Colors.green;
  }

  // Function to get text for strength description
  String _getStrengthText(double strength) {
    if (strength == 0) return 'Enter a password';
    if (strength <= 0.25) return 'Weak';
    if (strength <= 0.50) return 'Medium';
    if (strength <= 0.75) return 'Strong';
    return 'Very Strong';
  }

  // Function to handle password change logic
  Future<void> _changePassword() async {
    // Assuming you have the user ID available
    String userId = "USER_ID"; // Replace with the actual user ID
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    // Call your API to verify the current password
    final response =
        await ApiService.verifyCurrentPassword(userId, currentPassword);
    if (response['success']) {
      // If current password is correct, proceed to change the password
      final changeResponse =
          await ApiService.changePassword(userId, newPassword);

      if (changeResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                changeResponse['message']), // Display error message from API
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[
              'message']), // Display error message for wrong current password
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password',
            style: TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Password must be at least 8 characters long, contain uppercase letters, numbers, and special characters.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16.0),

              // Current password field
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              // New password field
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter the New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  _checkPasswordStrength(value); // Check strength on change
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              // Password strength indicator
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      color: _getStrengthColor(_passwordStrength),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _getStrengthText(_passwordStrength),
                    style: TextStyle(
                      color: _getStrengthColor(_passwordStrength),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Confirm password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm The New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm the new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Submit and Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _changePassword(); // Call the change password function
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please fill in all the required fields'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: const Text('SUBMIT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChangePasswordPage(),
  ));
}

// Dummy ApiService class for demonstration
class ApiService {
  static Future<Map<String, dynamic>> verifyCurrentPassword(
      String userId, String currentPassword) async {
    // Simulate an API call to verify the current password
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    // Replace the below line with actual API call logic
    return {'success': true}; // Change to false to simulate incorrect password
  }

  static Future<Map<String, dynamic>> changePassword(
      String userId, String newPassword) async {
    // Simulate an API call to change the password
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    // Replace the below line with actual API call logic
    return {'success': true}; // Change to false to simulate change failure
  }
}
