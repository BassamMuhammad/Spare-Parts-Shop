import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/order.dart';
import 'package:spare_parts/product_detail_screen.dart';
import 'package:spare_parts/products_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/orderDetail';
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments;
    var products = Provider.of<ProductsProvider>(context).products;
    var productsInOrder = products
        .where((product) => order.productsIdToQuant.containsKey(product.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white70),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Products Ordered',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total:  \$${order.total}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < productsInOrder.length; i++)
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                  context, ProductDetailScreen.routeName,
                  arguments: {productsInOrder[i]: false}),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Chip(
                  backgroundColor: Colors.red,
                  label: ListTile(
                    leading: Chip(
                        backgroundColor: Colors.white,
                        label: Text('\$${productsInOrder[i].price}')),
                    title: Chip(
                        backgroundColor: Colors.white,
                        label: Text(
                            '${productsInOrder[i].brand}\'s ${productsInOrder[i].title}')),
                    trailing: Chip(
                        backgroundColor: Colors.white,
                        label: Text(
                            'x${order.productsIdToQuant[productsInOrder[i].id]}')),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
