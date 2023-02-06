import 'dart:convert';

import 'package:amazon_mobile/common/widgets/bottom_bar.dart';
import 'package:amazon_mobile/constants/environment_variables.dart';
import 'package:amazon_mobile/constants/error_handling.dart';
import 'package:amazon_mobile/constants/utils.dart';
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
                BottomBar.routeName,
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

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        prefs.setString('token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/api/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token ?? '',
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes =
            await http.get(Uri.parse('$uri/'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token ?? '',
        });

        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userRes.body);
        }
      }
    } catch (e) {}
  }
}
