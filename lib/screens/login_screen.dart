import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/screens/main_screen.dart';
import 'package:flutter_application_coop/services/user_services.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
                            isNumeric: true,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          _buildTextField(
                            controller: _passwordController,
                            obscureText: true,
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
                                shadowColor: const Color.fromARGB(255, 6, 6, 6),
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
                    ),
                  ),
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

        // Extract all the values from the JSON object
        final int id = jsonData['id'];
        final String bucode = jsonData['bucode'];
        final String percode = jsonData['percode'];
        final String name = jsonData['name'];
        final String soflevelcode = jsonData['soflevelcode'];
        final String sotdesc = jsonData['sotdesc'];
        final String branch = jsonData['branch'];
        final String contactno = jsonData['contactno'];
        final String overrider = jsonData['overrider'];
        final String address = jsonData['address'];
        final String brId = jsonData['brId'];
        final String regonid = jsonData['regonid'];
        final String zoneid = jsonData['zoneid'];
        final String? pw = jsonData['pw']; // Can be null
        final String? status = jsonData['status']; // Can be null

        // Save all the user details
        await UserServices.storeUserDetails(
          id: id,
          bucode: bucode,
          userName: userName,
          percode: percode,
          name: name,
          soflevelcode: soflevelcode,
          sotdesc: sotdesc,
          branch: branch,
          contactno: contactno,
          overrider: overrider,
          address: address,
          brId: brId,
          regonid: regonid,
          zoneid: zoneid,
          pw: pw,
          status: status,
          context: context,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password'),
          ),
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
    bool isNumeric = false,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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
