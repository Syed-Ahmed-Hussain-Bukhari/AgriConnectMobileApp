import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class CropController {
  static const String apiUrl = "http://152.67.10.128:5280/api/crops";

  Future<String> addCrop({
    required String name,
    required String category,
    required double price,
    required int quantity,
    required DateTime harvestingDate,
    required File image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? farmerId = await prefs.getInt('userId'); // Get stored Farmer ID

      if (farmerId == null) {
        return "Farmer ID is missing. Please log in again.";
      }

      // Print all the data passed from the UI
      print('');
      print('');
      print('');
      print('');
      print('');
      print('');
      print("=== Crop Data from UI ===");
      print("Name: $name");
      print("Category: $category");
      print("Price: $price");
      print("Quantity: $quantity");
      print("Harvesting Date: ${harvestingDate.toUtc().toIso8601String()}");
      print("Farmer ID: $farmerId");
      print("Image Path: ${image.path}");
      print("=========================");

      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Add text fields
      request.fields["name"] = name;
      request.fields["category"] = category;
      request.fields["price"] = price.toString();
      request.fields["quantity"] = quantity.toString();
      request.fields["farmerId"] = farmerId.toString();
      request.fields["harvestingDate"] =
          harvestingDate.toUtc().toIso8601String();

      // Attach image
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image', // Ensure this matches the backend's expected field name
        stream,
        length,
        filename: basename(image.path),
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      print("Sending request to API: $apiUrl");

      var response = await request.send();

      print("Response status: ${response.statusCode}");

      var responseBody = await response.stream.bytesToString();
      print("Raw Response Body: $responseBody"); // Ensure response is printed

      if (response.statusCode == 201) {
        print("Crop added successfully: $responseBody");
        return "Crop added successfully!";
      } else {
        print("Failed to add crop. Response: $responseBody");
        return "Failed to add crop. Please try again.";
      }
    } catch (e) {
      print("Error uploading crop: $e");
      return "Error uploading crop: $e";
    }
  }
}
