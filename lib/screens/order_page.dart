import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
  final TextEditingController _amountCompletedController =
      TextEditingController();
  final TextEditingController _quantityFinishedController =
      TextEditingController();
  final TextEditingController _timeRequiredController = TextEditingController();

  // Variable for Current Status dropdown selection
  String? _currentStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Status',
          style: TextStyle(
              fontFamily: 'Audiowide',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Current Status Dropdown
              DropdownButtonFormField<String>(
                value: _currentStatus,
                items: ['Completed', 'Not Completed Yet'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Current Status',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _currentStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Current Status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Conditional fields - shown only if "Not Completed Yet" is selected
              if (_currentStatus == 'Not Completed Yet') ...[
                _buildTextFormField(
                  controller: _amountCompletedController,
                  label: 'Amount Currently Completed',
                  validatorMsg: 'Please enter Amount Currently Completed',
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _quantityFinishedController,
                  label: 'Quantity To Be Finished',
                  validatorMsg: 'Please enter Quantity To Be Finished',
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _timeRequiredController,
                  label: 'Projected Timeline',
                  validatorMsg:
                      'Please enter Time required to complete the order',
                ),
                const SizedBox(height: 24),
              ],

              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitOrderData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white, // Text color inside the text box
        fontSize: 18, // Font size
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white, // Label color
          fontSize: 18,
        ),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, // Outline color when not focused
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.blue), // Outline color when focused
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }

  // Function to submit data to the backend
  Future<void> _submitOrderData() async {
    final Map<String, dynamic> payload = {
      'current_status': _currentStatus,
    };

    if (_currentStatus == 'Not Completed Yet') {
      payload.addAll({
        'amount_completed': _amountCompletedController.text,
        'quantity_to_be_finished': _quantityFinishedController.text,
        'projected_timeline': _timeRequiredController.text,
      });
    }

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:3000/submit-order'), // Replace with your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order submitted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/employee_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit order.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
