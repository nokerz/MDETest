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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.publicSans(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
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

  TableRow _buildTableRow(
    String header,
    String value, {
    required Color headerColor,
    Color? valueColor,
    bool isEditable = false,
    VoidCallback? onTap,
    bool isOptional = false,
  }) {
    // Determine if this row should have bold text
    bool isBoldRow = header == 'Order #' ||
        header == 'Order name' ||
        header == 'Delivery date';

    return TableRow(
      children: [
        // Header cell remains the same
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: headerColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (isOptional && header == 'Order name')
                Text(
                  'optional',
                  style: GoogleFonts.publicSans(
                    color: Colors.grey,
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        // Value cell with updated font weight for specific fields
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: header == 'Location'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery to:',
                              style: GoogleFonts.publicSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value,
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                color: valueColor ?? Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      : Text(
                          value,
                          style: GoogleFonts.publicSans(
                            fontSize: 16,
                            fontWeight: isBoldRow
                                ? FontWeight.w600
                                : FontWeight.w400, // Updated this line
                            color: valueColor ?? Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                if (isEditable) const SizedBox(width: 8),
                if (isEditable)
                  Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ],
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
            Container(
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 123,
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: const Color.fromRGBO(0, 107, 131, 1),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Table(
                          columnWidths: const {
                            0: IntrinsicColumnWidth(flex: 1),
                            1: FlexColumnWidth(2),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            _buildTableRow(
                              'Order #',
                              widget.order.orderNumber,
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              valueColor: const Color.fromRGBO(0, 107, 131, 1),
                              isEditable: false,
                            ),
                            _buildTableRow(
                              'Order name',
                              orderName,
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              valueColor: const Color.fromRGBO(0, 107, 131, 1),
                              isEditable: true,
                              onTap: () => _showEditDialog(
                                  'Order name',
                                  orderName,
                                  (value) => setState(() => orderName = value)),
                              isOptional: true,
                            ),
                            _buildTableRow(
                              'Delivery date',
                              deliveryDate,
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              valueColor: const Color.fromRGBO(0, 107, 131, 1),
                              isEditable: true,
                              onTap: () => _showEditDialog(
                                  'Delivery date',
                                  deliveryDate,
                                  (value) =>
                                      setState(() => deliveryDate = value)),
                            ),
                            _buildTableRow(
                              'Total quantity',
                              totalQuantity.toString(),
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              isEditable: false,
                            ),
                            _buildTableRow(
                              'Estimated total',
                              '\$${estimatedTotal.toStringAsFixed(2)}',
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              isEditable: false,
                            ),
                            _buildTableRow(
                              'Location',
                              location,
                              headerColor: const Color.fromRGBO(80, 0, 185, 1),
                              isEditable: true,
                              onTap: () => _showEditDialog('Location', location,
                                  (value) => setState(() => location = value)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await _showEditDialog(
                            'Delivery instructions',
                            deliveryInstructions,
                            (value) =>
                                setState(() => deliveryInstructions = value),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          'Delivery instructions ...',
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(0, 107, 131, 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      // Replace the existing TextButton for "Save as draft" with this:
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved as draft'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment
                              .centerLeft, // Align the button content to the left
                        ),
                        child: Text(
                          'Save as draft',
                          style: GoogleFonts.publicSans(
                            color: const Color(0xFF007BA7),
                            fontSize: 14, // Changed from 16 to 14
                            fontWeight: FontWeight.w600, // Changed to 600
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
