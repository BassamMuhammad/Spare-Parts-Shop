import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spare_parts/account.dart';
import 'package:spare_parts/accounts_provider.dart';
import 'package:spare_parts/products_provider.dart';

import 'bottom_navbar.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var _showPassword = false;
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();
  var _passwordReFocus = FocusNode();
  var _nameFocus = FocusNode();
  var _mobileFocus = FocusNode();
  var _passwordReController = TextEditingController();
  var _nameController = TextEditingController();
  var _mobileController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _remember = false;
  var _login = true;

  @override
  void dispose() {
    super.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordReFocus.dispose();
    _nameFocus.dispose();
    _mobileFocus.dispose();
    _passwordReController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _tryLogin() {
    var email = _emailController.value.text;
    final accounts =
        Provider.of<AccountsProvider>(context, listen: false).accounts;
    if (accounts.containsKey(email)) {
      if (accounts[email].password == _passwordController.value.text) {
        Provider.of<AccountsProvider>(context, listen: false)
            .setActivatedAccount = accounts[email];
        Provider.of<ProductsProvider>(context, listen: false).shuffleProducts();

        Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
      } else {
        _passwordController.text = '';
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: const Text('Wrong password')));
      }
    } else {
      _emailController.text = '';
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: const Text('Wrong email')));
    }
  }

  void _trySignup() {
    var email = _emailController.value.text;
    var password = _passwordController.value.text;
    var mobileNumber = _mobileController.value.text;
    var name = _nameController.value.text;
    final accounts =
        Provider.of<AccountsProvider>(context, listen: false).accounts;
    if (name.isNotEmpty) {
      if (!accounts.containsKey(email)) {
        if (email.contains(RegExp(r'.+@.+\.com'))) {
          if (mobileNumber.isNotEmpty) {
            if (password.length >= 8) {
              if (_passwordReController.value.text == password) {
                Account account = Account(
                    emailAddress: email,
                    mobileNumber: mobileNumber,
                    name: name,
                    password: password);
                Provider.of<AccountsProvider>(context, listen: false)
                    .addAccount(account);
                Provider.of<AccountsProvider>(context, listen: false)
                    .setActivatedAccount = account;
                Provider.of<ProductsProvider>(context, listen: false)
                    .shuffleProducts();
                Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: const Text('Password does not match')));
              }
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: const Text(
                      'Password must be minimum 8 characters long')));
            }
          } else {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: const Text('Please enter mobile number')));
          }
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: const Text('Please enter valid email')));
        }
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text('Email already registered')));
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: const Text('Please enter name')));
    }
  }

  void _onForgotPassword() {
    var wrongMail = false;
    var passwordFocus = FocusNode();
    var passwordReFocus = FocusNode();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var passwordReController = TextEditingController();
    final accounts =
        Provider.of<AccountsProvider>(context, listen: false).accounts;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (ctx) => Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Email"),
                      Padding(
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: TextField(
                          controller: emailController,
                          onSubmitted: (value) {
                            _passwordFocus.requestFocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              hintText: 'e.g: xyz@example.com',
                              labelText: 'Enter Your Email',
                              prefixIcon: Icon(Icons.mail)),
                        ),
                      ),
                      if (wrongMail) Text("Wrong Email"),
                      Text("Password"),
                      Padding(
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: TextField(
                          focusNode: passwordFocus,
                          controller: passwordController,
                          onSubmitted: (value) {
                            _passwordReFocus.requestFocus();
                          },
                          obscureText: _showPassword ? false : true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            hintText: 'Enter New Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () => setState(
                                    () => _showPassword = !_showPassword),
                                child: Icon(_showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                        ),
                      ),
                      Text("Confirm Password"),
                      Padding(
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: TextField(
                          focusNode: passwordReFocus,
                          controller: passwordReController,
                          obscureText: _showPassword ? false : true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            hintText: 'Enter Your Password Again',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () => setState(
                                    () => _showPassword = !_showPassword),
                                child: Icon(_showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.red,
                              child: const Text('Change Password'),
                              onPressed: () {
                                var email = _emailController.value.text;
                                if (accounts.containsKey(email)) {
                                  var account = accounts[email];
                                  Provider.of<AccountsProvider>(context,
                                          listen: false)
                                      .addAccount(Account(
                                          emailAddress: email,
                                          mobileNumber: account.mobileNumber,
                                          name: account.name,
                                          password:
                                              _passwordController.value.text));
                                  Navigator.pop(context);
                                } else {
                                  showDialog(
                                    context: ctx,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: const Text('Wrong Email'),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  );
                                }
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void _onFormSubmission() {
    if (_login) {
      _tryLogin();
      print("dfs");
    } else {
      _trySignup();
      print("Asda");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child:
              const Text("Proceed with your", style: TextStyle(fontSize: 20)),
        ),
        Center(
          child: Text('${_login ? 'Login' : 'Sign Up'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 30),
        if (!_login) Text("Name"),
        if (!_login)
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10),
            child: TextField(
              focusNode: _nameFocus,
              controller: _nameController,
              onSubmitted: (value) {
                _emailFocus.requestFocus();
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: 'Enter Your Name',
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
        if (!_login) SizedBox(height: 20),
        Text("Email"),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 10),
          child: TextField(
            focusNode: _emailFocus,
            controller: _emailController,
            onSubmitted: (value) {
              _login
                  ? _passwordFocus.requestFocus()
                  : _mobileFocus.requestFocus();
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'e.g: xyz@example.com',
                labelText: 'Enter Your Email',
                prefixIcon: Icon(Icons.mail)),
          ),
        ),
        if (!_login) SizedBox(height: 20),
        if (!_login) Text("Mobile Number"),
        if (!_login)
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10),
            child: TextField(
              focusNode: _mobileFocus,
              controller: _mobileController,
              onSubmitted: (value) {
                _passwordFocus.requestFocus();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: 'Enter Your Mobile Number',
                  prefixIcon: Icon(Icons.phone_android)),
            ),
          ),
        SizedBox(height: 20),
        Text("Password"),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 10),
          child: TextField(
            focusNode: _passwordFocus,
            controller: _passwordController,
            onSubmitted: (value) {
              _login ? _onFormSubmission() : _passwordReFocus.requestFocus();
            },
            obscureText: _showPassword ? false : true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: 'Enter Your Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                  onTap: () => setState(() => _showPassword = !_showPassword),
                  child: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility)),
            ),
          ),
        ),
        if (!_login) SizedBox(height: 20),
        if (!_login) Text("Confirm Password"),
        if (!_login)
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10),
            child: TextField(
              focusNode: _passwordReFocus,
              controller: _passwordReController,
              obscureText: _showPassword ? false : true,
              keyboardType: TextInputType.visiblePassword,
              onSubmitted: (value) => _onFormSubmission(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Enter Your Password Again',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                    onTap: () => setState(() => _showPassword = !_showPassword),
                    child: Icon(_showPassword
                        ? Icons.visibility_off
                        : Icons.visibility)),
              ),
            ),
          ),
        if (_login)
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Remember Me',
                style: TextStyle(fontSize: 12, color: Colors.red)),
            secondary: FlatButton(
              child: const Text('Forgot Password',
                  style: TextStyle(fontSize: 12, color: Colors.red)),
              onPressed: _onForgotPassword,
            ),
            value: _remember,
            onChanged: (value) => setState(() => _remember = value),
          ),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            child: RaisedButton(
              color: Colors.red,
              child: Text('${_login ? 'Login' : 'Sign Up'}',
                  style: TextStyle(color: Colors.white)),
              onPressed: _onFormSubmission,
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${_login ? 'Not a Member Yet?' : 'Already a Member?'}'),
          FlatButton(
            padding: EdgeInsets.only(right: 25),
            child: Text('${_login ? 'Sign Up' : 'Login'}',
                style: TextStyle(color: Colors.red)),
            onPressed: () => setState(() => _login = !_login),
          )
        ]),
      ],
    );
  }
}
