import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'change_password_page.dart';
import 'personal_page.dart';
import 'sign_in_page.dart'; // Import the sign-in page

class SettingsPage extends StatefulWidget {
  final String name;

  const SettingsPage({Key? key, required this.name}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profileImage;
  String _selectedLanguage = 'English'; // Default language
  late String _name; // Track name separately for state updates

  @override
  void initState() {
    super.initState();
    _name = widget.name; // Initialize the name from the constructor
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <String>['English', 'Sinhala'].map((String language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                    Navigator.pop(context); // Close the dialog after selection
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateName(String newName) {
    setState(() {
      _name = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Settings - $_name',
          style: const TextStyle(
            fontFamily: 'Audiowide',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage(
                                        'assets/default_user_icon.png') // Use a default user icon
                                    as ImageProvider,
                            child: _profileImage == null
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.white)
                                : null, // Show icon only if no image
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.red),
                              onPressed: _pickImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Change the profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      title: const Text(
                        'Language',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        _selectedLanguage,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onTap: _selectLanguage, // Open the interactive dropdown
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: Column(
              children: [
                _buildSettingsButton(
                  'Personal',
                  context,
                  PersonalSettingsPage(onNameChanged: _updateName),
                ),
                const SizedBox(height: 10),
                _buildSettingsButton(
                  'Change Password',
                  context,
                  const ChangePasswordPage(),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Log Out"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignInPage()),
                                );
                              },
                              child: const Text("Log Out"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.deepPurple,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(
    String title,
    BuildContext context,
    Widget page,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.black54,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
