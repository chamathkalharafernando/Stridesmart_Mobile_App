import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart'; // Import your API service
import 'package:http/http.dart' as http;

class AddSubordinateForm extends StatefulWidget {
  final Map<String, dynamic>?
      existingSubordinate; // Optional parameter for existing subordinate

  const AddSubordinateForm({Key? key, this.existingSubordinate})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddSubordinateFormState createState() => _AddSubordinateFormState();
}

class _AddSubordinateFormState extends State<AddSubordinateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'male';
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingSubordinate != null) {
      isUpdate = true; // Update mode
      _nameController.text = widget.existingSubordinate!['name'] ?? '';
      _contactNumberController.text =
          widget.existingSubordinate!['contactNumber'] ?? '';
      _addressController.text = widget.existingSubordinate!['address'] ?? '';
      _gender = widget.existingSubordinate!['gender'] ?? 'male';
    }
  }

  // Future<void> _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     final url = isUpdate
  //         ? 'http://10.0.2.2:3000/update-subordinate/${widget.existingSubordinate!['id']}'
  //         : 'http://10.0.2.2:3000/add-subordinate';

  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'name': _nameController.text,
  //         'address': _addressController.text,
  //         'contactNumber': _contactNumberController.text,
  //         'gender': _gender,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text(isUpdate
  //                 ? 'Subordinate updated successfully'
  //                 : 'Subordinate added successfully')),
  //       );
  //       Navigator.pop(context);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Failed to submit subordinate')),
  //       );
  //     }
  //   }
  // }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = isUpdate
          ? 'http://10.0.2.2:3000/update-subordinate/${widget.existingSubordinate!['id']}'
          : 'http://10.0.2.2:3000/add-subordinate';

      final response = isUpdate
          ? await http.put(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'name': _nameController.text,
                'address': _addressController.text,
                'contactNumber': _contactNumberController.text,
                'gender': _gender,
              }),
            )
          : await http.post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'name': _nameController.text,
                'address': _addressController.text,
                'contactNumber': _contactNumberController.text,
                'gender': _gender,
              }),
            );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isUpdate
                  ? 'Subordinate updated successfully'
                  : 'Subordinate added successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit subordinate')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Update Subordinate' : 'Add New Subordinate',
          style: const TextStyle(
            fontFamily: 'Audiowide',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Black border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black), // Black border color when focused
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Radio<String>(
                    value: 'male',
                    groupValue: _gender,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.red),
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Male',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Radio<String>(
                    value: 'female',
                    groupValue: _gender,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.red),
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Female',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 16.0),
                  ),
                  child: Text(
                    isUpdate ? 'Update Subordinate' : 'Add Subordinate',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
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
    _nameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
