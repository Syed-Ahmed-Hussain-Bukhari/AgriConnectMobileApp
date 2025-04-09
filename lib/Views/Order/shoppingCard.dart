// import 'dart:convert';
// import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class ShoppingScreen extends StatefulWidget {
//   const ShoppingScreen({super.key});

//   @override
//   State<ShoppingScreen> createState() => _ShoppingScreenState();
// }

// class _ShoppingScreenState extends State<ShoppingScreen> {
//   List<Map<String, dynamic>> _cartItems = [];
//   bool _isLoading = true;
//   int _totalAmount = 0;
//   int? userId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _fetchCartItems();
//   }

//   Future<void> _fetchCartItems() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       int? buyerId = await prefs.getInt('userId');

//       final url =
//           Uri.parse("http://152.67.10.128:5280/api/Order/buyer/$buyerId");
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         List<dynamic> orders = data["\$values"] ?? [];
//         List<Map<String, dynamic>> cartItems = [];

//         for (var order in orders) {
//           List<dynamic> crops = order["crops"]["\$values"] ?? [];

//           for (var crop in crops) {
//             if (crop["status"] == "Not Confirmed") {
//               cartItems.add({
//                 "orderId": order["orderId"],
//                 "orderDate": order["orderDate"],
//                 "cropId": crop["cropId"],
//                 "farmerId": crop["farmerId"],
//                 "amount": crop["amount"],
//                 "quantity": crop["quantity"],
//                 "imageUrl": crop["imageUrl"],
//                 "name": crop["name"],
//                 "category": crop["category"],
//                 "status": crop["status"],
//               });
//             }
//           }
//         }

//         setState(() {
//           _cartItems = cartItems;
//           _calculateTotalAmount();
//           _isLoading = false;
//         });
//       } else {
//         print("Failed to fetch cart items: ${response.body}");
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       print("Error fetching cart: $e");
//       setState(() => _isLoading = false);
//     }
//   }

//   void _calculateTotalAmount() {
//     _totalAmount =
//         _cartItems.fold(0, (sum, item) => sum + (item['amount'] as int));
//   }

//   void _deleteItem(int orderId) async {
//     final url =
//         Uri.parse("http://152.67.10.128:5280/api/Order/cancel-order/$orderId");

//     print("Cancelling order: $orderId");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//       );

//       if (response.statusCode == 200) {
//         print("Order cancelled successfully!");
//         _fetchCartItems(); // Refresh cart after cancellation
//       } else {
//         print(
//             "Failed to cancel order. Status: ${response.statusCode}, Response: ${response.body}");
//       }
//     } catch (e) {
//       print("Error cancelling order: $e");
//     }
//   }

//   void _editItem(int orderId, int cropId, int currentQuantity) {
//     TextEditingController quantityController =
//         TextEditingController(text: currentQuantity.toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Quantity"),
//           content: TextField(
//             controller: quantityController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(labelText: "Enter new quantity"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 int newQuantity =
//                     int.tryParse(quantityController.text) ?? currentQuantity;
//                 Navigator.pop(context);
//                 _updateQuantity(orderId, cropId, newQuantity);
//               },
//               child: const Text("Confirm"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _updateQuantity(int orderId, int cropId, int quantity) async {
//     final url = Uri.parse("http://152.67.10.128:5280/api/Order/eidt-order");

//     final body = jsonEncode({
//       "orderId": orderId,
//       "cropId": cropId,
//       "quantity": quantity,
//     });
//     print("");
//     print("");
//     print("");
//     print("");
//     print("");

//     final Map<String, dynamic> orderData = {
//       "orderId": orderId,
//       "cropId": cropId,
//       "quantity": quantity,
//     };

