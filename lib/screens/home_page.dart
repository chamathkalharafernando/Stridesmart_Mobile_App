import 'package:flutter/material.dart';
import 'package:login_signup_flow_app/screens/sign_in_page.dart';
import 'package:login_signup_flow_app/screens/subordinate_page.dart';
import 'apply_leave_page.dart'; // Import the ApplyLeavePage
import 'order_page.dart'; // Import the OrderPage
import 'settings_page.dart'; // Import Settings Page

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: const Text(
          'OUR SERVICES',
          style: TextStyle(
            fontFamily: 'Audiowide',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmation(context); // Show logout confirmation
            },
            icon: const Icon(
              Icons.logout, // Set the icon to logout
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(
                    name: '',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int columns = (screenSize.width < 600) ? 2 : 3;

            return GridView.count(
              crossAxisCount: columns,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 1.0,
              children: [
                buildServiceTile('Subordinate', context),
                buildServiceTile('Order', context),
                buildServiceTile('Raw Material', context),
                buildServiceTile('Salary', context),
                buildServiceTile('Leave', context),
                buildServiceTile('Status', context),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildServiceTile(String title, BuildContext context) {
    IconData iconData;

    switch (title) {
      case 'Subordinate':
        iconData = Icons.group;
        break;
      case 'Order':
        iconData = Icons.shopping_cart;
        break;
      case 'Raw Material':
        iconData = Icons.inventory;
        break;
      case 'Salary':
        iconData = Icons.money;
        break;
      case 'Leave':
        iconData = Icons.calendar_today;
        break;
      case 'Status':
        iconData = Icons.info;
        break;
      default:
        iconData = Icons.help;
    }

    return GestureDetector(
      onTap: () {
        if (title == 'Subordinate') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubordinateScreen(),
            ),
          );
        } else if (title == 'Leave') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplyLeavePage(),
            ),
          );
        } else if (title == 'Status') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderPage(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            Icon(
              iconData,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
