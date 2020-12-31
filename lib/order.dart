import 'package:flutter/foundation.dart';

class Order {
  Map<int, int> productsIdToQuant;
  double total;
  DateTime dateTime;
  bool completed;

  Order(
      {@required this.completed,
      @required this.dateTime,
      @required this.productsIdToQuant,
      @required this.total});
}
