import 'package:flutter/cupertino.dart';
import 'package:spare_parts/order.dart';

import 'account.dart';

class AccountsProvider with ChangeNotifier {
  final Map<String, Account> _accounts = {};
  Account _activatedAccount;

  Account get activatedAccount {
    return _activatedAccount;
  }

  set setActivatedAccount(Account account) {
    _activatedAccount = account;
    notifyListeners();
  }

  void addFavorite(int index) {
    _activatedAccount.favorites.add(index);
    notifyListeners();
  }

  void removeFavorite(int index) {
    _activatedAccount.favorites.remove(index);
    notifyListeners();
  }

  void addToCart(int index, int value) {
    _activatedAccount.productsInCart[index] = value;
    notifyListeners();
  }

  void removeFromCart(int index, int value) {
    var productsInCart = _activatedAccount.productsInCart;
    if (value <= 0)
      productsInCart.remove(index);
    else {
      productsInCart[index] -= value;
      if (productsInCart[index] <= 0) productsInCart.remove(index);
    }
    notifyListeners();
  }

  void shiftFromCartToOrder(double total) {
    var order = Order(
        completed: false,
        dateTime: DateTime.now(),
        productsIdToQuant: _activatedAccount.productsInCart
            .map((key, value) => MapEntry(key, value)),
        total: total);
    _activatedAccount.orders.add(order);
    _activatedAccount.productsInCart.clear();
    notifyListeners();
  }

  void removeOrder(DateTime dateTime) {
    _activatedAccount.orders.removeWhere((order) => order.dateTime == dateTime);
  }

  Map<String, Account> get accounts {
    Map<String, Account> accounts = {};
    accounts.addAll(_accounts);
    return accounts;
  }

  void addAccount(Account account) {
    _accounts[account.emailAddress] = account;
    notifyListeners();
  }
}
