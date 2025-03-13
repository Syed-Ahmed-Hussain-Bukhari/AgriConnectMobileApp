// buyer_main.dart
import 'package:agriconnect/Controllers/FarmerController.dart';
import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:agriconnect/Controllers/TrainerController.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:flutter/material.dart';

class Maintrainer extends StatefulWidget {
  final Trainercontroller _controller = Trainercontroller();
  Maintrainer({Key? key}) : super(key: key);

  @override
  _MaintrainerState createState() => _MaintrainerState();
}

class _MaintrainerState extends State<Maintrainer> {
  final Farmercontroller _controller = Farmercontroller();
  String? imageUrl;
  String? username;
  String? userId;
  String? roleName;
  int? roleId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _controller.loadUserData();
    setState(() {
      imageUrl = userData['imageUrl'];
      username = userData['username'];
      userId = userData['userId'];
      roleName = userData['roleName'];
      roleId = userData['roleId'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Main Page'),
        actions: [
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl!),
                radius: 20,
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: imageUrl == null ? const Icon(Icons.person) : null,
              ),
              accountName: Text(username ?? 'N/A'),
              accountEmail: Text(userId ?? 'N/A'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                LoginController().logout(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Welcome, $username!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
