import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme:
            const IconThemeData(color: Colors.white), // White arrow color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'History Details',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            _buildAdvancedDropdown(),
            // Add any additional widgets for displaying history data
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedDropdown() {
    String selectedValue = 'Today';
    List<String> dropdownItems = ['Today', 'Last Week', 'Last Month'];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            underline: Container(),
            dropdownColor: Colors.deepPurple,
            style: const TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
