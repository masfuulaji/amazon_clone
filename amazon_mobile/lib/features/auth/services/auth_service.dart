import 'dart:convert';

import 'package:amazon_mobile/constants/error_handling.dart';
import 'package:amazon_mobile/constants/global_variables.dart';
import 'package:amazon_mobile/constants/utils.dart';
import 'package:amazon_mobile/features/home/screens/home_screen.dart';
import 'package:amazon_mobile/models/user.dart';
import 'package:amazon_mobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
          id: '',
          name: name,
          email: email,
          password: password,
          address: '',
          type: '',
          token: '');

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      if (context.mounted) {
        httpErrorHandling(
          response: response,
          context: context,
          onSucess: () {
            showSnackBar(
                context: context, message: 'User created successfully');
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (context.mounted) {
        httpErrorHandling(
          response: response,
          context: context,
          onSucess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', jsonDecode(response.body)['token']);
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(response.body);
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }
}
