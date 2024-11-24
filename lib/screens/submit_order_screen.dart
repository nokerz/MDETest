// lib/screens/submit_order_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';

class SubmitOrderScreen extends StatefulWidget {
  final Order order;

  const SubmitOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _SubmitOrderScreenState createState() => _SubmitOrderScreenState();
}

class _SubmitOrderScreenState extends State<SubmitOrderScreen> {
  String orderName = "Joe's catering";
  String deliveryDate = 'May 4th 2024';
  String location = '355 onderdonk st\nMarina Dubai, UAE';
  String deliveryInstructions = '';

  Future<void> _showEditDialog(
      String title, String currentValue, Function(String) onSave) async {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    String newValue = currentValue;

    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintStyle: GoogleFonts.publicSans(),
            ),
            style: GoogleFonts.publicSans(),
            maxLines:
                title == 'Location' || title == 'Delivery instructions' ? 3 : 1,
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.publicSans(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text); // Save the new value
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BA7),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.publicSans(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  Widget _buildEditableField(String label, String value, Function() onTap,
      {bool isOptional = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                if (isOptional)
                  Text(
                    ' (optional)',
                    style: GoogleFonts.publicSans(
                      color: Colors.grey,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalQuantity =
        widget.order.items.map((item) => item.quantity).reduce((a, b) => a + b);

    double estimatedTotal = widget.order.items
        .map((item) => item.quantity * 36.92)
        .reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and logo
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'lib/assets/images/logo.jpg',
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      'Order #',
                      widget.order.orderNumber,
                      const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildEditableField(
                      'Order name',
                      orderName,
                      () async {
                        await _showEditDialog('Order name', orderName, (value) {
                          if (mounted) {
                            // Check if widget is still mounted
                            setState(() => orderName = value);
                          }
                        });
                      },
                      isOptional: true,
                    ),
                    // Delivery Date (Editable)
                    _buildEditableField(
                      'Delivery date',
                      deliveryDate,
                      () async {
                        await _showEditDialog('Delivery date', deliveryDate,
                            (value) {
                          if (mounted) {
                            setState(() => deliveryDate = value);
                          }
                        });
                      },
                    ),
                    _buildField('Total quantity', totalQuantity.toString()),
                    _buildField(
                      'Estimated total',
                      '\$${estimatedTotal.toStringAsFixed(2)}',
                    ),
                    // Location (Editable)
                    _buildEditableField(
                      'Location',
                      location,
                      () async {
                        await _showEditDialog('Location', location, (value) {
                          if (mounted) {
                            setState(() => location = value);
                          }
                        });
                      },
                    ),
                    _buildEditableField(
                      'Delivery instructions',
                      deliveryInstructions.isEmpty
                          ? '...'
                          : deliveryInstructions,
                      () async {
                        await _showEditDialog(
                            'Delivery instructions', deliveryInstructions,
                            (value) {
                          if (mounted) {
                            setState(() => deliveryInstructions = value);
                          }
                        });
                      },
                      isOptional: true,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order submitted successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BA7),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'submit',
                        style: GoogleFonts.publicSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved as draft'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: Text(
                      'Save as draft',
                      style: GoogleFonts.publicSans(
                        color: const Color(0xFF007BA7),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // The original _buildField method remains the same
  Widget _buildField(String label, String value, [TextStyle? valueStyle]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.publicSans(
              color: label == 'Order #' ? Colors.purple : Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: valueStyle ??
                GoogleFonts.publicSans(
                  fontSize: 16,
                  color: Colors.black87,
                ),
          ),
        ],
      ),
    );
  }
}
