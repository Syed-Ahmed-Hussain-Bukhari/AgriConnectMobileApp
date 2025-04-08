import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  Future<bool> createOrder(int cropId, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final buyerId = prefs.getInt('userId') ?? 0;

      final url = Uri.parse('http://152.67.10.128:5280/api/Order/create-order');

      final Map<String, dynamic> orderData = {
        "buyerId": buyerId,
        "cropId": cropId,
        "quantity": quantity,
        "status": "Pending"
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
