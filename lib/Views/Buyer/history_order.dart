import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  List<Map<String, dynamic>> completedOrders = [];
  int? userId;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (userId != null) {
      await fetchCompletedOrders();
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
    print("User ID Loaded: $userId");
  }

  Future<void> fetchCompletedOrders() async {
    if (userId == null) {
      print("User ID is null. Cannot fetch orders.");
      return;
    }

    final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/$userId');
    print("Fetching data from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("API Response: $jsonData");

        List<Map<String, dynamic>> extractedOrders = [];
        double sumTotal = 0.0;

        List<dynamic> orders = jsonData["\$values"] ?? [];
        for (var order in orders) {
          List<dynamic> crops = order["crops"]["\$values"] ?? [];

          // Check if at least one crop in the order has "Completed" status
          bool hasCompletedCrop =
              crops.any((crop) => crop["status"] == "Completed");

          if (hasCompletedCrop) {
            extractedOrders.add(order);

            // Calculate total amount for completed crops in this order
            for (var crop in crops) {
              if (crop["status"] == "Completed") {
                sumTotal += (crop['amount'] ?? 0).toDouble();
              }
            }
          }
        }

        setState(() {
          completedOrders = extractedOrders;
          totalAmount = sumTotal;
        });

        print("Extracted Completed Orders: $completedOrders");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching orders: $e");
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
        appBar: AppBar(
          title: Text("Completed Orders"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BuyerMain()),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: completedOrders.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: completedOrders.length,
                      itemBuilder: (context, index) {
                        var order = completedOrders[index];
                        List<dynamic> crops = order["crops"]["\$values"] ?? [];

                        return Card(
                          margin: EdgeInsets.all(8),
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order ID: ${order['orderId']}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
"Total Amount: Rs. ${crops.fold<int>(0, (sum, crop) => crop['status'] == 'Completed' ? sum + (crop['amount'] as num).toInt() : sum)}"
,
                                    style: TextStyle(fontSize: 14)),
                                Text("Date: ${order['orderDate']}",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 5),
                                Text("Crops:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...crops
                                    .where(
                                        (crop) => crop["status"] == "Completed")
                                    .map<Widget>((crop) {
                                  return ListTile(
                                    leading: crop['imageUrl'] != null &&
                                            crop['imageUrl'].isNotEmpty
                                        ? Image.network(
                                            crop['imageUrl'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.broken_image,
                                                        size: 50),
                                          )
                                        : Icon(Icons.image_not_supported,
                                            size: 50),
                                    title: Text(
                                        "${crop['name']} (${crop['quantity']})"),
                                    subtitle:
                                        Text("Amount: Rs. ${crop['amount']}"),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border(
                  top: BorderSide(color: Colors.green, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Rs. $totalAmount",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
