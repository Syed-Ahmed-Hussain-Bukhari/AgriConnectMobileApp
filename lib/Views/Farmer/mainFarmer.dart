// buyer_main.dart
import 'package:agriconnect/Components/customButton.dart';
import 'package:agriconnect/Components/customSize.dart';
import 'package:agriconnect/Controllers/FarmerController.dart';
import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Farmer/AddCrop.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
      
        title:
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
                      "Apni Fasal ko Munasib price mai sale kare", 
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
          // Text(
          //             'Abhi Buy Kare  Sasta and taza fasal',
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //             style: GoogleFonts.inter(
                        
          //               fontSize: 20,
          //               fontWeight: FontWeight.w700,
          //               color: MyColors.primaryColor
          //             ),
          //           ),
        
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
              // accountEmail: Text(userId ?? 'N/A'),
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
              
             
              onTap: () {},
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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
           
                title:  Text(
                      "Add Crop",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCrop()),
                );
              },
            ),
            ListTile(
                 title:  Text(
                      "Messages",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
              leading: const Icon(Icons.message),
              
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
                title:  Text(
                      "Settings",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black
                      ),
                    ),
             
              onTap: () {},
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
            // ListTile(
            //   leading: const Icon(Icons.logout),
            //   title: const Text('Logout'),
            //   onTap: () {
            //     LoginController().logout(context);
            //   },
            // ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child:
               Text(
                       'Welcome, $username!',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: MyColors.black
                      ),
                    ),
            
            ),
          ],
        ),
      ),
    );
  }
}
