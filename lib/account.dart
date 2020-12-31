import 'package:flutter/foundation.dart';

import 'order.dart';

class Account {
  String name;
  String mobileNumber;
  String emailAddress;
  String password;
  List<int> favorites = [];
  Map<int, int> productsInCart = {};
  List<Order> orders = [];

  Account(
      {@required this.emailAddress,
      @required this.mobileNumber,
      @required this.name,
      @required this.password});
}
