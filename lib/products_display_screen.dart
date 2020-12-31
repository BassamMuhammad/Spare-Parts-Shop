import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:spare_parts/accounts_provider.dart';
import 'package:spare_parts/product.dart';
import 'package:spare_parts/products_provider.dart';

import 'product_detail_screen.dart';
import 'product_list.dart';

class ProductsDisplayScreen extends StatefulWidget {
  static const routeName = '/productsDisplay';

  @override
  _ProductsDisplayScreenState createState() => _ProductsDisplayScreenState();
}

class _ProductsDisplayScreenState extends State<ProductsDisplayScreen> {
  var _showFavs = false;
  var _selectedBrands = ['All'];
  var _brands = [
    'All',
    'Honda',
    'Yamaha',
    'BMW',
    'Harley-Davidson',
    'Aprilia',
    'Ducati',
    'Indian Motorcycle'
  ];

  List<Product> getProducts() {
    var products = Provider.of<ProductsProvider>(context).products;
    var activatedAccount =
        Provider.of<AccountsProvider>(context).activatedAccount;
    if (_showFavs)
      return products
          .where((product) => activatedAccount.favorites.contains(product.id))
          .toList();
    if (_selectedBrands.contains('All')) return products;
    return products
        .where((product) => _selectedBrands.contains(product.brand))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var selectedProducts = getProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spare Parts'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: SearchPage<Product>(
                          builder: (product) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: ListTile(
                                tileColor: Colors.grey[200],
                                leading: Hero(
                                  tag: product.id,
                                  child: Image.asset(
                                    '${product.image}',
                                    width: 50,
                                  ),
                                ),
                                title: Text(product.title),
                                onTap: () => Navigator.pushNamed(
                                    context, ProductDetailScreen.routeName,
                                    arguments: {product: true}),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Brand: ${product.brand}'),
                                    Text('Price: \$${product.price}'),
                                  ],
                                ),
                              ),
                            );
                          },
                          filter: (product) {
                            return [
                              product.title,
                              product.brand,
                              product.price.toString()
                            ];
                          },
                          failure: Center(
                            child: const Text('No match found :('),
                          ),
                          items: selectedProducts));
                },
                child: Icon(Icons.search)),
          ),
        ],
      ),
      body: ListView(
        physics: ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Brands',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text('Favorites'),
                    Switch(
                      value: _showFavs,
                      onChanged: (value) => setState(() => _showFavs = value),
                    ),
                  ],
                )
              ],
            ),
          ),
          ChipsChoice<String>.multiple(
            value: _selectedBrands,
            onChanged: (val) {
              setState(() {
                _selectedBrands = val;
              });
            },
            choiceItems: C2Choice.listFrom<String, String>(
              source: _brands,
              value: (index, item) => item,
              label: (index, item) => item,
              disabled: (index, item) => _showFavs,
            ),
            choiceActiveStyle: C2ChoiceStyle(avatarBorderColor: Colors.white),
            choiceAvatarBuilder: (item) {
              if (item.value == 'All')
                return CircleAvatar(child: const Text('A'));
              else
                return Image.asset(
                  'images/${item.value}.PNG',
                );
            },
          ),
          Divider(),
          SizedBox(height: 10),
          ProductsList(
              selectedProducts: selectedProducts, isShownInCart: false),
        ],
      ),
    );
  }
}
