import 'package:agriconnect/Controllers/FarmerController.dart';
import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Farmer/AddCrop.dart';
import 'package:agriconnect/Views/Farmer/Complete_order.dart';
import 'package:agriconnect/Views/Farmer/cropslist.dart';
import 'package:agriconnect/Views/Farmer/histoty_order.dart';
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

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CropListScreen(),
    AddCrop(),
    FarmerOrdersScreen(),
  ];

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
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
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
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Add Crop'),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
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
              leading: const Icon(Icons.settings),
              title: const Text('History Order'),
              onTap: () {
                                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FarmerHistotyOrder()),
                );
              },
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Crop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Order',
          ),
        ],
      ),
    );
  }
}
