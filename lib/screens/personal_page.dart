import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'change_password_page.dart';
import 'sign_in_page.dart';

class SettingsPage extends StatefulWidget {
  final String name;

  const SettingsPage({super.key, required this.name});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profileImage;
  String _selectedLanguage = 'English';
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Sinhala'].map((language) {
            return RadioListTile(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Settings',
            style: TextStyle(fontFamily: 'Audiowide', color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileImage(),
                    const SizedBox(height: 10),
                    Text(_name, style: _textStyle(20)),
                    const SizedBox(height: 30),
                    ListTile(
                      title: const Text('Language',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      trailing: Text(_selectedLanguage,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      onTap: _selectLanguage,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSettingsButton(
                    'Personal',
                    PersonalSettingsPage(
                        onNameChanged: (name) => setState(() => _name = name))),
                const SizedBox(height: 10),
                _buildSettingsButton(
                    'Change Password', const ChangePasswordPage()),
                const SizedBox(height: 10),
                _buildLogoutButton(),
              ],
            ),
          ),
          Container(height: 50, color: Colors.deepPurple),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage('assets/default_user_icon.png')
                    as ImageProvider,
            child: _profileImage == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.red),
              onPressed: _pickImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(String title, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.black54,
      ),
      child: Text(title, style: _textStyle(18)),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () => _confirmLogout(),
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Log Out',
          style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.black54,
      ),
    );
  }

  Future<void> _confirmLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle(double fontSize) {
    return TextStyle(
        color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);
  }
}

class PersonalSettingsPage extends StatefulWidget {
  final ValueChanged<String> onNameChanged;

  const PersonalSettingsPage({super.key, required this.onNameChanged});

  @override
  _PersonalSettingsPageState createState() => _PersonalSettingsPageState();
}

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> updateEmployee() async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/update-employee'); // Update with your server URL

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': _firstNameController.text,
        'address': _addressController.text,
        'contactNumber': _contactNumberController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      widget.onNameChanged(_firstNameController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile: ${response.body}'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Personal',
              style: TextStyle(fontFamily: 'Audiowide', color: Colors.white)),
          backgroundColor: Colors.deepPurple),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  _firstNameController, 'Name', 'Please enter your name'),
              const SizedBox(height: 16),
              _buildTextField(_addressController, 'Address', null),
              const SizedBox(height: 16),
              _buildTextField(_contactNumberController, 'Contact Number', null,
                  TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'Email',
                  'Please enter your email', TextInputType.emailAddress),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateEmployee();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black54,
                ),
                child: const Text('Save Changes',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String? validationMessage,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validationMessage != null
          ? (value) => value == null || value.isEmpty ? validationMessage : null
          : null,
      keyboardType: keyboardType,
    );
  }
}
