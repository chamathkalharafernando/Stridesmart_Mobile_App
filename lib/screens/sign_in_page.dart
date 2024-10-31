import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart';
import 'package:login_signup_flow_app/screens/home_page.dart';
import 'package:login_signup_flow_app/screens/driver_home_page.dart';
import 'package:login_signup_flow_app/screens/forgot_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        _idController.text,
        _passwordController.text,
      );

      if (result['success']) {
        final role = result['role'];
        if (role == 'employee') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (role == 'driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverHomePage(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.deepPurple,
        width: double.infinity, // Makes the container full width
        height: double.infinity, // Makes the container full height
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Audiowide',
                            letterSpacing: 4.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo1.jpg',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: 'ID',
                      isPassword: false,
                      context: context,
                      controller: _idController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Enter password',
                      isPassword: true,
                      context: context,
                      controller: _passwordController,
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'LOGIN',
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required bool isPassword,
    required BuildContext context,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontSize: 18,
      ),
    );
  }
}
