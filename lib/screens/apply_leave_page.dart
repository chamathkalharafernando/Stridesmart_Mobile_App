import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  String? _selectedLeaveType;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _userRoleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to submit leave application to backend
  Future<void> _submitLeaveRequest() async {
    if (_formKey.currentState!.validate()) {
      // Collect the data
      final String userId = _userIdController.text;
      final String userRole = _userRoleController.text;
      final String leaveType = _selectedLeaveType!;
      final List<String> fromParts = _fromDateController.text.split('/');
      final String fromDate =
          '${fromParts[2]}-${fromParts[1].padLeft(2, '0')}-${fromParts[0].padLeft(2, '0')}';

      final List<String> toParts = _toDateController.text.split('/');
      final String toDate =
          '${toParts[2]}-${toParts[1].padLeft(2, '0')}-${toParts[0].padLeft(2, '0')}';
      final String reason = _reasonController.text;

      // Create a map of the form data
      Map<String, dynamic> formData = {
        'user_id': userId,
        'user_role': userRole,
        'leave_type': leaveType,
        'from_date': fromDate,
        'to_date': toDate,
        'reason': reason,
      };

      // Send data to the backend API
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/apply-leave'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formData),
      );

      // Handle the response from the backend
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Navigate back to home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${jsonDecode(response.body)['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitLeaveRequest0() async {
    if (_formKey.currentState!.validate()) {
      // Collect the data
      final String userId = _userIdController.text;
      final String userRole = _userRoleController.text;
      final String leaveType = _selectedLeaveType!;

      // Format the dates to YYYY-MM-DD
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final String fromDate = dateFormat.format(DateTime.parse(
          _fromDateController.text.split('/').reversed.join('-')));
      final String toDate = dateFormat.format(
          DateTime.parse(_toDateController.text.split('/').reversed.join('-')));

      final String reason = _reasonController.text;

      // Create a map of the form data
      Map<String, dynamic> formData = {
        'user_id': userId,
        'user_role': userRole,
        'leave_type': leaveType,
        'from_date': fromDate,
        'to_date': toDate,
        'reason': reason,
      };

      // Send data to the backend API
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/apply-leave'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formData),
      );

      // Handle the response from the backend
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Navigate back to home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${jsonDecode(response.body)['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Apply Leave',
          style: TextStyle(
              fontFamily: 'Audiowide',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User ID Text Field
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your user ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // User Role Text Field
              TextFormField(
                controller: _userRoleController,
                decoration: const InputDecoration(
                  labelText: 'User Role',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Leave Type Dropdown with custom style
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Leave Type',
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                dropdownColor: Colors.deepPurple,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                value: _selectedLeaveType,
                items:
                    <String>['Annual', 'Casual', 'Medical'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLeaveType = newValue;
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 18),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a leave type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // From and To Date Fields with Calendar Picker
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fromDateController,
                      decoration: const InputDecoration(
                        labelText: 'From',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        border: UnderlineInputBorder(),
                      ),
                      readOnly: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Colors.deepPurple,
                                  onPrimary: Colors.white,
                                  surface: Colors.deepPurple,
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor: Colors.deepPurple,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _fromDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a from date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _toDateController,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        border: UnderlineInputBorder(),
                      ),
                      readOnly: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Colors.deepPurple,
                                  onPrimary: Colors.white,
                                  surface: Colors.deepPurple,
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor: Colors.deepPurple,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _toDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a to date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Reason Field
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a reason for leave';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitLeaveRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
