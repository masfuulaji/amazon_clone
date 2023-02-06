import 'dart:convert';

import 'package:amazon_mobile/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandling({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSucess,
}) {
  switch (response.statusCode) {
    case 200:
      onSucess();
      break;
    case 201:
      onSucess();
      break;
    case 400:
      showSnackBar(
          context: context, message: jsonDecode(response.body)['message']);
      break;
    case 401:
      showSnackBar(context: context, message: 'Unauthorized');
      break;
    case 404:
      showSnackBar(context: context, message: 'Not Found');
      break;
    case 500:
      showSnackBar(
          context: context, message: jsonDecode(response.body)['message']);
      break;
    default:
      showSnackBar(context: context, message: response.body);
  }
}
