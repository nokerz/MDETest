// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://app.giotheapp.com/api-sample/';

  Future<List<String>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Print the response to see the actual format
        print('API Response: ${response.body}');

        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);

        // Check if there's a specific key containing the product list
        // Adjust this based on the actual response structure
        if (data.containsKey('data')) {
          List<dynamic> products = data['data'];
          return products.map((item) => item.toString()).toList();
        } else {
          // If the structure is different, print it for debugging
          print('Response structure: $data');

          // Convert map values to list if needed
          return data.values.map((item) => item.toString()).toList();
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error fetching products: $e');
    }
  }
}
