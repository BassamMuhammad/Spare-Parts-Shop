import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/accounts_provider.dart';
import 'package:spare_parts/auth_screen.dart';
import 'package:spare_parts/bottom_navbar.dart';
import 'package:spare_parts/cart_screen.dart';
import 'package:spare_parts/order_detail_screen.dart';
import 'package:spare_parts/orders_screen.dart';
import 'package:spare_parts/products_display_screen.dart';
import 'package:spare_parts/products_provider.dart';

import 'product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<AccountsProvider>(
            create: (context) => AccountsProvider()),
        ListenableProvider<ProductsProvider>(
            create: (context) => ProductsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
        routes: {
          AuthorizationScreen.routeName: (context) => AuthorizationScreen(),
          ProductsDisplayScreen.routeName: (context) => ProductsDisplayScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          OrderDetailScreen.routeName: (context) => OrderDetailScreen(),
          BottomNavBar.routeName: (context) => BottomNavBar(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(seconds: 5),
        () => Navigator.of(context)
            .pushReplacementNamed(AuthorizationScreen.routeName));
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.red,
                  blurRadius: 5,
                  spreadRadius: 15,
                ),
                BoxShadow(
                  color: Colors.red[600],
                  blurRadius: 5,
                  spreadRadius: 15,
                ),
                BoxShadow(
                  color: Colors.red[700],
                  blurRadius: 5,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Colors.red[800],
                  blurRadius: 5,
                  spreadRadius: 5,
                ),
              ]),
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "images/logo.PNG",
                    fit: BoxFit.contain,
                    width: 150,
                    height: 150,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          FittedBox(
            fit: BoxFit.cover,
            child: Text(
              "Best Market For Bike Parts",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
