import 'package:agriconnect/Views/Farmer/detailcrops.dart';
import 'package:agriconnect/Views/Order/detailed.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropListScreen extends StatefulWidget {
  @override
  _CropListScreenState createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
  List<dynamic> crops = [];
  List<dynamic> filteredCrops = [];
  bool isLoading = true;
  int? userId;
  String searchQuery = "";
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });

    if (userId != null) {
      fetchCrops();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCrops() async {
    final String apiUrl = "http://152.67.10.128:5280/api/crops/farmer/$userId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          crops = jsonData["\$values"];
          filteredCrops = crops;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load crops");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching crops: $error");
    }
  }

  void _filterCrops() {
    setState(() {
      filteredCrops = crops.where((crop) {
        bool matchesSearch =
            crop["name"].toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesCategory =
            selectedCategory == null || crop["category"] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    _filterCrops();
  }

  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category == selectedCategory ? null : category;
    });
    _filterCrops();
  }

  void _navigateToCropDetail(dynamic crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FarmerCropDetailScreen(
          cropId: crop["cropId"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Crops")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userId == null
              ? const Center(child: Text("User ID not found"))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          labelText: "Search Crops",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _categoryButton("Fruit", Icons.apple),
                          _categoryButton("Vegetable", Icons.eco),
                          _categoryButton("Cereal", Icons.grain),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredCrops.isEmpty
                          ? const Center(child: Text("No crops found"))
                          : ListView.builder(
                              itemCount: filteredCrops.length,
                              itemBuilder: (context, index) {
                                final crop = filteredCrops[index];
                                return GestureDetector(
                                  onTap: () => _navigateToCropDetail(
                                      crop), // Navigate to detail screen
                                  child: Card(
                                    margin: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              crop["imageUrl"],
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(Icons.image,
                                                    size: 100);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            crop["name"],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Quantity: ${crop["quantity"]}",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _categoryButton(String category, IconData icon) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isSelected ? Colors.green : Colors.grey[300],
            child: Icon(icon,
                size: 30, color: isSelected ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 5),
          Text(category),
        ],
      ),
    );
  }
}
