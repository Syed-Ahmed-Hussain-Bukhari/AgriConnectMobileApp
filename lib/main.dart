// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Picker Example',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const ImagePickerScreen(),
//     );
//   }
// }

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   _ImagePickerScreenState createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       setState(() => _isLoading = true);

//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 600, // Resize to reduce file size
//         maxHeight: 600,
//         imageQuality: 80, // Compress image quality
//       );

//       if (image != null) {
//         setState(() {
//           _image = File(image.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Picker Example')),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _image == null
//                 ? const Text('No image selected.')
//                 : Image.file(_image!),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             tooltip: 'Pick Image from Gallery',
//             child: const Icon(Icons.photo_library),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             onPressed: () => _pickImage(ImageSource.camera),
//             tooltip: 'Capture Image with Camera',
//             child: const Icon(Icons.camera_alt),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:agriconnect/Views/Authentication/Login.dart';
import 'package:agriconnect/Views/Authentication/signUp.dart';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:agriconnect/Views/Common/profile_screen.dart';
import 'package:agriconnect/Views/Farmer/mainFarmer.dart';
import 'package:agriconnect/Views/StartScreen/OnboardScreen1.dart';
import 'package:agriconnect/Views/StartScreen/SplashScree.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: ProfileScreen(),
      // home: BuyerMain(),
      home: SplashScreen(),
      // home: signUpScreen(),
      // home: BuyerMain(),
      // home: OnboardScreen1(),
      // home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}


