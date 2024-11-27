import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/constants/constants.dart';
import 'package:flutter_application_coop/screens/login_screen.dart';
import 'package:flutter_application_coop/services/user_services.dart';
import 'package:flutter_application_coop/widgets/profile_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String usernameNew = "";
  String branch = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameNew = prefs.getString('username') ?? 'Guest';
      branch = prefs.getString('branch') ?? 'Unknown Branch';
    });
  }

  void _showContactUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/logo.png", // Replace with your company logo image path
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "Address: 455, Galle Road, Colombo 03, Sri Lanka",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "Phone: Dinith - (+94 71 0233087)",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "Email: sdu@coopinsu.com",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: kBlack,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kGreen),
                    ),
                    onPressed: () async {
                      await UserServices.clearUserData();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kWhite,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kRed),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kGreen,
                        border: Border.all(
                          color: kGreen,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/user.jpg",
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome $usernameNew",
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          branch,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: kGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 25,
                          color: kGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _showContactUsDialog(context);
                  },
                  child: const ProfileCard(
                    icon: Icons.call,
                    title: "Contact Us",
                    color: kGrey,
                  ),
                ),
                const ProfileCard(
                  icon: Icons.verified_user_rounded,
                  title: "Change Password",
                  color: kYellow,
                ),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: const ProfileCard(
                    icon: Icons.logout_outlined,
                    title: "Logout",
                    color: kRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
