import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'accounts_provider.dart';
import 'product.dart';
import 'product_detail_screen.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({
    @required this.isShownInCart,
    @required this.selectedProducts,
  });

  final List<Product> selectedProducts;
  final isShownInCart;

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  Widget getProduct(int index, AccountsProvider accountProvider) {
    return ListTile(
      tileColor: Colors.grey[200],
      leading: Hero(
          tag: widget.selectedProducts[index].id,
          child: Image.asset(
            '${widget.selectedProducts[index].image}',
            width: 50,
          )),
      title: Text(widget.selectedProducts[index].title),
      onTap: () => Navigator.pushNamed(context, ProductDetailScreen.routeName,
          arguments: {widget.selectedProducts[index]: true}),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brand: ${widget.selectedProducts[index].brand}'),
          Text('Price: \$${widget.selectedProducts[index].price}'),
        ],
      ),
      trailing: widget.isShownInCart
          ? Text(
              'x${accountProvider.activatedAccount.productsInCart[widget.selectedProducts[index].id]}')
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    accountProvider.activatedAccount.favorites
                            .contains(widget.selectedProducts[index].id)
                        ? accountProvider
                            .removeFavorite(widget.selectedProducts[index].id)
                        : accountProvider
                            .addFavorite(widget.selectedProducts[index].id);
                  },
                  child: Icon(
                      accountProvider.activatedAccount.favorites
                              .contains(widget.selectedProducts[index].id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red),
                ),
                GestureDetector(
                  onTap: () {
                    accountProvider.activatedAccount.productsInCart
                            .containsKey(widget.selectedProducts[index].id)
                        ? accountProvider.removeFromCart(
                            widget.selectedProducts[index].id, -1)
                        : accountProvider.addToCart(
                            widget.selectedProducts[index].id, 1);
                  },
                  child: Icon(
                      accountProvider.activatedAccount.productsInCart
                              .containsKey(widget.selectedProducts[index].id)
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: Colors.red),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountsProvider>(context);
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.selectedProducts.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          child: widget.isShownInCart
              ? Dismissible(
                  onDismissed: (_) {
                    accountProvider.removeFromCart(
                        widget.selectedProducts[index].id, -1);
                  },
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(5),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) {
                    return showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Do you want to remove from cart?"),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text("NO")),
                            FlatButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text("YES")),
                          ],
                        );
                      },
                    );
                  },
                  key: ValueKey(widget.selectedProducts[index].id),
                  child: getProduct(index, accountProvider),
                )
              : getProduct(index, accountProvider),
        );
      },
    );
  }
}
