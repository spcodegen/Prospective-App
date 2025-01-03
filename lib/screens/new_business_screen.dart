import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Variables to hold data from SharedPreferences
  String? createdBy;
  String? modifiedBy;

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
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      createdBy = prefs.getString("createdBy");
      modifiedBy = prefs.getString("modifiedBy");
    });
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
          bankList = List<String>.from(
              data.map((item) => "${item['bankName']} - ${item['bankCode']}"));
        });
      } else {
        throw Exception("Failed to load banks");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching banks: $e")),
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

  void saveForm() async {
    if (paymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select Cash or Cheque payment type.")),
      );
      return; // Stop further execution
    }

    if (_formKey.currentState!.validate()) {
      try {
        // Check if Paid Amount matches Confirm Amount
        if (paidAmountController.text != confirmAmountController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Paid Amount and Confirm Paid Amount must match.")),
          );
          return; // Stop further execution
        }

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

        // Prepare the data object
        Map<String, dynamic> requestData = {
          "planName": selectedPlan,
          "name": nameController.text,
          "address": addressController.text,
          "nic": nicController.text,
          "dateOfBirth": dobController.text,
          "mobileNo": mobileController.text,
          "modifiedBy": modifiedBy,
          "createdBy": createdBy,
          "term": selectedTerm,
          "title": selectedTitle,
          "paidAmount": paidAmountController.text,
          "paymentType": paymentType,
          "statusType": "Paid",
          "newBusinessCode": "",
        };

        if (paymentType == "Cheque") {
          // Add cheque-specific fields
          requestData.addAll({
            "bank": selectedBank,
            "checkDate": chequeDateController.text,
            "checkNo": chequeNoController.text,
          });
        }

        // Call the API
        final response = await http.post(
          Uri.parse(
              "http://client.cooplife.lk:8006/NewBusiness"), // Replace with your API endpoint
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Form Saved Successfully!")),
          );
          clearForm(); // Clear the form after successful submission
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save data: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      // Show a snackbar for general validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
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
                    isExpanded: true, // Make sure the dropdown expands fully
                    items: bankList.map((bank) {
                      final splitData = bank.split(" - ");
                      final bankName = splitData[0];
                      final bankCode = splitData[1];
                      return DropdownMenuItem(
                        value: bankCode,
                        child: Text(bank),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedBank = value),
                  ),
                  TextFormField(
                    controller: chequeNoController,
                    decoration: const InputDecoration(labelText: "Cheque No"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Cheque Number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: chequeDateController,
                    decoration: const InputDecoration(labelText: "Cheque Date"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2500),
                      );
                      if (pickedDate != null) {
                        chequeDateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the Cheque Date';
                      }
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                        return 'Invalid date format. Use YYYY-MM-DD.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: paidAmountController,
                    decoration: const InputDecoration(labelText: "Paid Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Paid Amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid numeric value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmAmountController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Paid Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm the Paid Amount';
                      }
                      if (value != paidAmountController.text) {
                        return 'Amounts do not match';
                      }
                      return null;
                    },
                  ),
                ] else if (paymentType == "Cash") ...[
                  TextFormField(
                    controller: paidAmountController,
                    decoration: const InputDecoration(labelText: "Paid Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Paid Amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid numeric value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmAmountController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Paid Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm the Paid Amount';
                      }
                      if (value != paidAmountController.text) {
                        return 'Amounts do not match';
                      }
                      return null;
                    },
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
