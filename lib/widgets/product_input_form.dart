// lib/widgets/product_input_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_design_expert/models/order.dart';
import 'package:media_design_expert/screens/order_preview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';

// Update the ProductInputForm
class ProductInputForm extends StatefulWidget {
  const ProductInputForm({Key? key}) : super(key: key);

  @override
  _ProductInputFormState createState() => _ProductInputFormState();
}

class _ProductInputFormState extends State<ProductInputForm> {
  final _formKey = GlobalKey<FormState>();
  final List<ProductRowController> _controllers = [];
  final TextEditingController _orderNumberController =
      TextEditingController(text: '096');

  @override
  void initState() {
    super.initState();
    _addNewRow();
  }

  void _addNewRow() {
    setState(() {
      _controllers.add(ProductRowController());
    });
  }

  bool get hasFilledRows {
    return _controllers.any((controller) => controller.isRowFilled);
  }

  void _clean() {
    setState(() {
      for (var controller in _controllers) {
        controller.dispose();
      }
      _controllers.clear();
      _addNewRow();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && hasFilledRows) {
      // Create order object
      final order = Order(
        orderNumber: '112${_orderNumberController.text}',
        items: _controllers
            .where((controller) => controller.isRowFilled)
            .map((controller) => OrderItem(
                  productName: controller.nameController.text,
                  quantity: int.parse(controller.quantityController.text),
                ))
            .toList(),
      );

      // Navigate to preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPreviewScreen(order: order),
        ),
      );
    }
  }

  int findFirstEmptyRowIndex() {
    return _controllers.indexWhere((controller) => !controller.isRowFilled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        // Add Form widget here
        key: _formKey, // Add form key
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // X Icon (Clean)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 24,
                    ),
                    onPressed: _clean,
                  ),

                  // Right Arrow (Preview)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: hasFilledRows ? Colors.blue : Colors.grey,
                      size: 24,
                    ),
                    onPressed: hasFilledRows
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Create order object
                              final order = Order(
                                orderNumber:
                                    '112${_orderNumberController.text}',
                                items: _controllers
                                    .where(
                                        (controller) => controller.isRowFilled)
                                    .map((controller) => OrderItem(
                                          productName:
                                              controller.nameController.text,
                                          quantity: int.parse(controller
                                              .quantityController.text),
                                        ))
                                    .toList(),
                              );

                              // Navigate to preview screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderPreviewScreen(order: order),
                                ),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),

            // Order Number Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Order # 112',
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _orderNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Text(
                    ' (allow edit)',
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Table Container (rest of your existing code)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Quantity Header
                              Container(
                                width: constraints.maxWidth * 0.2,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Qty',
                                  style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              // Product Name Header
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Product Name',
                                    style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table Body
                        Expanded(
                          child: ListView.builder(
                            itemCount: _controllers.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Quantity Field
                                    Container(
                                      width: constraints.maxWidth * 0.2,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _controllers[index]
                                            .quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          hintText: '0',
                                          hintStyle: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        style: GoogleFonts.publicSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // Product Name Field
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Autocomplete<String>(
                                                optionsBuilder:
                                                    (TextEditingValue
                                                        textEditingValue) {
                                                  return context
                                                      .read<
                                                          ProductListProvider>()
                                                      .getSuggestions(
                                                          textEditingValue
                                                              .text);
                                                },
                                                onSelected: (String selection) {
                                                  _controllers[index]
                                                      .nameController
                                                      .text = selection;
                                                },
                                                fieldViewBuilder: (context,
                                                    controller,
                                                    focusNode,
                                                    onFieldSubmitted) {
                                                  controller.text =
                                                      _controllers[index]
                                                          .nameController
                                                          .text;
                                                  return TextFormField(
                                                    controller: controller,
                                                    focusNode: focusNode,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      hintText:
                                                          'Enter product name',
                                                      hintStyle: GoogleFonts
                                                          .publicSans(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    style:
                                                        GoogleFonts.publicSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Required';
                                                      }
                                                      return null;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            if (_controllers.length > 1)
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    _controllers[index]
                                                        .dispose();
                                                    _controllers
                                                        .removeAt(index);
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Modified Action Buttons - only Add Product button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: _addNewRow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Text(
                              'Add Product',
                              style: GoogleFonts.publicSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderNumberController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ProductRowController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();

  bool get isRowFilled =>
      nameController.text.isNotEmpty && quantityController.text.isNotEmpty;

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    nameFocusNode.dispose();
    quantityFocusNode.dispose();
  }
}

// Update the ProductInputRow
class ProductInputRow extends StatelessWidget {
  final ProductRowController controller;
  final VoidCallback onDelete;
  final VoidCallback onFocusRequest;

  const ProductInputRow({
    Key? key,
    required this.controller,
    required this.onDelete,
    required this.onFocusRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blue.withOpacity(0.2), width: 1),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: onDelete,
                iconSize: 20,
              ),

              // Quantity Field
              SizedBox(
                width: 80,
                child: TextFormField(
                  controller: controller.quantityController,
                  focusNode: controller.quantityFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    hintText: '0',
                    hintStyle: GoogleFonts.publicSans(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (int.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                  onTap: onFocusRequest,
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withOpacity(0.3),
              ),

              // Product Name Field with Autocomplete
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return productProvider
                        .getSuggestions(textEditingValue.text);
                  },
                  onSelected: (String selection) {
                    controller.nameController.text = selection;
                  },
                  fieldViewBuilder:
                      (context, textController, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: textController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        hintText: 'Enter product name',
                        hintStyle: GoogleFonts.publicSans(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        return null;
                      },
                      onTap: onFocusRequest,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
