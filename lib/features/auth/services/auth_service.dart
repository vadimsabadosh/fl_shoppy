import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/common/widgets/bottom_bar.dart';
import 'package:shoppy/constants/error_handling.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/constants/utils.dart';
import 'package:shoppy/features/home/screens/home_screen.dart';
import 'package:shoppy/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/providers/user_provider.dart';

class AuthService {
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
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
        Uri.parse('$uri/api/user/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': "application/json; charset=utf-8"
        },
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Successfully registered');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/user/signin'),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': "application/json; charset=utf-8"
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);

          var normToken = jsonDecode(response.body)['token'];
          print('signInUser normToken: ${normToken}');

          await prefs.setString('x-auth-token', normToken);
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, (route) => false);
          // showSnackBar(context, 'Successfully signed in');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUser({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenResponse = await http.get(
        Uri.parse('$uri/api/user/token'),
        headers: <String, String>{
          'Content-Type': "application/json; charset=utf-8",
          "x-auth-token": token!,
        },
      );

      var response = jsonDecode(tokenResponse.body);

      if (response == true) {
        http.Response userRes = await http
            .get(Uri.parse('$uri/api/user/getData'), headers: <String, String>{
          'Content-Type': "application/json; charset=utf-8",
          "x-auth-token": token,
        });
        var userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
