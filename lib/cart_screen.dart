import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/product_list.dart';
import 'package:spare_parts/products_provider.dart';

import 'accounts_provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var productsInCartIndexes =
        Provider.of<AccountsProvider>(context).activatedAccount.productsInCart;
    var products = Provider.of<ProductsProvider>(context).products;
    var productsInCart = products
        .where((product) => productsInCartIndexes.containsKey(product.id))
        .toList();
    double total = 0;
    for (var product in productsInCart) {
      var quantity = productsInCartIndexes[product.id];
      var price = product.price;
      total += price * quantity;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total:  ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$$total',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (ctx) => FlatButton(
                          onPressed: () {
                            Scaffold.of(ctx).showSnackBar(
                                SnackBar(content: const Text('Order Placed!')));
                            Provider.of<AccountsProvider>(context,
                                    listen: false)
                                .shiftFromCartToOrder(total);
                          },
                          child: const Text(
                            'Order Now',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 20),
            if (productsInCart.isNotEmpty)
              ProductsList(
                  selectedProducts: productsInCart, isShownInCart: true),
            if (productsInCart.isEmpty)
              const Text(
                'Nothing in Cart',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
