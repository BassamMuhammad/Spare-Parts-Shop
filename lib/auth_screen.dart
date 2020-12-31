import 'package:flutter/material.dart';
import 'package:spare_parts/auth.dart';

class AuthorizationScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlatButton.icon(
                  onPressed: () => null,
                  icon: Icon(Icons.arrow_back),
                  label: Text("Back")),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          "images/logo.PNG",
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Auth(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