//     print("Updating quantity: $body");
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 200) {
//         print("Quantity updated successfully!");
//         _fetchCartItems(); // Refresh cart
//       } else {
//         print(
//             "Failed to update quantity. Status: ${response.statusCode}, Response: ${response.body}");
//       }
//     } catch (e) {
//       print("Error updating quantity: $e");
//     }
//   }

//   /// Loads user data and fetches confirmed crops
//   Future<void> _initializeData() async {
//     await _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getInt('userId');
//     });
//     print("User ID Loaded: $userId");
//   }

//   Future<void> confirmOrder() async {
//     if (userId == null) {
//       print("User ID is null. Cannot confirm order.");
//       return;
//     }

//     final url =
//         Uri.parse('http://152.67.10.128:5280/api/Order/confirm-orders/$userId');
//     print(url);

//     try {
//       final response =
//           await http.post(url, headers: {"Content-Type": "application/json"});

//       if (response.statusCode == 200) {
//         print("Order confirmed successfully!");

//         // Navigate back to BuyerMain
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => BuyerMain()),
//         );
//       } else {
//         print(
//             "Error confirming order: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _cartItems.isEmpty
//               ? const Center(child: Text("Your cart is empty!"))
//               : Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: _cartItems.length,
//                         itemBuilder: (context, index) {
//                           final item = _cartItems[index];
//                           return Card(
//                             margin: const EdgeInsets.all(10),
//                             child: Column(
//                               children: [
//                                 ListTile(
//                                   leading: Image.network(item['imageUrl'],
//                                       width: 50, height: 50, fit: BoxFit.cover),
//                                   title: Text(item['name'],
//                                       style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold)),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Category: ${item['category']}"),
//                                       Text("Amount: Rs. ${item['amount']}",
//                                           style: const TextStyle(
//                                               color: Colors.green)),
//                                       Text("Quantity: ${item['quantity']} kg"),
//                                       Text("Status: ${item['status']}",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                       Text("Order Date: ${item['orderDate']}"),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     TextButton.icon(
//                                         icon: const Icon(Icons.edit,
//                                             color: Colors.blue),
//                                         label: const Text("Edit"),
//                                         onPressed: () {
//                                           _editItem(item['orderId'],
//                                               item['cropId'], item['quantity']);
//                                         }),
//                                     TextButton.icon(
//                                       icon: const Icon(Icons.delete,
//                                           color: Colors.red),
//                                       label: const Text("Delete"),
//                                       onPressed: () => _deleteItem(
//                                           item['orderId']), // Pass orderId
//                                     ),
//                                     const SizedBox(width: 10),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Text("Total Amount: Rs. $_totalAmount",
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: confirmOrder,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 24),
//                             ),
//                             child: const Text("Confirm Order",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }

