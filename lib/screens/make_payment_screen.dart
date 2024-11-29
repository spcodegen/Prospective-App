import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _policyNoController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _confirmPaidAmountController =
      TextEditingController();

  String? selectedReceiptCategory;
  Map<String, dynamic> policyData = {};
  bool isDataLoaded = false;
  bool isLoading = false;
  bool isSaving = false;

  // Variables to hold data from SharedPreferences
  String? createdBy;

  final List<String> receiptCategories = [
    "Renewal Receipts",
    "Deposit Receipts",
    "Policy Loan Settlement Receipts",
    "Policy fee",
    "Alteration fee",
    "Special revival fee",
    "Duplicate Policy fee",
    "Loan fee",
  ];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      createdBy = prefs.getString("createdBy");
    });
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load policy data")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> savePaymentData() async {
    if (_formKey.currentState!.validate() && selectedReceiptCategory != null) {
      if (_paidAmountController.text != _confirmPaidAmountController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Paid Amount and Confirm Paid Amount do not match")),
        );
        return;
      }

      setState(() {
        isSaving = true;
      });

      final url =
          Uri.parse('http://client.cooplife.lk:8006/PolicyPaymentDetails');
      final payload = {
        "createdBy": createdBy ?? "defaultCreatedBy",
        "cusAddress": policyData["cusAddress"] ?? "",
        "cusName": policyData["cusName"] ?? "",
        "mobile": policyData["mobileNo"] ?? "",
        "modifiedBy": createdBy ?? "defaultCreatedBy",
        "newMobile": _mobileNumberController.text,
        "nic": policyData["nic"],
        "payment": int.tryParse(_paidAmountController.text) ?? 0,
        "policyNo": policyData["policyNo"] ?? 0,
        "receiptsCategory": selectedReceiptCategory ?? "",
        "status": "ACTIVE",
        "statusType": "Paid",
        "type": policyData["coverType"] ?? "",
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment saved successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save payment")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Please fill all fields, select a receipt category, and confirm the paid amount")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 35,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                const SizedBox(height: 20),
                const Text(
                  "Enter Policy Number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _policyNoController,
                  decoration: const InputDecoration(
                    hintText: "Policy Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_policyNoController.text.isNotEmpty) {
                      fetchPolicyData(_policyNoController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a policy number")),
                      );
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Search"),
                ),
                if (isDataLoaded) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Policy Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildNonEditableField(
                    label: "Policy Holder",
                    value: policyData["cusName"] ?? "N/A",
                  ),
                  buildNonEditableField(
                    label: "Address",
                    value: policyData["cusAddress"] ?? "N/A",
                  ),
                  buildNonEditableField(
                    label: "NIC",
                    value: policyData["nic"] ?? "N/A",
                  ),
                  buildNonEditableField(
                    label: "Policy Category",
                    value: policyData["coverType"] ?? "N/A",
                  ),
                  buildNonEditableField(
                    label: "Policy Status",
                    value: policyData["polStatus"] ?? "N/A",
                  ),
                  buildNonEditableField(
                    label: "Mobile No",
                    value: policyData["mobileNo"] ?? "N/A",
                  ),
                  const SizedBox(height: 20),
                  const Row(
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
                  const SizedBox(height: 10),
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
                    const Center(child: Text("No payment data available")),
                  const SizedBox(height: 20),
                  const Text(
                    "New Payment Entry",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedReceiptCategory,
                    items: receiptCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReceiptCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Receipt Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: const InputDecoration(
                      labelText: "New Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a mobile number";
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be exactly 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _paidAmountController,
                    decoration: const InputDecoration(
                      labelText: "Paid Amount",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a paid amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPaidAmountController,
                    decoration: const InputDecoration(
                      labelText: "Confirm Paid Amount",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm the paid amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: savePaymentData,
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : const Text("Save Payment"),
                  ),
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PaymentDataSource extends DataTableSource {
  final List<dynamic> payments;

  PaymentDataSource({required this.payments});

  @override
  DataRow getRow(int index) {
    if (index >= payments.length) return const DataRow(cells: []);

    final payment = payments[index];

    // Extract only the date part from dueDate and paidDate
    String formatDate(String? dateTime) {
      if (dateTime == null || dateTime.isEmpty) return "N/A";
      return dateTime.split(" ").first; // Extracts date before the space
    }

    return DataRow(cells: [
      DataCell(Text(payment["type"] ?? "N/A")),
      DataCell(Text(payment["payment"]?.toString() ?? "N/A")),
      DataCell(Text(formatDate(payment["dueDate"]))), // Show only date
      DataCell(Text(formatDate(payment["paidDate"]))), // Show only date
      DataCell(Text(payment["status"] ?? "N/A")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => payments.length;

  @override
  int get selectedRowCount => 0;
}
