import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/model/client.dart';
import 'package:flutter_application_coop/services/user_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For storing the username, name, and branch
  String usernameNew = "";
  String name = "";
  String branch = "";

  List<Map<String, dynamic>>? filteredData;

  @override
  void initState() {
    super.initState();

    // Retrieve user data from SharedPreferences
    UserServices.getUserData().then((value) {
      setState(() {
        usernameNew = value['username'] ?? 'Unknown Username';
        name = value['name'] ?? 'Unknown Name';
        branch = value['branch'] ?? 'Unknown Branch';
      });

      // Debugging log
      print(
          "User data in HomeScreen: username=$usernameNew, name=$name, branch=$branch");

      // Fetch data after setting usernameNew
      fetchData();
    });
  }

  Future<void> fetchData() async {
    if (usernameNew.isEmpty) {
      print('Error: usernameNew is empty, cannot fetch data.');
      return;
    }

    final Uri apiUrl = Uri.parse(
        'http://client.cooplife.lk:8006/CoopLifeProspective/username/$usernameNew');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('API Response: $data');

        setState(() {
          filteredData = data
              .map((clientData) => clientData as Map<String, dynamic>)
              .toList();
        });
      } else {
        print(
            'Error: Failed to fetch data, status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: kGreen,
                          radius: 22.5,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/user.jpg",
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "Welcome $name",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          branch,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Prospective\nClient's Record",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: kBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Data Table section
            Expanded(
              child: filteredData == null
                  ? const Center(child: CircularProgressIndicator())
                  : filteredData!.isEmpty
                      ? const Center(
                          child: Text("No data found for this user."))
                      : DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("NIC")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: filteredData!.map((clientData) {
                            final client = Client.fromJson(clientData);
                            return DataRow(
                              cells: [
                                DataCell(Text(client.name)),
                                DataCell(Text(client.nic)),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      showUpdateDialog(context, client);
                                    },
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateDialog(BuildContext context, Client client) {
    final TextEditingController nameController =
        TextEditingController(text: client.name);
    final TextEditingController nicController =
        TextEditingController(text: client.nic);
    final TextEditingController addressController =
        TextEditingController(text: client.address);
    final TextEditingController mobileController =
        TextEditingController(text: client.mobile);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Details for ${client.name}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: nicController,
                  decoration: const InputDecoration(labelText: "NIC"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: "Mobile"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement the update functionality here
                print("Updated Name: ${nameController.text}");
                print("Updated NIC: ${nicController.text}");
                print("Updated Address: ${addressController.text}");
                print("Updated Mobile: ${mobileController.text}");
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

class Client {
  final String id;
  final String name;
  final String nic;
  final String address;
  final String mobile;
  final String typeOfInsurance;
  final String presentInsurer;
  final int spouseAge;
  final int noOfFamilyMembers;
  final int noOfChild;
  final String statusType;
  final int monthlyIncome;
  final int monthlyExpenses;
  final String remark;
  final String createdBy;
  final String createdDateTime;
  final String modifiedBy;
  final String modifiedDateTime;
  final String branchId;
  final String regionId;

  Client({
    required this.id,
    required this.name,
    required this.nic,
    required this.address,
    required this.mobile,
    required this.typeOfInsurance,
    required this.presentInsurer,
    required this.spouseAge,
    required this.noOfFamilyMembers,
    required this.noOfChild,
    required this.statusType,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.remark,
    required this.createdBy,
    required this.createdDateTime,
    required this.modifiedBy,
    required this.modifiedDateTime,
    required this.branchId,
    required this.regionId,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      nic: json['nic'],
      address: json['address'],
      mobile: json['mobile'],
      typeOfInsurance: json['typeOfInsurance'],
      presentInsurer: json['presentInsurer'],
      spouseAge: json['spouseAge'],
      noOfFamilyMembers: json['noOfFamilyMembers'],
      noOfChild: json['noOfChild'],
      statusType: json['statusType'],
      monthlyIncome: json['monthlyIncome'],
      monthlyExpenses: json['monthlyExpences'], // Corrected field
      remark: json['remark'],
      createdBy: json['createdBy'],
      createdDateTime: json['createdDateTime'],
      modifiedBy: json['modifiedBy'],
      modifiedDateTime: json['modifiedDateTime'],
      branchId: json['branchId'],
      regionId: json['regionId'],
    );
  }
}
