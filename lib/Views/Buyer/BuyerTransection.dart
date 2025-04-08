import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {
  final int userId;
  const TransactionScreen({super.key, required this.userId});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List transactions = [];
  Map<int, Map<String, String>> receiverDetails = {};

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await http.get(
      Uri.parse(
          'http://152.67.10.128:5280/api/Order/transactions/buyer/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        transactions = data['\$values'];
      });
      fetchReceiverDetails();
    }
  }

  Future<void> fetchReceiverDetails() async {
    for (var transaction in transactions) {
      int receiverId = transaction['receiverId'];
      if (!receiverDetails.containsKey(receiverId)) {
        final response = await http.get(
          Uri.parse('http://152.67.10.128:5280/api/Admin/$receiverId'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            receiverDetails[receiverId] = {
              'name': data['userName'],
              'phone': data['phoneNumber'],
              'address': data['address'],
            };
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuyerMain()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: transactions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var transaction = transactions[index];
                  var receiverId = transaction['receiverId'];
                  var receiver = receiverDetails[receiverId] ?? {};

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transaction ID: ${transaction['transactionId']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Type: ${transaction['transactionType']}'),
                          Text('Amount: \$${transaction['amount']}'),
                          Text('Date: ${transaction['transectionAt']}'),
                          const SizedBox(height: 10),
                          receiver.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Receiver: ${receiver['name']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Phone: ${receiver['phone']}'),
                                    Text('Address: ${receiver['address']}'),
                                  ],
                                )
                              : const Text('Fetching receiver details...'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
