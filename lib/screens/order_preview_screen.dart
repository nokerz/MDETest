// At the top of order_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_design_expert/screens/submit_order_screen.dart';
import 'package:media_design_expert/widgets/custom_header.dart';
import '../models/order.dart';
import '../widgets/item_detail_modal.dart';

// Update the OrderPreviewScreen's item builder
class OrderPreviewScreen extends StatefulWidget {
  final Order order;

  const OrderPreviewScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderPreviewScreenState createState() => _OrderPreviewScreenState();
}

class _OrderPreviewScreenState extends State<OrderPreviewScreen> {
  Future<void> _showItemDetails(OrderItem item) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemDetailModal(item: item),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(), // Replace the AppBar with CustomHeader
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Order #',
                  style: GoogleFonts.publicSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                Text(
                  widget.order.orderNumber,
                  style: GoogleFonts.publicSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),

          // Items Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Qty',
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Product Name',
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.builder(
              itemCount: widget.order.items.length,
              // Update the item builder in ListView.builder
              itemBuilder: (context, index) {
                final item = widget.order.items[index];
                return InkWell(
                  onLongPress: () => _showItemDetails(item),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              item.quantity.toString(),
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.productName,
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (item.notes?.isNotEmpty ?? false)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          if (item.images.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubmitOrderScreen(order: widget.order),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(0, 48),
                    ),
                    child: Text(
                      'Confirm Order',
                      style: GoogleFonts.publicSans(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    child: Text(
                      'Edit Order',
                      style: GoogleFonts.publicSans(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