import 'dart:convert';
// import 'package:agriconnect/jazzcash.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:jazzcash/jazzcash.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  int _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      int? buyerId = await prefs.getInt('userId');

      final url =
          Uri.parse("http://152.67.10.128:5280/api/Order/buyer/$buyerId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> orders = data["\$values"] ?? [];
        List<Map<String, dynamic>> cartItems = [];

        for (var order in orders) {
          List<dynamic> crops = order["crops"]["\$values"] ?? [];

          for (var crop in crops) {
            if (crop["status"] == "Not Confirmed") {
              // ✅ Filtering condition
              cartItems.add({
                "orderId": order["orderId"],
                "orderDate": order["orderDate"],
                "cropId": crop["cropId"],
                "farmerId": crop["farmerId"],
                "amount": crop["amount"],
                "quantity": crop["quantity"],
                "imageUrl": crop["imageUrl"],
                "name": crop["name"],
                "category": crop["category"],
                "status": crop["status"],
              });
            }
          }
        }

        setState(() {
          _cartItems = cartItems;
          _calculateTotalAmount();
          _isLoading = false;
        });
      } else {
        print("Failed to fetch cart items: ${response.body}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching cart: $e");
      setState(() => _isLoading = false);
    }
  }

  void _calculateTotalAmount() {
    _totalAmount =
        _cartItems.fold(0, (sum, item) => sum + (item['amount'] as int));
  }

  void _deleteItem(int orderId) async {
    final url =
        Uri.parse("http://152.67.10.128:5280/api/Order/cancel-order/$orderId");

    print("Cancelling order: $orderId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("Order cancelled successfully!");
        _fetchCartItems(); // Refresh cart after cancellation
      } else {
        print(
            "Failed to cancel order. Status: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("Error cancelling order: $e");
    }
  }

  void _editItem(int orderId, int cropId, int currentQuantity) {
    TextEditingController quantityController =
        TextEditingController(text: currentQuantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Quantity"),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Enter new quantity"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                int newQuantity =
                    int.tryParse(quantityController.text) ?? currentQuantity;
                Navigator.pop(context);
                _updateQuantity(orderId, cropId, newQuantity);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _updateQuantity(int orderId, int cropId, int quantity) async {
    final url = Uri.parse("http://152.67.10.128:5280/api/Order/eidt-order");

    final body = jsonEncode({
      "orderId": orderId,
      "cropId": cropId,
      "quantity": quantity,
    });
    print("");
    print("");
    print("");
    print("");
    print("");

    final Map<String, dynamic> orderData = {
      "orderId": orderId,
      "cropId": cropId,
      "quantity": quantity,
    };

    print("Updating quantity: $body");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        print("Quantity updated successfully!");
        _fetchCartItems(); // Refresh cart
      } else {
        print(
            "Failed to update quantity. Status: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

// Future<void> payment() async {
//   String dateTimeNow = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
//   String expireDateTime = DateFormat("yyyyMMddHHmmss")
//       .format(DateTime.now().add(Duration(hours: 1)));
//   String txnRefNo = "T$dateTimeNow";

//   // JazzCash fields
//   Map<String, String> data = {
//     "pp_Amount": "100",
//     "pp_BillReference": "billRef",
//     "pp_Description": "Description",
//     "pp_Language": "EN",
//     "pp_MerchantID": "MC149907",
//     "pp_Password": "t224aw8t20",
//     "pp_ReturnURL": "http://152.67.10.128:5280/api/payment/jazzcash/callback",
//     "pp_TxnCurrency": "PKR",
//     "pp_TxnDateTime": dateTimeNow,
//     "pp_TxnExpiryDateTime": expireDateTime,
//     "pp_TxnRefNo": txnRefNo,
//     "pp_TxnType": "MWALLET",
//     "pp_Version": "1.1",
//     "ppmpf_1": "03402153345",
//   };

//   String integritySalt = "8x8sayyyc5";

//   // Filter out null or empty values
//   Map<String, String> filteredData = {
//     for (var entry in data.entries)
//       if (entry.value.trim().isNotEmpty) entry.key: entry.value
//   };

//   // Sort keys
//   List<String> sortedKeys = filteredData.keys.toList()..sort();

//   // Build raw string for hash
//   String rawData = integritySalt;
//   for (String key in sortedKeys) {
//     rawData += '&$key=${filteredData[key]}';
//   }

//   print("RawData for Hash: $rawData");

//   // Generate secure hash
//   var key = utf8.encode(integritySalt);
//   var bytes = utf8.encode(rawData);
//   var hmacSha256 = Hmac(sha256, key);
//   String secureHash = hmacSha256.convert(bytes).toString().toUpperCase();

//   print("Generated Secure Hash: $secureHash");

//   // Add hash to data
//  filteredData["pp_SecureHash"] = secureHash;

//   // Send POST request
//   var url = Uri.parse(
//       "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction");
//   var response = await http.post(url, body: filteredData);

//   print("JazzCash Response Status: ${response.statusCode}");
//   print("JazzCash Response Body: ${response.body}");
// }

//   Future<void> payment() async {
//     setState(() {
//       _isLoading = true;
//     });

//     String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
//     String dexpiredate = DateFormat("yyyyMMddHHmmss")
//         .format(DateTime.now().add(Duration(days: 1)));
//     String tre = "T" + dateandtime;

//     // Replace with your actual values
//     String pp_Amount = (_totalAmount * 100).toString(); // Amount in paisa
//     String pp_BillReference = "CartPayment";
//     String pp_Description = "Payment for crops";
//     String pp_Language = "EN";
//     String pp_MerchantID = "MC149907";
//     String pp_Password = "t224aw8t20";
//     String pp_ReturnURL =
//         "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
//     // String pp_ReturnURL = "http://152.67.10.128:5280/api/payment/jazzcash/callback";
// //
//     String pp_Version = "1.1";
//     String pp_TxnCurrency = "PKR";
//     String pp_TxnDateTime = dateandtime;
//     String pp_TxnExpiryDateTime = dexpiredate;
//     String pp_TxnRefNo = tre;
//     String pp_TxnType = "MWALLET";
//     String ppmpf_1 = "03123456789";
//     String IntegritySalt = "8x8sayyyc5";

//     // Concatenate in correct order with key=value
//     String rawData = [
//       "pp_Version=$pp_Version",
//       "pp_TxnType=$pp_TxnType",
//       "pp_Language=$pp_Language",
//       "pp_MerchantID=$pp_MerchantID",
//       "pp_Password=$pp_Password",
//       "pp_TxnRefNo=$pp_TxnRefNo",
//       "pp_Amount=$pp_Amount",
//       "pp_TxnCurrency=$pp_TxnCurrency",
//       "pp_TxnDateTime=$pp_TxnDateTime",
//       "pp_BillReference=$pp_BillReference",
//       "pp_Description=$pp_Description",
//       "pp_TxnExpiryDateTime=$pp_TxnExpiryDateTime",
//       "pp_ReturnURL=$pp_ReturnURL",
//       "ppmpf_1=$ppmpf_1"
//     ].join('&');

//     String secureHashData = "$IntegritySalt&$rawData";

//     var key = utf8.encode(IntegritySalt);
//     var bytes = utf8.encode(secureHashData);
//     var hmacSha256 = Hmac(sha256, key);
//     Digest sha256Result = hmacSha256.convert(bytes);

//     var url =
//         'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';
//     var bodies = {
//       "pp_Version": pp_Version,
//       "pp_TxnType": pp_TxnType,
//       "pp_Language": pp_Language,
//       "pp_MerchantID": pp_MerchantID,
//       "pp_Password": pp_Password,
//       "pp_TxnRefNo": pp_TxnRefNo,
//       "pp_Amount": pp_Amount,
//       "pp_TxnCurrency": pp_TxnCurrency,
//       "pp_TxnDateTime": pp_TxnDateTime,
//       "pp_BillReference": pp_BillReference,
//       "pp_Description": pp_Description,
//       "pp_TxnExpiryDateTime": pp_TxnExpiryDateTime,
//       "pp_ReturnURL": pp_ReturnURL,
//       "ppmpf_1": ppmpf_1,
//       "pp_SecureHash": sha256Result.toString().toUpperCase(),
//     };
//     try {
//       var response = await http.post(Uri.parse(url), body: bodies);

//       var body = jsonDecode(response.body);
//       if (body['pp_ResponseCode'] == '000') {
//         print("✅ Payment Success: ${body['pp_ResponseMessage']}");
//         // Mark order as paid or navigate
//       } else {
//         print("❌ Payment Failed: ${body['pp_ResponseMessage']}");
//         print(bodies);
//         print(body);
//       }
//     } catch (e) {
//       print("❌ Error during payment: $e");
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

  void processPayment(BuildContext context) async {
    setState(() {
      // isLoading = true;
    });
    //print("process payment function is called");
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(Duration(days: 1)));
    String tre = "T" + dateandtime;
    String pp_Amount = "100000";
    String pp_BillReference = "billRef";
    String pp_Description = "order payment";
    String pp_Language = "EN";

    // kanza
    // String pp_MerchantID = "MC150308";
    // String pp_Password = "b21301ftxb";

    // saad 1
    // String pp_MerchantID = "MC149907";
    // String pp_Password = "t224aw8t20";

// saad 2
    String pp_MerchantID = "MC150600";
    String pp_Password = "91x05gfa90";

    // String pp_ReturnURL = "www.example.com";
    String pp_ReturnURL = "https://sandbox.jazzcash.com.pk";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MWALLET";
    // String ppmpf_1 = "4456733833993";
    String ppmpf_1 = "03123456789";

    //kanza
    // String IntegeritySalt = "97u3t478y3";

    //saad 1
    // String IntegeritySalt = "8x8sayyyc5";


    //saad 2
    String IntegeritySalt = "gw5extgbww";

    String and = '&';
    String superdata = IntegeritySalt +
        and +
        pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_Description +
        and +
        pp_Language +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ReturnURL +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType +
        and +
        pp_ver +
        and +
        ppmpf_1;

    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    var url = Uri.parse(
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction');

    print("before post");
    var response = await http.post(url, body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": "4456733833993"
    });

    print("response=>");
    print(response.body);
    var res = await response.body;
    var body = jsonDecode(res);
    var responcePrice = body['pp_Amount'];
    print('payment successfully $responcePrice');
    // Fluttertoast.showToast(msg: "payment successfully $responcePrice");
    setState(() {
      // isLoading = false;
    });

    final List<dynamic> CartItems = arguments?['cartItems'] ?? [];
    final double totalAmount = arguments?['total'] ?? 0.0;

    for (var item in CartItems) {
      print(item.productID);
    }
    print(totalAmount);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve values from SharedPreferences
    // retailerId = prefs.getInt('retailer_id') ?? 0; // Default to 0 if no value is found
    // retailerName = prefs.getString('retailer_name') ?? 'No Name'; // Default to 'No Name'
    // retailerEmail = prefs.getString('retailer_email') ?? 'No Email'; // Default to 'No Email'

    // Print the retrieved values
    //print('Retailer ID: $retailerId');
    //print('Retailer Name: $retailerName');
    //print('Retailer Email: $retailerEmail');

    // Prepare the data for the POST request
    // final Map<String, dynamic> orderData = {

    //   'RetailerId': retailerId,
    //   'TotalPrice': totalAmount,
    //   'Products': CartItems
    //       .map((item) => {
    //             'ProductId': item.productID, // Assuming your cartItems have productId
    //           })
    //       .toList(),
    // };
    // print(orderData);
    // Make the POST request
    // try {
    //   print("try is calld");
    //   final response = await http.post( //added await here
    //     Uri.parse('http://localhost:5000/placeorder'), // Replace with your API endpoint
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(orderData),
    //   );

    //   if (response.statusCode == 201) {
    //     print("if is called");
    //     // Payment and order placement successful
    //     final responseData = json.decode(response.body);

    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //             'Payment of \$${totalAmount.toStringAsFixed(2)} was successful! OrderId: ${responseData['message'].split(': ').last}'),
    //       ),
    //     );
    //   } else {
    //     print("else is called");
    //     // Payment or order placement failed
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Payment failed. ${response.body}')),
    //     );
    //   }
    // } catch (e) {
    //   print("catch is called");
    //   // Handle network or other errors
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error placing order: $e')),
    //   );
    // }

    Navigator.pop(context); // Go back to the previous page after payment
  }

  void _confirmOrder() {
    processPayment(context);
    // makePayment(context);
    // JazzCashService.processPayment(amountInPkr: 1000);
    print("Order confirmed!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty!"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Image.network(item['imageUrl'],
                                      width: 50, height: 50, fit: BoxFit.cover),
                                  title: Text(item['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Category: ${item['category']}"),
                                      Text("Amount: Rs. ${item['amount']}",
                                          style: const TextStyle(
                                              color: Colors.green)),
                                      Text("Quantity: ${item['quantity']} kg"),
                                      Text("Status: ${item['status']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Order Date: ${item['orderDate']}"),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        label: const Text("Edit"),
                                        onPressed: () {
                                          _editItem(item['orderId'],
                                              item['cropId'], item['quantity']);
                                        }),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      label: const Text("Delete"),
                                      onPressed: () => _deleteItem(
                                          item['orderId']), // Pass orderId
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("Total Amount: Rs. $_totalAmount",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _confirmOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                            ),
                            child: const Text("Confirm Order",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
