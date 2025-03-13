import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfirmedOrdersScreen extends StatefulWidget {
  @override
  _ConfirmedOrdersScreenState createState() => _ConfirmedOrdersScreenState();
}

class _ConfirmedOrdersScreenState extends State<ConfirmedOrdersScreen> {
  List<Map<String, dynamic>> confirmedCrops = [];

  @override
  void initState() {
    super.initState();
    fetchConfirmedCrops();
  }

  Future<void> fetchConfirmedCrops() async {
    final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> extractedCrops = [];

      if (jsonData.containsKey("\$values")) {
        for (var order in jsonData["\$values"]) {
          if (order.containsKey("crops") && order["crops"].containsKey("\$values")) {
            for (var crop in order["crops"]["\$values"]) {
              if (crop["status"] == "ConfirmOrder") {
                extractedCrops.add(crop);
              }
            }
          }
        }
      }

      setState(() {
        confirmedCrops = extractedCrops;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to BuyerMainScreen when back is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuyerMain()),
        );
        return false; // Prevents default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Confirmed Orders"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to BuyerMainScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BuyerMain()),
              );
            },
          ),
        ),
        body: confirmedCrops.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
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
                          Image.network(
                            crop['imageUrl'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text("Name: ${crop['name']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Category: ${crop['category']}"),
                          Text("Quantity: ${crop['quantity']}"),
                          Text("Amount: Rs. ${crop['amount']}"),
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
