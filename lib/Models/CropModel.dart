class CropModel {
  final String name;
  final String category;
  final double price;
  final int quantity;
  final int farmerId;
  final DateTime harvestingDate;
  final String imageUrl;

  CropModel({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.farmerId,
    required this.harvestingDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "price": price,
      "quantity": quantity,
      "farmerId": farmerId,
      "harvestingDate": harvestingDate.toIso8601String(),
      "imageUrl": imageUrl,
    };
  }
}
class Crop {
  final int cropId;
  final String name;
  final String category;
  final int farmerId;
  final String createdAt;
  final String harvestingDate;
  final String imageUrl;
  final int price;
  final int quantity;

  Crop({
    required this.cropId,
    required this.name,
    required this.category,
    required this.farmerId,
    required this.createdAt,
    required this.harvestingDate,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cropId: json['cropId'] ?? 0, // Ensure default value
      name: json['name'] ?? 'Unknown',
      category: json['category'] ?? 'Unknown',
      farmerId: json['farmerId'] ?? 0, // Ensure it's mapped properly
      createdAt: json['createdAt'] ?? '',
      harvestingDate: json['harvestingDate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0, // Ensure it's mapped properly
    );
  }
}
