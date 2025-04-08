// import 'package:flutter/material.dart';
// import 'package:agriconnect/constants/colors.dart'; // Ensure this contains MyColors.primaryColor

// class MyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData? prefixIcon;
//   final bool obscureText;
//   final TextInputType? keyboardType;

//   const MyTextField(
//     this.controller, {
//     required this.hintText,
//     this.prefixIcon,
//     this.obscureText = false,
//     this.keyboardType,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10),
//       child: TextField(
//         keyboardType: keyboardType,
//         controller: controller,
//         obscureText: obscureText, // For password fields
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: prefixIcon != null
//               ? Icon(prefixIcon, color: MyColors.primaryColor)
//               : null,
//           filled: true,
          
//           fillColor: Colors.white, // Background color
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12), // Rounded borders
//             borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         ),
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:agriconnect/constants/colors.dart'; // Ensure this contains MyColors.primaryColor

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;

  const MyTextField(
    this.controller, {
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    super.key,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true; // Track visibility state

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        cursorColor:  MyColors.primaryColor,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: MyColors.primaryColor)
              : null,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          // Show eye icon only if it's a password field
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: MyColors.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle password visibility
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
