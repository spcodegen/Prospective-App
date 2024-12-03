import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // Method to store user details in shared preferences
  static Future<void> storeUserDetails({
    required int id,
    required String userName,
    required String bucode,
    required String percode,
    required String name,
    required String soflevelcode,
    required String sotdesc,
    required String branch,
    required String contactno,
    required String overrider,
    required String address,
    required String brId,
    required String regonid,
    required String zoneid,
    required String? pw, // Can be null
    required String? status, // Can be null
    required BuildContext context,
  }) async {
    try {
      // Create an instance of SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store all values as key-value pairs
      await prefs.setInt("id", id);
      await prefs.setString("bucode", bucode);
      await prefs.setString("username", userName);
      await prefs.setString("percode", percode);
      await prefs.setString("name", name);
      await prefs.setString("soflevelcode", soflevelcode);
      await prefs.setString("sotdesc", sotdesc);
      await prefs.setString("branch", branch);
      await prefs.setString("contactno", contactno);
      await prefs.setString("overrider", overrider);
      await prefs.setString("address", address);
      await prefs.setString("brId", brId);
      await prefs.setString("regonid", regonid);
      await prefs.setString("zoneid", zoneid);
      if (pw != null) {
        await prefs.setString("pw", pw);
      }
      if (status != null) {
        await prefs.setString("status", status);
      }

      print(
          'User data saved: id=$id, name=$name, branch=$branch, username=$userName, bucode=$bucode, percode=$percode, soflevelcode=$soflevelcode, sotdesc=$sotdesc, contactno=$contactno, overrider=$overrider, address=$address, brId=$brId, regonid=$regonid, zoneid=$zoneid, pw=$pw, status=$status');

      // Show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Details stored successfully"),
        ),
      );
    } catch (error) {
      print("Error storing user data: $error");
    }
  }

  // Method to check whether the username is saved in shared preferences
  static Future<bool> checkUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    return userName != null;
  }

  // Method to get all user data from shared preferences
  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('id');
    String? userName = prefs.getString('username');
    String? bucode = prefs.getString('bucode');
    String? percode = prefs.getString('percode');
    String? name = prefs.getString('name');
    String? soflevelcode = prefs.getString('soflevelcode');
    String? sotdesc = prefs.getString('sotdesc');
    String? branch = prefs.getString('branch');
    String? contactno = prefs.getString('contactno');
    String? overrider = prefs.getString('overrider');
    String? address = prefs.getString('address');
    String? brId = prefs.getString('brId');
    String? regonid = prefs.getString('regonid');
    String? zoneid = prefs.getString('zoneid');
    String? pw = prefs.getString('pw');
    String? status = prefs.getString('status'); // No default value

    print(
        "Retrieved from SharedPreferences: id=$id, name=$name, branch=$branch, username=$userName, bucode=$bucode, percode=$percode, soflevelcode=$soflevelcode, sotdesc=$sotdesc, contactno=$contactno, overrider=$overrider, address=$address, brId=$brId, regonid=$regonid, zoneid=$zoneid, pw=$pw, status=$status");

    return {
      'id': id ?? 0,
      'username': userName ?? '',
      'bucode': bucode ?? '',
      'percode': percode ?? '',
      'name': name ?? '',
      'soflevelcode': soflevelcode ?? '',
      'sotdesc': sotdesc ?? '',
      'branch': branch ?? '',
      'contactno': contactno ?? '',
      'overrider': overrider ?? '',
      'address': address ?? '',
      'brId': brId ?? '',
      'regonid': regonid ?? '',
      'zoneid': zoneid ?? '',
      'pw': pw ?? '',
      'status': status, // Can be null
    };
  }

  // Method to clear user data from shared preferences
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('username');
    await prefs.remove('bucode');
    await prefs.remove('percode');
    await prefs.remove('name');
    await prefs.remove('soflevelcode');
    await prefs.remove('sotdesc');
    await prefs.remove('branch');
    await prefs.remove('contactno');
    await prefs.remove('overrider');
    await prefs.remove('address');
    await prefs.remove('brId');
    await prefs.remove('regonid');
    await prefs.remove('zoneid');
    await prefs.remove('pw');
    await prefs.remove('status');
  }
}
