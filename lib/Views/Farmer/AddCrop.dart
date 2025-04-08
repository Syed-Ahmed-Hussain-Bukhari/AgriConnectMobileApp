import 'dart:io';
import 'package:agriconnect/Views/Farmer/mainFarmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCrop extends StatefulWidget {
  const AddCrop({super.key});

  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _harvestingDate;
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitCrop(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
      _showSnackbar(context as BuildContext, "Please select an image.");
      return;
    }
    if (_harvestingDate == null) {
      _showSnackbar(
          context as BuildContext, "Please select a harvesting date.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      int? farmerId = await prefs.getInt('userId');

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://152.67.10.128:5280/api/crops"),
      );

      // Add text fields
      request.fields["name"] = _nameController.text;
      request.fields["category"] = _categoryController.text;
      request.fields["price"] = _priceController.text;
      request.fields["quantity"] = _quantityController.text;
      request.fields["farmerId"] = farmerId.toString();
      request.fields["harvestingDate"] =
          _harvestingDate!.toUtc().toIso8601String();

      // Attach image file
      var imageStream = http.ByteStream(_image!.openRead());
      var imageLength = await _image!.length();
      var multipartFile = http.MultipartFile(
        'File', // This should match the backend field name
        imageStream,
        imageLength,
        filename: basename(_image!.path),
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      var response = await request.send();
      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        _showSnackbar(context, "Crop added successfully!",
            isSuccess: true);
        print("");
        print("");
        print("");
        print("Crop added successfully!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FarmerMain()),
          );
      } else {
        _showSnackbar(context as BuildContext,
            "Failed to add crop. Status code: ${response.statusCode}");
        print("Failed to add crop. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackbar(context as BuildContext,"Error: $e");
      print('');
      print('');
      print('');
      print('');
      print('');
      print("Error: $e");
    }
  }

void _showSnackbar(BuildContext context, String message, {bool isSuccess = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Crop")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Crop Name"),
                validator: (value) => value!.isEmpty ? "Enter crop name" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
                validator: (value) => value!.isEmpty ? "Enter category" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter price" : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter quantity" : null,
              ),
              ListTile(
                title: Text(
                  _harvestingDate == null
                      ? "Select Harvesting Date"
                      : _harvestingDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => _harvestingDate = pickedDate);
                  }
                },
              ),
              const SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!, height: 100)
                  : TextButton(
                      onPressed: _pickImage,
                      child: const Text("Pick Image"),
                    ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _submitCrop(context),
                      child: const Text("Submit"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
