import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application_coop/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _status;
  String? _insurance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _spouseAgeController = TextEditingController();
  final TextEditingController _noOfFamilyMembersController =
      TextEditingController();
  final TextEditingController _noOfChildController = TextEditingController();
  final TextEditingController _presentInsurerController =
      TextEditingController();
  final TextEditingController _monthlyIncomeController =
      TextEditingController();
  final TextEditingController _monthlyExpensesController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  Future<void> _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve saved data
      final createdBy = prefs.getString('createdBy');
      final branchId = prefs.getString('branchId');
      final regionId = prefs.getString('regionId');

      final data = {
        "name": _nameController.text,
        "nic": _nicController.text,
        "address": _addressController.text,
        "mobile": _mobileController.text,
        "status": _status,
        "insurance": _insurance,
        "spouseAge": int.tryParse(_spouseAgeController.text) ?? 0,
        "noOfFamilyMembers":
            int.tryParse(_noOfFamilyMembersController.text) ?? 0,
        "noOfChild": int.tryParse(_noOfChildController.text) ?? 0,
        "presentInsurer": _presentInsurerController.text,
        "monthlyIncome": int.tryParse(_monthlyIncomeController.text) ?? 0,
        "monthlyExpences": int.tryParse(_monthlyExpensesController.text) ?? 0,
        "remark": _remarkController.text,
        "createdBy": createdBy,
        "branchId": branchId,
        "regionId": regionId,
      };

      try {
        final response = await http.post(
          Uri.parse('http://client.cooplife.lk:8006/CoopLifeProspective'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data saved successfully!')),
          );
          _formKey.currentState?.reset();
          _nameController.clear();
          _nicController.clear();
          _addressController.clear();
          _mobileController.clear();
          _spouseAgeController.clear();
          _noOfFamilyMembersController.clear();
          _noOfChildController.clear();
          _presentInsurerController.clear();
          _monthlyIncomeController.clear();
          _monthlyExpensesController.clear();
          _remarkController.clear();
          setState(() {
            _status = null;
            _insurance = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to save data. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "New Record",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1.7,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                  ),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _nameController,
                            label: "Name",
                            isRequired: true,
                          ),
                          _buildTextField(
                            controller: _nicController,
                            label: "NIC",
                            isRequired: true,
                          ),
                          _buildTextField(
                            controller: _addressController,
                            label: "Address",
                            isRequired: true,
                          ),
                          _buildTextField(
                            controller: _mobileController,
                            label: "Mobile No",
                            isRequired: true,
                          ),
                          _buildDropdownField(
                            value: _status,
                            label: "Status",
                            isRequired: true,
                            items: const [
                              DropdownMenuItem(
                                value: "Married",
                                child: Text("Married"),
                              ),
                              DropdownMenuItem(
                                value: "Single",
                                child: Text("Single"),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _status = value),
                          ),
                          _buildTextField(
                            controller: _spouseAgeController,
                            label: "Spouse Age",
                          ),
                          _buildTextField(
                            controller: _noOfFamilyMembersController,
                            label: "No of Family Members",
                            isNumeric: true,
                          ),
                          _buildTextField(
                            controller: _noOfChildController,
                            label: "No of Child",
                            isNumeric: true,
                          ),
                          _buildDropdownField(
                            value: _insurance,
                            label: "Type of Insurance",
                            isRequired: true,
                            items: const [
                              DropdownMenuItem(
                                value: "Monthly",
                                child: Text("Monthly"),
                              ),
                              DropdownMenuItem(
                                value: "Quarterly",
                                child: Text("Quarterly"),
                              ),
                              DropdownMenuItem(
                                value: "Half Yearly",
                                child: Text("Half Yearly"),
                              ),
                              DropdownMenuItem(
                                value: "Yearly",
                                child: Text("Yearly"),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _insurance = value),
                          ),
                          _buildTextField(
                            controller: _presentInsurerController,
                            label: "Present Insurer",
                          ),
                          _buildTextField(
                            controller: _monthlyIncomeController,
                            label: "Monthly Income",
                            isNumeric: true,
                          ),
                          _buildTextField(
                            controller: _monthlyExpensesController,
                            label: "Monthly Expenses",
                            isNumeric: true,
                          ),
                          _buildTextField(
                            controller: _remarkController,
                            label: "Remark",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _saveData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kGreen,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Save"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kRed,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumeric = false,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          if (isNumeric &&
              value != null &&
              value.isNotEmpty &&
              int.tryParse(value) == null) {
            return 'Please enter a valid number for $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        value: value,
        onChanged: onChanged,
        items: items,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
}
