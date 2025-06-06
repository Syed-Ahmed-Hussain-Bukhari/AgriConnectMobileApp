// import 'package:agriconnect/Controllers/FarmerController.dart';
// import 'package:agriconnect/Controllers/buyerController.dart';
// import 'package:flutter/material.dart';

// class Farmersignup extends StatefulWidget {
//   const Farmersignup({Key? key}) : super(key: key);

//   @override
//   _FarmersignupState createState() => _FarmersignupState();
// }

// class _FarmersignupState extends State<Farmersignup> {
//   final Farmercontroller _controller = Farmercontroller();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Farmer Signup')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _controller.formKey,
//           child: Column(
//             children: [
//               _buildTextField(_controller.userNameController, 'Username'),
//               _buildTextField(_controller.emailController, 'Email',
//                   inputType: TextInputType.emailAddress),
//               _buildTextField(_controller.passwordController, 'Password',
//                   obscureText: true),
//               _buildTextField(_controller.phoneNumberController, 'Phone Number',
//                   inputType: TextInputType.phone),
//               _buildTextField(_controller.addressController, 'Address'),
//               _buildTextField(_controller.nicController, 'NIC'),
//               const SizedBox(height: 10),
//               _controller.image != null
//                   ? Image.file(_controller.image!, height: 100)
//                   : const Text('No image selected'),
//               ElevatedButton(
//                 onPressed: () async {
//                   await _controller.pickImage();
//                   setState(() {});
//                 },
//                 child: const Text('Pick Image'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _controller.registerBuyer(context),
//                 child: const Text('Register as Farmer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label,
//       {bool obscureText = false,
//       TextInputType inputType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//         obscureText: obscureText,
//         keyboardType: inputType,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return '$label is required';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }



import 'package:agriconnect/Components/signUpForm.dart';
import 'package:flutter/material.dart';
import 'package:agriconnect/Controllers/farmerController.dart';

class FarmerSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignupForm(
      controller: Farmercontroller(),
      title: "Farmer SignUp",
      role: "Farmer",
    );
  }
}
