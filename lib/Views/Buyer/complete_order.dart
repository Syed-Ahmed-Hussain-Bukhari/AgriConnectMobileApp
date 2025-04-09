import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmedOrdersScreen extends StatefulWidget {
  @override
  _ConfirmedOrdersScreenState createState() => _ConfirmedOrdersScreenState();
}

class _ConfirmedOrdersScreenState extends State<ConfirmedOrdersScreen> {
  List<Map<String, dynamic>> confirmedCrops = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (userId != null) {
      await fetchConfirmedCrops();
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
    print("User ID Loaded: $userId");
  }

  Future<void> fetchConfirmedCrops() async {
    if (userId == null) {
      print("User ID is null. Cannot fetch crops.");
      return;
    }

    final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/$userId');
    print("Fetching data from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("API Response: $jsonData");

        List<Map<String, dynamic>> extractedCrops = [];

        List<dynamic> orders = jsonData["\$values"] ?? [];
        for (var order in orders) {
          List<dynamic> cropsList = order["crops"]["\$values"] ?? [];
          for (var crop in cropsList) {
            if (crop["status"] == "ConfirmOrder") {
              // Add orderId to each crop
              crop["orderId"] = order["orderId"];
              extractedCrops.add(crop);
            }
          }
        }

        setState(() {
          confirmedCrops = extractedCrops;
        });

        print("Extracted Confirmed Crops: $confirmedCrops");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching crops: $e");
    }
  }

  Future<void> completeOrder(int orderId) async {
    final url =
        Uri.parse('http://152.67.10.128:5280/api/Order/complete/$orderId');
    print("Completing order: $url");

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print("Order $orderId marked as completed");
        setState(() {
          confirmedCrops.removeWhere((crop) => crop['orderId'] == orderId);
        });
      } else {
        print(
            "Error completing order: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error completing order: $e");
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
          title: Text("Confirmed Orders"),
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
        body: confirmedCrops.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: confirmedCrops.length,
                      itemBuilder: (context, index) {
                        var crop = confirmedCrops[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                crop['imageUrl'] != null
                                    ? Image.network(
                                        crop['imageUrl'],
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                                SizedBox(height: 10),
                                Text("Name: ${crop['name']}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text("Category: ${crop['category']}"),
                                Text("Quantity: ${crop['quantity']}"),
                                Text("Amount: Rs. ${crop['amount']}"),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    completeOrder(crop['orderId']);
                                    // completeOrder(crop['orderId']);
                                    print(crop);
                                  },
                                  child: Text("Completed"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
