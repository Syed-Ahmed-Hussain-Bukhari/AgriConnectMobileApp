import 'package:agriconnect/Controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:agriconnect/Views/Authentication/BuyerSignUp.dart';
import 'package:agriconnect/Views/Authentication/FarmerSignUp.dart';
import 'package:agriconnect/Views/Authentication/TrainerSignUp.dart';
import 'package:agriconnect/Views/Authentication/TransporterSignUp.dart';

class Login extends StatelessWidget {
  final LoginController _controller = LoginController();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _controller.login(
                  context: context,
                  email: emailController.text,
                  password: passwordController.text,
                );
                // Check if the token is stored
                // final token = await _controller.getStoredToken();
                // if (token != null) {
                //   print('Stored Token: $token');
                // }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _showSignUpDialog(context),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select User Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSignUpButton(context, 'Farmer', const Farmersignup()),
              _buildSignUpButton(context, 'Buyer', const Buyersignup()),
              _buildSignUpButton(
                  context, 'Transporter', const Transportersignup()),
              _buildSignUpButton(context, 'Trainer', const Trainersignup()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context, String role, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Close the popup
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(role),
    );
  }
}
