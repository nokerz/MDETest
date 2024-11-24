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
      appBar: const CustomHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: const Color.fromRGBO(0, 107, 131, 1),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubmitOrderScreen(order: widget.order),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Order Number Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Text(
                      'Order #',
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(80, 0, 185, 1),
                      ),
                    ),
                    Text(
                      ' 112',
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(0, 107, 131, 1),
                      ),
                    ),
                    Text(
                      widget.order.orderNumber.substring(3),
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(0, 107, 131, 1),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    width: 342.99,
                    height: 675,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Table Body
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      20, // Show all 20 rows like in input form
                                  itemBuilder: (context, index) {
                                    final isFilledRow =
                                        index < widget.order.items.length;
                                    final item = isFilledRow
                                        ? widget.order.items[index]
                                        : null;

                                    return InkWell(
                                      onLongPress: isFilledRow
                                          ? () => _showItemDetails(item!)
                                          : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: const Color.fromRGBO(
                                                  0, 107, 131, 1),
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Quantity Field
                                            Container(
                                              width:
                                                  constraints.maxWidth * 0.16,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: const Color.fromRGBO(
                                                        0, 107, 131, 1),
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 16,
                                              ),
                                              child: Text(
                                                isFilledRow
                                                    ? item!.quantity.toString()
                                                    : '',
                                                style: GoogleFonts.publicSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),

                                            // Product Name Field
                                            // Product Name Field
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      isFilledRow
                                                          ? item!.productName
                                                          : '',
                                                      style: GoogleFonts
                                                          .publicSans(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    if (isFilledRow &&
                                                        (item!.notes
                                                                ?.isNotEmpty ??
                                                            false)) // Changed condition to check for notes
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4),
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          color: const Color
                                                              .fromRGBO(
                                                              0, 107, 131, 1),
                                                          size: 20,
                                                        ),
                                                      ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
