import 'dart:convert';
import 'package:agriconnect/Components/customButton.dart';
import 'package:agriconnect/Components/customSize.dart';
import 'package:agriconnect/Components/inputField.dart';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Farmer/mainFarmer.dart';
import 'package:agriconnect/Views/Trainer/mainTrainer.dart';
import 'package:agriconnect/Views/Transporter/mainTransporter.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<Map<String, dynamic>> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url =
        'http://152.67.10.128:5280/api/auth/Get-Data-Token?token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile data.");
    }
  }

  Future<void> _navigateBack(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final roleName = prefs.getString('roleName') ?? '';

    switch (roleName) {
      case 'Buyer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuyerMain()),
        );
        break;
      case 'Farmer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FarmerMain()),
        );
        break;
      case 'Transporter':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Maintransporter()),
        );
        break;
      case 'Trainer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Maintrainer()),
        );
        break;
      default:
        Navigator.pop(context); // Go back to the previous screen
    }
  }
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController locationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _navigateBack(context);
        return false; // Prevent default back behavior
      },
      child: Scaffold(
       
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No Data Available"));
            }

            final userData = snapshot.data!;
            final imageUrl = userData['imageUrl'] ?? '';
            final username = userData['userName'] ?? 'Unknown';
            final email = userData['email'] ?? 'No Email';
            final phoneNumber = userData['phoneNumber'] ?? 'No Phone';
            final address = userData['address'] ?? 'No Address';
            final roleName = userData['role']?['name'] ?? 'No Role';
            final isActive = userData['isactive'] ?? false;

            return SingleChildScrollView(
              child: Column(
                children: [
                Stack(
  children: [
   
Stack(
  children: [
    // Top container with background color and centered title
    Container(
      height: 200,
      width: double.infinity,
      color: MyColors.primaryColor,
      child:  Stack(
        children: [
          // Back Icon on the left
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: (){
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
   
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: MyColors.backgroundScaffoldColor,
              ),
            ),
          ),

          // Centered title
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: MyColors.backgroundScaffoldColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    // Avatar image with edit icon overlay
    Container(
      margin: EdgeInsets.only(top: 120),
      child: Center(
        child: Stack(
          children: [
            // Avatar
          Stack(
  children: [
    Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        color: Colors.white,
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : AssetImage('assets/default_avatar.png') as ImageProvider,
      ),
    ),
    Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child:Image.asset("assets/gallery.png",width: 24,height:24,)
      ),
    ),
  ],
)

            // Edit icon at bottom right of avatar
         
          ],
        ),
      ),
    ),
  ],
)



    // Profile Avatar
    
  ],
),
                  const SizedBox(height: 15),
                    // Text(
                    //   username,
                    //   style: GoogleFonts.inter(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w700,
                    //     color: MyColors.primaryColor
                    //   ),
                    // ),
                    Text(
                    username, 
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 28,
                      height:  0.9,
                      // fontWeight: FontWeight.bold,
                      color: MyColors.profileColor,
                      // color: MyColors.secondaryColor,
                    ),
                  ),
                   SizedBox(height: 30,),
           
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: MyTextField(
                emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress
              ),
            ),
             SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
            
              child: MyTextField(
                passwordController,
                hintText: "Enter your password",
                prefixIcon: Icons.phone,
                isPassword: true, // Hide password
              ),
            ),
             SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: MyTextField(
                phoneController,
                hintText: "Enter your phone",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.phone
              ),
            ),
             SizedBox(height: 30,),
             Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: MyTextField(
                locationController,
                hintText: "Enter your location",
                prefixIcon: Icons.location_on_outlined,
                keyboardType: TextInputType.emailAddress
              ),
            ),
             SizedBox(height: 30,),
      
           Container(
            margin: EdgeInsets.only(left: 15,right: 15),
            child:    CustomButton(
                          radius: CustomSize().customWidth(context) / 10,
                          height: CustomSize().customHeight(context) / 15,
                          width: CustomSize().customWidth(context) /2,
                          title: "Update",
                          
                          loading: false,
                          color: MyColors.primaryColor,
                          onTap: () {
                        
                          },
                        ),
           ),
                        SizedBox(height: 30,),
                 
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
