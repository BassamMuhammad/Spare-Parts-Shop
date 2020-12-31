import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/accounts_provider.dart';
import 'package:spare_parts/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/productDetail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _controller = TextEditingController();
  Map<Product, bool> argument;
  Product product;
  bool fromProduct;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    argument = ModalRoute.of(context).settings.arguments;
    product = argument.keys.first;
    fromProduct = argument.values.first;
    var productsInCart =
        Provider.of<AccountsProvider>(context).activatedAccount.productsInCart;
    if (productsInCart[product.id] == null)
      _controller.text = '1';
    else
      _controller.text = '${productsInCart[product.id]}';
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: product.id,
                        child: Image.asset(
                          '${product.image}',
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          accountProvider.activatedAccount.favorites
                                  .contains(product.id)
                              ? accountProvider.removeFavorite(product.id)
                              : accountProvider.addFavorite(product.id);
                        },
                        child: Icon(
                            accountProvider.activatedAccount.favorites
                                    .contains(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Text(product.title, style: TextStyle(fontSize: 30)),
                Text('Brand: ${product.brand}', style: TextStyle(fontSize: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price: \$${product.price}',
                        style: TextStyle(fontSize: 30)),
                  ],
                ),
                SizedBox(height: 25),
                if (fromProduct)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              try {
                                int value = int.parse(_controller.text);
                                if (value < 10000)
                                  setState(
                                      () => _controller.text = '${value + 1}');
                              } catch (e) {
                                setState(() {
                                  _controller.text = '1';
                                });
                              }
                            },
                            child: Container(
                              color: Colors.grey,
                              child: Icon(Icons.add, size: 35),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 30,
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              try {
                                int value = int.parse(_controller.text);
                                if (value > 1)
                                  setState(
                                      () => _controller.text = '${value - 1}');
                              } catch (e) {
                                setState(() {
                                  _controller.text = '1';
                                });
                              }
                            },
                            child: Container(
                                color: Colors.grey,
                                child: Icon(
                                  Icons.remove,
                                  size: 35,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (fromProduct) SizedBox(height: 20),
                if (fromProduct)
                  Center(
                    child: Builder(
                      builder: (ctx) => RaisedButton(
                        onPressed: () {
                          accountProvider.addToCart(
                              product.id, int.parse(_controller.text));
                          Scaffold.of(ctx).showSnackBar(
                              SnackBar(content: const Text('Added to Cart')));
                        },
                        color: Colors.red,
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
