import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String username;
  final String name;
  final String branch;

  const HomeScreen({
    super.key,
    required this.username,
    required this.name,
    required this.branch,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>>? filteredData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://client.cooplife.lk:8006/CoopLifeProspective/username/${widget.username}')); // Corrected URL
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('API Response: $data'); // Debugging line
      setState(() {
        filteredData =
            data.map((client) => client as Map<String, dynamic>).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load data');
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
                          "Welcome ${widget.name}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.branch,
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
                          rows: filteredData!.map((client) {
                            return DataRow(
                              cells: [
                                DataCell(Text(client['name'])),
                                DataCell(Text(client['nic'])),
                                //DataCell(Text(client['mobile'].toString())),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Update'),
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
}
