import 'package:flutter/foundation.dart';

class Product {
  int id;
  String title;
  double price;
  String brand;
  String image;

  Product(
      {@required this.title,
      @required this.id,
      @required this.brand,
      @required this.image,
      @required this.price});
}
