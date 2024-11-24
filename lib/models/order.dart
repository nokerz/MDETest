// lib/models/order.dart
class Order {
  final String orderNumber;
  final List<OrderItem> items;

  Order({required this.orderNumber, required this.items});
}

class OrderItem {
  final String productName;
  final int quantity;
  String? notes;
  List<String> images;

  OrderItem({
    required this.productName,
    required this.quantity,
    this.notes,
    this.images = const [],
  });
}
