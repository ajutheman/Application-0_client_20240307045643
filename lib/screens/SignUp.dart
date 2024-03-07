import 'package:flutter/material.dart';
import 'package:flutter_todo/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/app_services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _errorMessage;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController()..addListener(clearError);
    _passwordController = TextEditingController()..addListener(clearError);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.only(top: 30),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Sign Up', style: const TextStyle(fontSize: 25)),
                loginField(_emailController, labelText: "Email", hintText: "Enter valid email like abc@gmail.com"),
                loginField(_passwordController, labelText: "Password", hintText: "Enter secure password", obscure: true),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(
                      "Please login or register with a Device Sync user account. This is separate from your Atlas Cloud login.",
                      textAlign: TextAlign.center),
                ),
                loginButton(context,
                    child: Text("Sign up"),
                    onPressed: () => _signUpUser(context, _emailController.text, _passwordController.text)),
                TextButton(
                    onPressed: () => Navigator.pop(context), // Navigate back to login page
                    child: Text('Already have an account? Log in.')),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(_errorMessage ?? "",
                      style: errorTextStyle(context),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearError() {
    if (_errorMessage != null) {
      setState(() {
        // Reset error message when user starts typing
        _errorMessage = null;
      });
    }
  }

  void _signUpUser(BuildContext context, String email, String password) async {
    final appServices = Provider.of<AppServices>(context, listen: false);
    clearError();
    try {
      await appServices.registerUserEmailPassword(email, password);
      Navigator.pushNamed(context, '/'); // Navigate to main screen after successful signup
    } catch (err) {
      setState(() {
        _errorMessage = err.toString();
      });
    }
  }
}
