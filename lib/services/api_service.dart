// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// lib/services/api_service.dart
class ApiService {
  static const String baseUrl = 'https://app.giotheapp.com/api-sample/';

  Future<List<String>> fetchProducts() async {
    try {
      print('Fetching products from: $baseUrl'); // Add logging

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Add logging
      print('Response body: ${response.body}'); // Add logging

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data.values.map((item) => item.toString()).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e'); // Add logging
      throw Exception('Error fetching products: $e');
    }
  }
}
