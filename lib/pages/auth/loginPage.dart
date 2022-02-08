import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:customer_portal/Controllers/UserController.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/auth/forgotPasswordPage.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/pages/auth/registrationPage.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";
  bool _isLoading = false;
  bool _showPassword = false;
  bool _isCredentialsInvalid = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authCheck();
  }

  _authCheck() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    if (_pref.getString("token") != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (c) => Dashboard(),
        ),
      );
    }
  }

  _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isCredentialsInvalid = false;
    });

    _formKey.currentState!.save();

    FormData _data =
        new FormData.fromMap({"email": _email, "password": _password});
    UserController().login(_data).then((res) {
      if (res.statusCode != 200) {
        setState(() {
          _isLoading = false;

          _isCredentialsInvalid = true;
        });
      }
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.3,
        color: Colors.black,
        progressIndicator: CustomLoader(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/header_bg.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/logo1.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    _isCredentialsInvalid
                        ? Text(
                            "Invalid credentials",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter a email";
                          }

                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)) {
                            return "Enter a valid email address";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          _email = val!;
                        },
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          TextFormField(
                            onSaved: (val) {
                              _password = val!;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter a password";
                              }

                              return null;
                            },
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 15,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(
                                !_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _login();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text("Login"),
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   height: 50,
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ForgotPasswordPage()));
                      },
                      child: Text("Forgot password?"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(
                                height: 4,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(child: Text("OR")),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => RegistrationPage()));
                      },
                      child: Text("Register"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
