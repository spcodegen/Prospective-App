import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/widgets/custom_button.dart';

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
  final TextEditingController _monthlyExpencesController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Record"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Stack(
              children: [
                //Form Title
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "New Record",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //user data form
                Container(
                  height: MediaQuery.of(context).size.height * 1.5,
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
                    padding: const EdgeInsets.all(10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //Name field
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                //hintText: "Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //NIC field
                            TextFormField(
                              controller: _nicController,
                              decoration: InputDecoration(
                                labelText: "NIC",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Address field
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: "Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Mobile Number field
                            TextFormField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                labelText: "Mobile No",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //status selector dropdown
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              value: _status,
                              onChanged: (value) =>
                                  setState(() => _status = value),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'Married',
                                  child: Text('Married'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Single',
                                  child: Text('Single'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //no of family members field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "No of Family Members",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //No of Child field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "No of Child",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //insurance selector dropdown
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Type of Insurance',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              value: _insurance,
                              onChanged: (value) =>
                                  setState(() => _insurance = value),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'Monthly',
                                  child: Text('Monthly'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Quarterly',
                                  child: Text('Quarterly'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Half Yearly',
                                  child: Text('Half Yearly'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Yearly',
                                  child: Text('Yearly'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Present Insurer
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Present Insurer",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Monthly Income
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Monthly Income",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Monthly Expences
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Monthly Expences",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            //Remark
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Remark",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Divider(
                              color: kLightGrey,
                              thickness: 3,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              buttonName: "Save",
                              buttonColor: kGreen,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomButton(
                              buttonName: "Cancel",
                              buttonColor: kRed,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
