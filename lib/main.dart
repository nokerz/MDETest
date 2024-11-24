// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/header_provider.dart';
import 'providers/product_list_provider.dart';
import 'widgets/custom_header.dart';
import 'widgets/product_input_form.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HeaderProvider()),
        ChangeNotifierProvider(create: (_) => ProductListProvider()),
      ],
      child: MaterialApp(
        title: 'Product Input App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.publicSansTextTheme(),
        ),
        home: const ProductInputScreen(),
      ),
    );
  }
}

class ProductInputScreen extends StatelessWidget {
  const ProductInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      body: ProductInputForm(),
    );
  }
}
