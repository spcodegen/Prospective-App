import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _policyNoController = TextEditingController();
  Map<String, dynamic> policyData = {};
  bool isDataLoaded = false;
  bool isLoading = false;

  Future<void> fetchPolicyData(String policyNo) async {
    setState(() {
      isLoading = true;
      isDataLoaded = false;
    });

    final url = Uri.parse('http://client.cooplife.lk:8006/Policy/$policyNo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          policyData = json.decode(response.body);
          isDataLoaded = true;
        });
      } else {
        setState(() {
          isDataLoaded = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load policy data")),
          );
        });
      }
    } catch (e) {
      setState(() {
        isDataLoaded = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.article, color: Colors.blue, size: 30),
                    SizedBox(width: 8),
                    Text(
                      "Policy Search",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Enter Policy Number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _policyNoController,
                  decoration: InputDecoration(
                    hintText: "Policy Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_policyNoController.text.isNotEmpty) {
                      fetchPolicyData(_policyNoController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a policy number")),
                      );
                    }
                  },
                  child:
                      isLoading ? CircularProgressIndicator() : Text("Search"),
                ),
                if (isDataLoaded) ...[
                  SizedBox(height: 20),
                  buildNonEditableField(
                      label: "Customer Name",
                      value: policyData["cusName"] ?? "N/A"),
                  buildNonEditableField(
                      label: "Customer Address",
                      value: policyData["cusAddress"] ?? "N/A"),
                  buildNonEditableField(
                      label: "NIC", value: policyData["nic"] ?? "N/A"),
                  buildNonEditableField(
                      label: "Mobile No",
                      value: policyData["mobileNo"] ?? "N/A"),
                  buildNonEditableField(
                      label: "Cover Type",
                      value: policyData["coverType"] ?? "N/A"),
                  buildNonEditableField(
                      label: "Policy Status",
                      value: policyData["polStatus"] ?? "N/A"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.green, size: 30),
                      SizedBox(width: 8),
                      Text(
                        "Payment Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (policyData["policyPaymentResponses"] != null &&
                      (policyData["policyPaymentResponses"] as List).isNotEmpty)
                    PaginatedDataTable(
                      header: null,
                      columns: const [
                        DataColumn(label: Text("Type")),
                        DataColumn(label: Text("Payment")),
                        DataColumn(label: Text("Due Date")),
                        DataColumn(label: Text("Paid Date")),
                        DataColumn(label: Text("Status")),
                      ],
                      source: PaymentDataSource(
                        payments: policyData["policyPaymentResponses"],
                      ),
                      rowsPerPage: 5,
                    ),
                  if (policyData["policyPaymentResponses"] == null ||
                      (policyData["policyPaymentResponses"] as List).isEmpty)
                    Center(child: Text("No payment data available")),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNonEditableField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
      ],
    );
  }
}

class PaymentDataSource extends DataTableSource {
  final List<dynamic> payments;

  PaymentDataSource({required this.payments});

  String formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "N/A";
    }
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= payments.length) return null;
    final payment = payments[index];

    return DataRow(
      cells: [
        DataCell(Text(payment["type"] ?? "N/A")),
        DataCell(Text(payment["payment"]?.toString() ?? "N/A")),
        DataCell(Text(formatDate(payment["dueDate"]))),
        DataCell(Text(formatDate(payment["paidDate"]))),
        DataCell(Text(payment["status"] ?? "N/A")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => payments.length;

  @override
  int get selectedRowCount => 0;
}
