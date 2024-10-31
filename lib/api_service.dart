import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static const String apiUrl = 'http://10.0.2.2:3000';

  // Login functionality
  static Future<Map<String, dynamic>> login(
      String userId, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'password': password}),
    );
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : {'success': false, 'message': 'Login failed'};
  }

  // Password reset functionality
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$apiUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : {'success': false, 'message': 'Failed to send OTP'};
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$apiUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : {'success': false, 'message': 'Password reset failed'};
  }

  // Change password functionality
  static Future<Map<String, dynamic>> changePassword(
      String userId, String oldPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      return response.statusCode == 200
          ? jsonDecode(response.body)
          : {'success': false, 'message': 'Failed to change password'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static updateSubordinate(
      String string, String text, String text2, String text3, String gender) {}

  static addSubordinate(
      String text, String text2, String text3, String gender) {}

  static verifyOtp(String email, String text) {}

  static getSubordinates() {}

  static deleteSubordinate(String id) {}

  // Additional functions (add/update/verify subordinates) can be implemented here
}

class ApplyLeavePage extends StatefulWidget {
  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userRoleController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedLeaveType;

  get formattedFromDate => null;

  get formattedToDate => null;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy/MM/dd')
          .format(picked); // Set the date in dd/MM/yyyy format
    }
  }

  Future<void> _submitLeaveRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get user ID from shared preferences
        final String userId = await SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('user_id') ?? '');

        final Map<String, dynamic> formData = {
          'user_id': userId,
          'user_role': _userRoleController.text,
          'leave_type': _selectedLeaveType!,
          'from_date': formattedFromDate,
          'to_date': formattedToDate,
          'reason': _reasonController.text,
        };

        // Send data to the backend API
        final response = await http.post(
          Uri.parse('${ApiService.apiUrl}/apply-leave'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Leave application submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  errorData['message'] ?? 'Failed to submit leave application'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userRoleController,
                decoration: InputDecoration(labelText: 'User Role'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter user role' : null,
              ),
              TextFormField(
                controller: _fromDateController,
                decoration:
                    InputDecoration(labelText: 'From Date (dd/MM/yyyy)'),
                readOnly: true,
                onTap: () => _selectDate(context, _fromDateController),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter from date' : null,
              ),
              TextFormField(
                controller: _toDateController,
                decoration: InputDecoration(labelText: 'To Date (dd/MM/yyyy)'),
                readOnly: true,
                onTap: () => _selectDate(context, _toDateController),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter to date' : null,
              ),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter reason' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Leave Type'),
                value: _selectedLeaveType,
                items: ['Sick Leave', 'Casual Leave', 'Annual Leave']
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLeaveType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select leave type' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLeaveRequest,
                child: Text('Submit Leave Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
