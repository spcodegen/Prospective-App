import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MyCollectionScreen extends StatefulWidget {
  final String username;
  const MyCollectionScreen({
    super.key,
    required this.username,
  });

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  List<dynamic> collectionData = [];
  bool isLoading = false;

  final apiBaseUrl =
      'http://client.cooplife.lk:8006/PolicyPaymentDetails/DateRange';

  Future<void> fetchData() async {
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both From Date and To Date')),
      );
      return;
    }

    final formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate!);
    final formattedToDate = DateFormat('yyyy-MM-dd').format(toDate!);

    final apiUrl =
        '$apiBaseUrl/${widget.username}/$formattedFromDate/$formattedToDate';

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          collectionData = json.decode(response.body);
          print(collectionData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wraps the content
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.analytics,
                    size: 34,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'My Collections Summary',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('From Date'),
                        InkWell(
                          onTap: () => selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              fromDate == null
                                  ? 'Select Date'
                                  : DateFormat('yyyy-MM-dd').format(fromDate!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('To Date'),
                        InkWell(
                          onTap: () => selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              toDate == null
                                  ? 'Select Date'
                                  : DateFormat('yyyy-MM-dd').format(toDate!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchData,
                child: const Text('Search'),
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : collectionData.isEmpty
                      ? const Center(child: Text('No data available'))
                      : SizedBox(
                          height:
                              430, // Adjusted to ensure proper scrollable area
                          child: PaginatedDataTable(
                            header: const Text('Collection Data'),
                            columns: const [
                              DataColumn(label: Text('Policy No')),
                              DataColumn(label: Text('Customer Name')),
                              DataColumn(label: Text('Collect Amount')),
                              DataColumn(label: Text('Collect Date')),
                            ],
                            source: _CollectionDataSource(collectionData),
                            rowsPerPage: 5,
                            showFirstLastButtons: true,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionDataSource extends DataTableSource {
  final List<dynamic> data;

  _CollectionDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text(item['policyNo'] ?? '')),
      DataCell(Text(item['cusName'] ?? '')),
      DataCell(Text(item['payment'].toString())),
      DataCell(Text(item['paidDate'] ?? '')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
