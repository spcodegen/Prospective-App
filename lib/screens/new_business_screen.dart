import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewBusinessScreen extends StatefulWidget {
  const NewBusinessScreen({super.key});

  @override
  State<NewBusinessScreen> createState() => _NewBusinessScreenState();
}

class _NewBusinessScreenState extends State<NewBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPlan;
  String? selectedTerm;
  String? selectedTitle;
  String? selectedBank;
  String? paymentType;

  List<String> planList = [];
  List<String> bankList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController chequeNoController = TextEditingController();
  final TextEditingController chequeDateController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController confirmAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlans();
    fetchBanks();
  }

  Future<void> fetchPlans() async {
    try {
      final response =
          await http.get(Uri.parse("http://client.cooplife.lk:8006/Plan"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          planList = List<String>.from(data.map((item) => item['plnDesc']));
        });
      } else {
        throw Exception("Failed to load plans");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching plans: $e")),
      );
    }
  }

  Future<void> fetchBanks() async {
    try {
      final response = await http
          .get(Uri.parse("http://client.cooplife.lk:8006/BankDetails"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bankList = List<String>.from(data.map((item) => item['bankName']));
        });
      } else {
        throw Exception("Failed to load Bank");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching plans: $e")),
      );
    }
  }

  void clearForm() {
    _formKey.currentState?.reset();
    nameController.clear();
    addressController.clear();
    nicController.clear();
    dobController.clear();
    mobileController.clear();
    chequeNoController.clear();
    chequeDateController.clear();
    paidAmountController.clear();
    confirmAmountController.clear();
    setState(() {
      paymentType = null;
      selectedPlan = null;
      selectedTerm = null;
      selectedTitle = null;
      selectedBank = null;
    });
  }

  void saveForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final dob = DateTime.parse(dobController.text); // Parse DOB
        final now = DateTime.now();
        final age = now.year -
            dob.year -
            ((now.month < dob.month) ||
                    (now.month == dob.month && now.day < dob.day)
                ? 1
                : 0);

        if (age < 18 || age > 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Age must be between 18 and 100 years.")),
          );
          return; // Stop further execution
        }

        // Proceed with form submission logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Form Saved Successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Date of Birth format.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Business Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedPlan,
                  decoration: const InputDecoration(labelText: "Plan"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Plan';
                    }
                    return null;
                  },
                  items: planList
                      .map((plan) => DropdownMenuItem(
                            value: plan,
                            child: Text(plan),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedPlan = value),
                ),
                DropdownButtonFormField<String>(
                  value: selectedTerm,
                  decoration: const InputDecoration(labelText: "Term"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Term';
                    }
                    return null;
                  },
                  items: [
                    "3 Year",
                    "4 Years",
                    "5 Years",
                    "6 Years",
                    "7 Years",
                    "8 Years",
                    "9 Years",
                    "10 Years",
                    "11 Years",
                    "12 Years",
                    "13 Years",
                    "14 Years",
                    "15 Years",
                    "16 Years",
                    "17 Years",
                    "18 Years",
                    "19 Years",
                    "20 Years",
                    "21 Years",
                    "22 Years",
                    "23 Years",
                    "24 Years",
                    "25 Years",
                    "26 Years",
                    "27 Years",
                    "28 Years",
                    "29 Years",
                    "30 Years",
                    "31 Years",
                    "32 Years",
                    "33 Years",
                    "34 Years",
                    "35 Years",
                    "36 Years",
                    "37 Years",
                    "38 Years",
                    "39 Years",
                    "40 Years"
                  ]
                      .map((term) => DropdownMenuItem(
                            value: term,
                            child: Text(term),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedTerm = value),
                ),
                DropdownButtonFormField<String>(
                  value: selectedTitle,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Title';
                    }
                    return null;
                  },
                  items: [
                    "Mr.",
                    "Mrs.",
                    "Ms.",
                    "Dr.",
                    "Dr(Mrs).",
                    "Rev.",
                    "Venerable.",
                    "Major.",
                    "Captain.",
                    "Prof.",
                    "Master."
                  ]
                      .map((title) => DropdownMenuItem(
                            value: title,
                            child: Text(title),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedTitle = value),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nicController,
                  decoration: const InputDecoration(labelText: "NIC"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter National ID Number';
                    }
                    if (!RegExp(r'^\d{12}$').hasMatch(value) &&
                        !RegExp(r'^\d{9}[vV]$').hasMatch(value)) {
                      return 'Enter a 12-digit number or a 9-digit number followed by V or v';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: "Date of Birth"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      dobController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your Date of Birth';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: "Mobile Number"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile Number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be exactly 10 digits';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => paymentType = "Cash"),
                      child: const Text("Cash"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => setState(() => paymentType = "Cheque"),
                      child: const Text("Cheque"),
                    ),
                  ],
                ),
                if (paymentType == "Cheque") ...[
                  DropdownButtonFormField<String>(
                    value: selectedBank,
                    decoration: const InputDecoration(labelText: "Bank"),
                    items: bankList
                        .map((bank) => DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedBank = value),
                  ),
                  TextFormField(
                    controller: chequeNoController,
                    decoration: const InputDecoration(labelText: "Cheque No"),
                  ),
                  TextFormField(
                    controller: dobController,
                    decoration:
                        const InputDecoration(labelText: "Date of Birth"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your Date of Birth';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: paidAmountController,
                    decoration: const InputDecoration(labelText: "Paid Amount"),
                  ),
                  TextFormField(
                    controller: confirmAmountController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Paid Amount"),
                  ),
                ] else if (paymentType == "Cash") ...[
                  TextFormField(
                    controller: paidAmountController,
                    decoration: const InputDecoration(labelText: "Paid Amount"),
                  ),
                  TextFormField(
                    controller: confirmAmountController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Paid Amount"),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: clearForm,
                      child: const Text("Clear"),
                    ),
                    ElevatedButton(
                      onPressed: saveForm,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
