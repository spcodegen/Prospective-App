import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/screens/main_screen.dart';
import 'package:flutter_application_coop/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key for the form validation
  final _formKey = GlobalKey<FormState>();

  //controller for the text from feilds
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.greenAccent,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _userNameController,
                              labelText: 'User Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter User Name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            _buildTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 280,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: Colors.green,
                                  elevation: 10,
                                  shadowColor:
                                      const Color.fromARGB(255, 6, 6, 6),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _loginUser();
                                  }
                                },
                                child: const Text(
                                  'Login Now',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontFamily: 'Georgia',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    final String userName = _userNameController.text;
    final String password = _passwordController.text;

    final Uri apiUrl = Uri.parse(
        'http://client.cooplife.lk:8006/PerUser/login/$userName/$password');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Check if "percode" and "pw" fields match the input
        final String? percode = jsonData['percode'];
        final String? password = jsonData['pw'];
        final String name = jsonData['name'];
        final String branch = jsonData['branch'];

        // Return true if both match; otherwise, return false
        if (percode == userName && password == password) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                username: userName,
                name: name,
                branch: branch,
              ), // Pass username
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error fetching user data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred, please try again later'),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: kBlack,
            fontSize: 12,
          ),
          hintStyle: const TextStyle(
            color: kBlack,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kBlack,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
        validator: validator,
      ),
    );
  }
}
