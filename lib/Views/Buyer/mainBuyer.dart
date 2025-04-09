import 'package:agriconnect/Components/customButton.dart';
import 'package:agriconnect/Components/customSize.dart';
import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:agriconnect/Controllers/buyerController.dart';
import 'package:agriconnect/Models/CropModel.dart';
import 'package:agriconnect/Views/Buyer/BuyerTransection.dart';
import 'package:agriconnect/Views/Buyer/confirmedOrder.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Order/detailed.dart';
import 'package:agriconnect/Views/Order/shoppingCard.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerMain extends StatefulWidget {
  BuyerMain({Key? key}) : super(key: key);

  @override
  _BuyerMainState createState() => _BuyerMainState();
}

class _BuyerMainState extends State<BuyerMain> {
  final BuyerController _controller = BuyerController();
  List<Crop> crops = [];
  List<Crop> filteredCrops = [];
  bool isLoading = true;
  String? imageUrl;
  String? username;
  int? userId;
  String? roleName;
  String categoryFilter = "";
  String nameFilter = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCrops();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      imageUrl = prefs.getString('imageUrl');
      userId = prefs.getInt('userId');
      roleName = prefs.getString('roleName');
    });
  }

  Future<void> fetchCrops() async {
    final url = Uri.parse('http://152.67.10.128:5280/api/Order/Available-crop');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> values = data['\$values'];
        setState(() {
          crops = values.map((crop) => Crop.fromJson(crop)).toList();
          filteredCrops = crops;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('Error fetching crops: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCrops() {
    setState(() {
      filteredCrops = crops.where((crop) {
        final categoryMatch = categoryFilter.isEmpty ||
            crop.category.toLowerCase().contains(categoryFilter.toLowerCase());
        final nameMatch = nameFilter.isEmpty ||
            crop.name.toLowerCase().contains(nameFilter.toLowerCase());
        return categoryMatch && nameMatch;
      }).toList();
    });
  }

  Widget _buildHomeScreen() {
    return Column(
      children: [
          SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
          //     Expanded(
          //       child: TextField(
          //           cursorColor:  MyColors.primaryColor,
                  
          //         decoration: InputDecoration(
          //            hintText: "Category",
       
          // filled: true,
          // fillColor: Colors.white, // Background color
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12), // Rounded borders
          //   borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(color: MyColors.grey, width: 1.5),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
          // ),
          // contentPadding:
          //     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          
          //          ),
          //         onChanged: (value) {
          //           categoryFilter = value;
          //           _filterCrops();
          //         },
          //       ),
          //     ),
          //     SizedBox(width: 8),
              Expanded(
                child: TextField(
                    cursorColor:  MyColors.primaryColor,
                  
                  decoration: InputDecoration(
                       hintText: "Search in here by Name",
       
          filled: true,
          fillColor: Colors.white, // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded borders
            borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MyColors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
          ),
          suffixIcon: Icon(Icons.search,color:MyColors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          
                    ),
                  onChanged: (value) {
                    nameFilter = value;
                    _filterCrops();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredCrops.length,
                  itemBuilder: (context, index) {
                    return CropCard(crop: filteredCrops[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProfileScreen() {
    return ProfileScreen();
  }

  Widget _buildshopingscrenn() {
    return ShoppingScreen();
  }

  // Widget _buildShoppingScreen() {
  //   return Center(child: Text('Shopping Cart Screen'));
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title:   Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
                      "Abhi Buy Kare  Sasta and taza fasal", 
                     maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 24,
                        height:  1,
                        // fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor,
                        // color: MyColors.secondaryColor,
                      ),
                    ),

                    
        ),
        
        // Text('Buyer Main Page'),
        actions: [
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                      margin: EdgeInsets.only(top: 4),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl!),
                  radius: 30,
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                 decoration: BoxDecoration(
            color:MyColors.primaryColor ,
            ),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: imageUrl == null ? const Icon(Icons.person) : null,
              ),

               accountName: Text(
                      username ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.backgroundScaffoldColor
                      ),
                    ),
              
             accountEmail:Text(
                      "${username}.@gmailcom" ?? "N/A",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.backgroundScaffoldColor
                      ),
                    ),
              // accountName: 
              // Text('${username}'),
              // accountEmail: Text('${userId}'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title:  Text(
                      "Home",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              
              // title: const Text('Home'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.person),
               title:  Text(
                      "Profile",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
               title:  Text(
                      "Cart",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
             
              onTap: () => _onItemTapped(2),
            ),
            // ListTile(
            //   leading: const Icon(Icons.logout),
            //   title: const Text('Logout'),
            //   onTap: () {
            //     LoginController().logout(context);
            //   },
            // ),
            ListTile(
                 title:  Text(
                      "Ordered",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              leading: const Icon(Icons.shopping_cart_rounded),
          
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmedOrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
             
                title:  Text(
                      "Transaction",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransactionScreen(userId: userId!)),
                );
              },
            ),

             Row(
               children: [
                 Container(
                             margin: EdgeInsets.only(left: 8,top: 24),
                             child:    CustomButton(
                              radius: CustomSize().customWidth(context) / 10,
                              height: CustomSize().customHeight(context) / 15,
                              width: CustomSize().customWidth(context)/2 ,
                              title: "Logout",
                              
                              loading: false,
                              color: MyColors.primaryColor,
                              onTap: () {
                                 LoginController().logout(context);
                             
                              },
                            ),
                 ),
               ],
             )
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(),
          _buildProfileScreen(),
          ShoppingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
            unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MyColors.black,
        ),

         selectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MyColors.primaryColor,
        ),

                    
        backgroundColor: Colors.white,
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: MyColors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            // Assuming ShoppingScreen is at index 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShoppingScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final Crop crop;

  CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDetailScreen(
              name: crop.name,
              category: crop.category,
              imageUrl: crop.imageUrl,
              price: crop.price,
              quantity: crop.quantity,
              farmerId: crop.farmerId,
              cropid: crop.cropId,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  crop.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
                 Text(
                      crop.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MyColors.black
                      ),
                    ),
              // Text(
              //   crop.name,
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child:
              Text(
                      'Price: ${crop.price} per kg',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MyColors.primaryColor
                      ),
                    ),
              //  Text(
              //   'Price: ${crop.price} per kg',
              //   style: TextStyle(fontSize: 14, color: Colors.green),
              // ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
