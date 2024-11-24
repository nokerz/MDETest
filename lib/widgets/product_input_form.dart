import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_design_expert/models/order.dart';
import 'package:media_design_expert/screens/order_preview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';

class ProductInputForm extends StatefulWidget {
  const ProductInputForm({Key? key}) : super(key: key);

  @override
  _ProductInputFormState createState() => _ProductInputFormState();
}

class _ProductInputFormState extends State<ProductInputForm> {
  final _formKey = GlobalKey<FormState>();
  final List<ProductRowController> _controllers = [];
  final TextEditingController _orderNumberController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    // Initialize 20 controllers
    for (int i = 0; i < 20; i++) {
      final controller = ProductRowController();
      controller.quantityController.addListener(() {
        setState(() {});
      });
      _controllers.add(controller);
    }
  }

  bool get hasFilledRows {
    return _controllers.any((controller) => controller.isRowFilled);
  }

  // Method to find first empty row
  int findFirstEmptyRowIndex() {
    for (int i = 0; i < _controllers.length; i++) {
      if (!_controllers[i].isRowFilled) {
        return i;
      }
    }
    return 0;
  }

  // Method to handle focus change
  void handleFocusChange(int currentIndex, bool isQuantityField) {
    if (currentIndex > 0) {
      // Check if there are any empty rows above
      int firstEmptyIndex = findFirstEmptyRowIndex();
      if (firstEmptyIndex < currentIndex) {
        // Move focus to the appropriate field in the first empty row
        if (isQuantityField) {
          _controllers[firstEmptyIndex].quantityFocusNode.requestFocus();
        } else {
          _controllers[firstEmptyIndex].nameFocusNode.requestFocus();
        }
      }
    }
  }

  void _clean() {
    setState(() {
      for (var controller in _controllers) {
        controller.dispose();
      }
      _controllers.clear();
      // Reinitialize controllers
      for (int i = 0; i < 20; i++) {
        final controller = ProductRowController();
        controller.quantityController.addListener(() {
          setState(() {});
        });
        _controllers.add(controller);
      }
    });
  }

  void _submit() {
    if (hasFilledRows) {
      final filledRows =
          _controllers.where((controller) => controller.isRowFilled).toList();
      final order = Order(
        orderNumber: '112${_orderNumberController.text}',
        items: filledRows
            .map((controller) => OrderItem(
                  productName: controller.nameController.text,
                  quantity: int.parse(controller.quantityController.text),
                ))
            .toList(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPreviewScreen(order: order),
        ),
      );
    }
  }

  String? validateQuantity(String? value) {
    if (value != null && value.isNotEmpty) {
      if (int.tryParse(value) == null) {
        return 'Invalid';
      }
    }
    return null;
  }

  String? validateProductName(String? value) {
    return null; // No validation required
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Bar
              if (hasFilledRows)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color.fromRGBO(0, 107, 131, 1),
                          size: 24,
                        ),
                        onPressed: _clean,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color.fromRGBO(0, 107, 131, 1),
                          size: 24,
                        ),
                        onPressed: _submit,
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
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _orderNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 8,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '(allow edit)',
                          hintStyle: GoogleFonts.publicSans(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 107, 131, 1),
                        ),
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
                                  itemCount: _controllers.length,
                                  itemBuilder: (context, index) {
                                    return Container(
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
                                            width: constraints.maxWidth * 0.16,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: const Color.fromRGBO(
                                                      0, 107, 131, 1),
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _controllers[index]
                                                  .quantityController,
                                              focusNode: _controllers[index]
                                                  .quantityFocusNode,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle:
                                                    GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              style: GoogleFonts.publicSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              validator: validateQuantity,
                                              onTap: () => handleFocusChange(
                                                  index, true),
                                            ),
                                          ),

                                          // Product Name Field
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Autocomplete<String>(
                                                      optionsBuilder:
                                                          (TextEditingValue
                                                              textEditingValue) {
                                                        if (textEditingValue
                                                            .text.isEmpty) {
                                                          return const Iterable<
                                                              String>.empty();
                                                        }
                                                        return context
                                                            .read<
                                                                ProductListProvider>()
                                                            .getSuggestions(
                                                                textEditingValue
                                                                    .text);
                                                      },
                                                      onSelected:
                                                          (String selection) {
                                                        setState(() {
                                                          _controllers[index]
                                                              .nameController
                                                              .text = selection;
                                                        });
                                                      },
                                                      fieldViewBuilder: (context,
                                                          textEditingController,
                                                          focusNode,
                                                          onFieldSubmitted) {
                                                        if (textEditingController
                                                                .text !=
                                                            _controllers[index]
                                                                .nameController
                                                                .text) {
                                                          textEditingController
                                                                  .text =
                                                              _controllers[
                                                                      index]
                                                                  .nameController
                                                                  .text;
                                                        }

                                                        return TextFormField(
                                                          controller:
                                                              textEditingController,
                                                          focusNode: focusNode,
                                                          onTap: () =>
                                                              handleFocusChange(
                                                                  index, true),
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: '',
                                                            hintStyle:
                                                                GoogleFonts
                                                                    .publicSans(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                          ),
                                                          style: GoogleFonts
                                                              .publicSans(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                          onChanged: (value) {
                                                            _controllers[index]
                                                                .nameController
                                                                .text = value;
                                                          },
                                                          validator:
                                                              validateProductName,
                                                        );
                                                      },
                                                    ),
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

  void syncControllers(TextEditingController externalController) {
    if (externalController.text != nameController.text) {
      nameController.text = externalController.text;
    }
  }
}
