import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmerOrdersScreen extends StatefulWidget {
  const FarmerOrdersScreen({Key? key}) : super(key: key);

  @override
  _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;
  int? farmerId;

  @override
  void initState() {
    super.initState();
    _getFarmerId();
  }

  Future<void> _getFarmerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId'); // Fetch stored userId

    if (userId != null) {
      setState(() {
        farmerId = userId;
      });
      _fetchOrders(userId);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error: User ID not found in SharedPreferences")),
      );
    }
  }

  Future<void> _fetchOrders(int farmerId) async {
    final url = Uri.parse(
        "http://152.67.10.128:5280/api/farmer/GetConfirmedOrdersByFarmer/${farmerId}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> orderList = data["\$values"];

        for (var order in orderList) {
          final buyerData = await _fetchBuyerDetails(order["buyerId"]);
          order["buyerDetails"] = buyerData;
        }

        setState(() {
          orders = orderList;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchBuyerDetails(int buyerId) async {
    final url = Uri.parse("http://152.67.10.128:5280/api/Admin/$buyerId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching buyer details: $e");
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmed Orders")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No confirmed orders found."))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    var buyer = order["buyerDetails"] ?? {};

                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Crop Image and Name
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    order["cropImage"],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order["cropName"],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text("Quantity: ${order["orderQuantity"]}",
                                        style: const TextStyle(fontSize: 16)),
                                    Text("Amount: Rs. ${order["orderAmount"]}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            // Buyer Info
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    buyer["imageUrl"] ?? "",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(buyer["userName"] ?? "Unknown",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(buyer["address"] ?? "No address",
                                        style: const TextStyle(fontSize: 14)),
                                    Text(buyer["phoneNumber"] ?? "No phone",
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
