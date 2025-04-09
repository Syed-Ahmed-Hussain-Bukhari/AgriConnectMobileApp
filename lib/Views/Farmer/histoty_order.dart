import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerHistotyOrder extends StatefulWidget {
  @override
  _FarmerHistotyOrderPageState createState() => _FarmerHistotyOrderPageState();
}


class _FarmerHistotyOrderPageState extends State<FarmerHistotyOrder> {
  List<Map<String, dynamic>> orders = [];
  Map<int, String> buyerPhoneNumbers = {};

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? farmerId = prefs.getInt('userId');

    if (farmerId == null) return;

    final response = await http.get(
      Uri.parse('http://152.67.10.128:5280/api/farmer/GetCompleteOrdersByFarmer/$farmerId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedOrders =
          List<Map<String, dynamic>>.from(data['\$values']);

      setState(() => orders = fetchedOrders);

      for (var order in fetchedOrders) {
        fetchBuyerPhoneNumber(order['buyerId']);
      }
    }
  }

  Future<void> fetchBuyerPhoneNumber(int buyerId) async {
    final response = await http.get(
      Uri.parse('http://152.67.10.128:5280/api/Admin/$buyerId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => buyerPhoneNumbers[buyerId] = data['phoneNumber']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Orders"),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[50],
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order, phoneNumber: buyerPhoneNumbers[order['buyerId']] ?? "Loading...");
              },
            ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String phoneNumber;

  const OrderCard({Key? key, required this.order, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(order['cropImage'], width: 80, height: 80, fit: BoxFit.cover),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['cropName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                      SizedBox(height: 5),
                      Text("Quantity: ${order['orderQuantity']} kg", style: TextStyle(fontSize: 16, color: Colors.green[700])),
                      Text("Amount: \$${order['orderAmount']}", style: TextStyle(fontSize: 16, color: Colors.green[700])),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                ClipOval(
                  child: Image.network(order['buyerImage'], width: 50, height: 50, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['buyerName'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[900])),
                      Text(order['buyerEmail'], style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Text("Phone: $phoneNumber", style: TextStyle(fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
