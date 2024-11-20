import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  //method to store the userName in shared pref
  static Future<void> storeUserDetails({
    required String userName,
    required String name,
    required String branch,
    required BuildContext context,
  }) async {
    try {
      //create an instance from shared pref
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //store the user name and email as key value pairs
      await prefs.setString("username", userName);
      await prefs.setString("name", name);
      await prefs.setString("branch", branch);
      print('User data saved: username=$userName, name=$name, branch=$branch');

      //show a massage to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Details stored successfully"),
        ),
      );
    } catch (error) {
      error.toString();
    }
  }

  //methode to check weather the username is saved in the shared pref
  static Future<bool> checkUsername() async {
    //create an instance for shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    return userName != null;
  }

  //get the username and email
  static Future<Map<String, String>> getUserData() async {
    //create an instance for shared pref
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? userName = pref.getString('username');
    String? name = pref.getString('name');
    String? branch = pref.getString('branch');

    print(
        "Retrieved from SharedPreferences: username=$userName, name=$name, branch=$branch");

    return {
      'username': userName ?? '',
      'name': name ?? '',
      'branch': branch ?? '',
    };
  }
}
