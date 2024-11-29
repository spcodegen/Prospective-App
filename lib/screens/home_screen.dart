import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

        // Save createdBy, branchId, regionId to SharedPreferences
        final client =
            Client.fromJson(data[0]); // Assuming first client data is available
        saveToSharedPreferences(client);
      } else {
        print(
            'Error: Failed to fetch data, status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Method to save the data to SharedPreferences
  Future<void> saveToSharedPreferences(Client client) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('createdBy', client.createdBy ?? 'Unknown');
    await prefs.setString('branchId', client.branchId ?? 'Unknown');
    await prefs.setString('regionId', client.regionId ?? 'Unknown');
    print(
        'Data saved to SharedPreferences: createdBy=${client.createdBy}, branchId=${client.branchId}, regionId=${client.regionId}');
  }

  //Update client details
  Future<void> updateClientDetails(Client client) async {
    final Uri apiUrl =
        Uri.parse('http://client.cooplife.lk:8006/CoopLifeProspective');
    try {
      final response = await http.put(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(client.toJson()),
      );

      if (response.statusCode == 200) {
        print('Client details updated successfully');
        fetchData(); // Refresh data
      } else {
        print(
            'Error: Failed to update client, status code ${response.statusCode}');
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
                              "assets/userNew.png",
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
              height: 10,
            ),
            // Data Table with Pagination and Scrollable Content
            Expanded(
              child: filteredData == null
                  ? const Center(child: CircularProgressIndicator())
                  : filteredData!.isEmpty
                      ? const Center(
                          child: Text("No data found for this user."),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adds padding
                            child: Column(
                              children: [
                                const SizedBox(
                                    height: 20), // Space above the table
                                Container(
                                  width: double
                                      .infinity, // Ensures full width within the padding
                                  child: PaginatedDataTable(
                                    header: const Text(
                                      "Client Records",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    columns: const [
                                      DataColumn(label: Text("Name")),
                                      DataColumn(label: Text("NIC")),
                                      DataColumn(label: Text("Action")),
                                    ],
                                    source: ClientDataTableSource(
                                      clients: filteredData!
                                          .map((clientData) =>
                                              Client.fromJson(clientData))
                                          .toList(),
                                      onUpdatePressed: (client) {
                                        showUpdateDialog(context, client);
                                      },
                                    ),
                                    rowsPerPage: 5, // Number of rows per page
                                    columnSpacing: 50,
                                    horizontalMargin: 10,
                                    showCheckboxColumn: false,
                                  ),
                                ),
                                const SizedBox(
                                    height: 20), // Space below the table
                              ],
                            ),
                          ),
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
    final TextEditingController spouseAgeController =
        TextEditingController(text: client.spouseAge.toString());
    final TextEditingController familyMembersController =
        TextEditingController(text: client.noOfFamilyMembers.toString());
    final TextEditingController childrenController =
        TextEditingController(text: client.noOfChild.toString());
    final TextEditingController insurerController =
        TextEditingController(text: client.presentInsurer);
    final TextEditingController incomeController =
        TextEditingController(text: client.monthlyIncome.toString());
    final TextEditingController expensesController =
        TextEditingController(text: client.monthlyExpenses.toString());
    final TextEditingController remarkController =
        TextEditingController(text: client.remark);

    String selectedStatus = client.statusType ?? 'Single'; // Married or Single
    String selectedInsuranceType =
        client.typeOfInsurance ?? 'Monthly'; // Monthly, etc.

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
                  decoration: const InputDecoration(labelText: "Mobile No"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus.isNotEmpty &&
                          ['Married', 'Single'].contains(selectedStatus)
                      ? selectedStatus
                      : 'Married', // Provide a fallback value
                  items: ['Married', 'Single']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: "Status"),
                ),
                TextField(
                  controller: spouseAgeController,
                  decoration: const InputDecoration(labelText: "Spouse Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: familyMembersController,
                  decoration:
                      const InputDecoration(labelText: "No of Family Members"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: childrenController,
                  decoration:
                      const InputDecoration(labelText: "No of Children"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedInsuranceType.isNotEmpty &&
                          ['Monthly', 'Quarterly', 'Half Yearly', 'Yearly']
                              .contains(selectedInsuranceType)
                      ? selectedInsuranceType
                      : 'Monthly', // Provide a fallback value
                  items: ['Monthly', 'Quarterly', 'Half Yearly', 'Yearly']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedInsuranceType = value!;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: "Type of Insurance"),
                ),
                TextField(
                  controller: insurerController,
                  decoration:
                      const InputDecoration(labelText: "Present Insurer"),
                ),
                TextField(
                  controller: incomeController,
                  decoration:
                      const InputDecoration(labelText: "Monthly Income"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: expensesController,
                  decoration:
                      const InputDecoration(labelText: "Monthly Expenses"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: remarkController,
                  decoration: const InputDecoration(labelText: "Remark"),
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
            //add new
            ElevatedButton(
              onPressed: () {
                // Update the client object with the new values from the TextControllers
                client.name = nameController.text;
                client.nic = nicController.text;
                client.address = addressController.text;
                client.mobile = mobileController.text;
                client.spouseAge =
                    int.tryParse(spouseAgeController.text) ?? client.spouseAge;
                client.noOfFamilyMembers =
                    int.tryParse(familyMembersController.text) ??
                        client.noOfFamilyMembers;
                client.noOfChild =
                    int.tryParse(childrenController.text) ?? client.noOfChild;
                client.statusType = selectedStatus;
                client.typeOfInsurance = selectedInsuranceType;
                client.presentInsurer = insurerController.text;
                client.monthlyIncome =
                    int.tryParse(incomeController.text) ?? client.monthlyIncome;
                client.monthlyExpenses =
                    int.tryParse(expensesController.text) ??
                        client.monthlyExpenses;
                client.remark = remarkController.text;

                // Send updated client details to API
                updateClientDetails(client);

                // Close the dialog after updating
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
  String id;
  String name;
  String nic;
  String? address;
  String? mobile;
  String? typeOfInsurance;
  String? presentInsurer;
  int? spouseAge;
  int? noOfFamilyMembers;
  int? noOfChild;
  String? statusType;
  int? monthlyIncome;
  int? monthlyExpenses;
  String? remark;
  String? createdBy;
  String? createdDateTime;
  String? modifiedBy;
  String? modifiedDateTime;
  String? branchId;
  String? regionId;

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

  // Method to convert a Client instance to a JSON object // add new
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nic': nic,
      'address': address,
      'mobile': mobile,
      'typeOfInsurance': typeOfInsurance,
      'presentInsurer': presentInsurer,
      'spouseAge': spouseAge,
      'noOfFamilyMembers': noOfFamilyMembers,
      'noOfChild': noOfChild,
      'statusType': statusType,
      'monthlyIncome': monthlyIncome,
      'monthlyExpences': monthlyExpenses,
      'remark': remark,
      'createdBy': createdBy,
      'createdDateTime': createdDateTime,
      'modifiedBy': modifiedBy,
      'modifiedDateTime': modifiedDateTime,
      'branchId': branchId,
      'regionId': regionId,
    };
  }
}

class ClientDataTableSource extends DataTableSource {
  final List<Client> clients;
  final Function(Client) onUpdatePressed;

  ClientDataTableSource({required this.clients, required this.onUpdatePressed});

  @override
  DataRow? getRow(int index) {
    if (index >= clients.length) return null;

    final client = clients[index];
    return DataRow(
      cells: [
        DataCell(Text(client.name)),
        DataCell(Text(client.nic)),
        DataCell(
          ElevatedButton(
            onPressed: () => onUpdatePressed(client),
            child: const Text(
              'Update',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients.length;

  @override
  int get selectedRowCount => 0;
}
