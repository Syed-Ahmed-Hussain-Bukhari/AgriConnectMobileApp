// buyer_main.dart
import 'package:agriconnect/Controllers/FarmerController.dart';
import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Farmer/AddCrop.dart';
import 'package:flutter/material.dart';

class FarmerMain extends StatefulWidget {
  final LoginController _controller = LoginController();
  FarmerMain({Key? key}) : super(key: key);

  @override
  _FarmerMainState createState() => _FarmerMainState();
}

class _FarmerMainState extends State<FarmerMain> {
  final Farmercontroller _controller = Farmercontroller();
  String? imageUrl;
  String? username;
  String? userId;
  String? roleName;
  String? roleId;

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
              title: const Text('Add Crop'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCrop()),
                );
              },
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
