import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/accounts_provider.dart';
import 'package:spare_parts/order.dart';
import 'package:spare_parts/order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<AccountsProvider>(context).activatedAccount.orders;
    var completedOrders = orders.where((order) => order.completed).toList();
    var inCompletedOrders = orders.where((order) => !order.completed).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: const Text('Under-Process Orders'),
                ),
              ),
              const Text('Completed Orders'),
            ],
          ),
        ),
        body: TabBarView(children: [
          inCompletedOrders.length == 0
              ? Center(
                  child: const Text('No under-process Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30)))
              : OrderWidget(
                  orders: inCompletedOrders,
                  completed: false,
                ),
          completedOrders.length == 0
              ? Center(
                  child: const Text('No completed Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30)))
              : OrderWidget(
                  orders: completedOrders,
                  completed: true,
                ),
        ]),
      ),
    );
  }
}

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    @required this.orders,
    @required this.completed,
  });

  final List<Order> orders;
  final bool completed;

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Widget getProduct(int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(OrderDetailScreen.routeName,
          arguments: widget.orders[index]),
      child: Chip(
        backgroundColor: Colors.red,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Chip(
              label: Text('\$${widget.orders[index].total}'),
              backgroundColor: Colors.white,
            ),
            Chip(
              backgroundColor: Colors.white,
              label: Text(
                'Ordered on ${widget.orders[index].dateTime.day}/${widget.orders[index].dateTime.month}/${widget.orders[index].dateTime.year}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: widget.orders.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(5),
          child: widget.completed
              ? getProduct(index)
              : Dismissible(
                  onDismissed: (_) {
                    Provider.of<AccountsProvider>(context, listen: false)
                        .removeOrder(widget.orders[index].dateTime);
                  },
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) {
                    return showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                              "Your order will be cancelled.Do you want to remove?"),
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
                  key: ValueKey(widget.orders[index].dateTime),
                  child: getProduct(index),
                ),
        ),
      ),
    );
  }
}
