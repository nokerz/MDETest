# Media Design Expert Order Management App

A Flutter application for managing product orders with features like product listing, order preview, and order submission.

## Features

- Product order management
- Dynamic product list
- Order preview with item details
- Notes and image attachments at preview screen for items
- Order submission with delivery details

## Prerequisites

- Flutter SDK (Version 3.0.0 or higher)
- Dart SDK (Version 3.0.0 or higher)
- VS Code

## Dependencies

dependencies:
  flutter:
    sdk: flutter
  flutter_lints: ^4.0.0
  http: ^1.2.2
  flutter_riverpod: ^2.6.1
  riverpod: ^2.6.1
  provider: ^6.0.0
  google_fonts: ^6.2.1
  image_picker: ^1.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

## Tutorial How to use

    - Insert Product Name (will automatically search the api from https://app.giotheapp.com/api-sample/) and quantity , click add product if needed
    - edit the Order No (if needed, by default it set to 096) only 3 digit after 112 can be edited.
    - click arrow right button at upper right conner
    - Click 'X' if want to clean the product name and quantity fill
    - After click arrow right button it will go straight to the preview page
    - click submit to go to order page , click on Order Name, Delivery Address, Delivery data or Delivery Instruction to edit it.