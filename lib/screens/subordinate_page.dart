import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/api_service.dart';
import 'add_subordinate_page.dart';
import 'package:http/http.dart' as http;

class SubordinateScreen extends StatefulWidget {
  const SubordinateScreen({Key? key}) : super(key: key);

  @override
  _SubordinateScreenState createState() => _SubordinateScreenState();
}

class _SubordinateScreenState extends State<SubordinateScreen> {
  List<dynamic> subordinates = [];

  @override
  void initState() {
    super.initState();
    _fetchSubordinates();
  }

  // Fetch subordinate data from the database
  // Future<void> _fetchSubordinates() async {
  //   try {
  //     List<dynamic> fetchedSubordinates = await ApiService.getSubordinates();
  //     setState(() {
  //       subordinates = fetchedSubordinates;
  //     });
  //   } catch (error) {
  //     print('Failed to load subordinates: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to load subordinates')),
  //     );
  //   }
  // }

  Future<void> _fetchSubordinates() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/get-subordinates'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['subordinates'];
        setState(() {
          subordinates =
              data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      } else {
        throw Exception('Failed to load subordinates');
      }
    } catch (error) {
      print('Failed to load subordinates: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load subordinates')),
      );
    }
  }

  // Delete a subordinate and refresh the list
  Future<void> _deleteSubordinate(String id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            const Text('Are you sure you want to delete this subordinate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final url = 'http://10.0.2.2:3000/delete-subordinate/$id';

      try {
        final response = await http.delete(Uri.parse(url));

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subordinate deleted successfully')),
          );
          _fetchSubordinates(); // Refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete subordinate')),
          );
        }
      } catch (error) {
        print('Failed to delete subordinate: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete subordinate')),
        );
      }
    }
  }

  // Navigate to add or edit subordinate form
  void _addOrEditSubordinate([Map<String, dynamic>? existingSubordinate]) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                AddSubordinateForm(existingSubordinate: existingSubordinate),
          ),
        )
        .then((_) => _fetchSubordinates()); // Refresh after adding/editing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title:
            const Text('Subordinates', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back arrow to white
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Subordinate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  onPressed: () => _addOrEditSubordinate(),
                ),
              ],
            ),
          ),
          Expanded(
            child: subordinates.isEmpty
                ? const Center(
                    child: Text(
                      'No subordinates found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: subordinates.length,
                    itemBuilder: (context, index) {
                      final subordinate = subordinates[index];
                      return Card(
                        color: Colors.black54,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          leading: Icon(
                            subordinate['gender'] == 'male'
                                ? Icons.male
                                : Icons.female,
                            color: Colors.white,
                          ),
                          title: Text(
                            subordinate['name'] ?? 'N/A',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subordinate['contactNumber'] ?? 'No contact',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                subordinate['address'] ?? 'No address',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () =>
                                    _addOrEditSubordinate(subordinate),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSubordinate(
                                    subordinate['id'].toString()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
