import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmerCropDetailScreen extends StatefulWidget {
  final int cropId;

  const FarmerCropDetailScreen({Key? key, required this.cropId})
      : super(key: key);

  @override
  _FarmerCropDetailScreenState createState() => _FarmerCropDetailScreenState();
}

class _FarmerCropDetailScreenState extends State<FarmerCropDetailScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  Map<String, dynamic>? _cropData;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _fetchCropDetails();
  }

  Future<void> _fetchCropDetails() async {
    final url =
        Uri.parse("http://152.67.10.128:5280/api/crops/${widget.cropId}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _cropData = data;
          _priceController.text = data["price"].toString();
          _quantityController.text = data["quantity"].toString();
          _isLoading = false;
        });
      } else {
        _showSnackbar(
            "Failed to load crop details. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  Future<void> _updateCropDetails() async {
    if (_cropData == null) return;

    final url =
        Uri.parse("http://152.67.10.128:5280/api/crops/Edit/${widget.cropId}");

    final Map<String, dynamic> updatedData = {
      "name": _cropData!["name"],
      "category": _cropData!["category"],
      "price": int.tryParse(_priceController.text) ?? _cropData!["price"],
      "quantity":
          int.tryParse(_quantityController.text) ?? _cropData!["quantity"],
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        _showSnackbar("Crop details updated successfully!");
        setState(() {
          _isEditing = false;
        });
        _fetchCropDetails(); // Fetch updated data
      } else {
        _showSnackbar(
            "Failed to update crop details. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cropData?["name"] ?? "Loading..."),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _updateCropDetails();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Crop Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      _cropData!["imageUrl"],
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 100);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Crop Details
                  Text(
                    _cropData!["name"],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Category: ${_cropData!["category"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // Editable Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Price: Rs. ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _isEditing
                          ? SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Text(
                              "Rs. ${_cropData!["price"]}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Editable Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Quantity: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      _isEditing
                          ? SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Text(
                              "${_cropData!["quantity"]}",
                              style: const TextStyle(fontSize: 18),
                            ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
