import 'package:flutter/material.dart';

class LoginCredentials {
  String _userEmail;
  String _userPassword;

  LoginCredentials(this._userEmail, this._userPassword);

  // Getters
  String get userEmail => _userEmail;
  String get userPassword => _userPassword;

  // Setters
  set userEmail(String email) {
    if (email.contains('@')) {
      _userEmail = email;
    } else {
      throw Exception("Invalid email");
    }
  }

  set userPassword(String pass) => _userPassword = pass;
}