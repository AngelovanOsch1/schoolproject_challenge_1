import 'dart:convert';

import 'package:challenge_one_project/screens/auth/login.dart';
import 'package:challenge_one_project/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for each input field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    birthYearController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0XFFF2F2F2),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Form(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registreren',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        buildInputRow('Voornaam', firstNameController, 'Achternaam', lastNameController),
                        const SizedBox(height: 20),
                        buildInputColumn('Email', emailController),
                        const SizedBox(height: 20),
                        buildInputRow('Geboortejaar', birthYearController, 'Telefoonnummer', phoneController),
                        const SizedBox(height: 20),
                        buildInputRow('Wachtwoord', passwordController, 'Herhaal wachtwoord', confirmPasswordController, obscureText: true),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  _register();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A1B9A),
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Registreren',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text('Heb je al een account?'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF6A1B9A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2, {bool obscureText = false}) {
    return Row(
      children: [
        Expanded(child: buildInputColumn(label1, controller1, obscureText: obscureText)),
        const SizedBox(width: 20),
        Expanded(child: buildInputColumn(label2, controller2, obscureText: obscureText)),
      ],
    );
  }

  Widget buildInputColumn(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

   Future<void> _register() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String birthYear = birthYearController.text.trim();
    final String phoneNumber = phoneController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final Uri url = Uri.parse('http://localhost:8000/api/signup');

      final signupData = jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': birthYear,
        'phone_number': phoneNumber,
        'email': email, 
        'password': password,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: signupData,
      );

      if (response.statusCode == 200) {  
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
