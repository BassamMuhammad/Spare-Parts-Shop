import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/cart_screen.dart';
import 'package:spare_parts/orders_screen.dart';
import 'package:spare_parts/product.dart';
import 'package:spare_parts/products_display_screen.dart';
import 'package:spare_parts/products_provider.dart';

import 'accounts_provider.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = '/bottomNavBar';
  @override
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  var _index = 0;
  final bodyWidgets = [
    ProductsDisplayScreen(),
    CartScreen(),
    OrdersScreen(),
  ];

  Map<int, int> productsIndex;

  List<Product> productsInCart;

  @override
  Widget build(BuildContext context) {
    productsIndex =
        Provider.of<AccountsProvider>(context).activatedAccount.productsInCart;

    productsInCart = Provider.of<ProductsProvider>(context)
        .products
        .where((product) => productsIndex.containsKey(product.id))
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        onTap: (index) => setState(() => _index = index),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.two_wheeler_outlined),
              label: 'Products Display'),
          BottomNavigationBarItem(
              icon: productsInCart.length == 0
                  ? Icon(Icons.shopping_cart)
                  : Badge(
                      position: BadgePosition.topEnd(top: -10, end: 0),
                      animationDuration: Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      badgeContent: Text(
                        '${productsInCart.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(Icons.shopping_cart),
                    ),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined), label: 'Orders'),
        ],
      ),
      body: bodyWidgets[_index],
    );
  }
}
