import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String _baseUrl =
      'https://34ce-2401-4900-1c3b-e0ab-de8c-9193-ae83-96e7.ngrok-free.app';

  // Existing signup function (unchanged)
  Future<bool> signup(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      var formData = {'username': username, 'password': password};

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        body: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User created successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Failed to create user'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  // Updated login function
  Future<bool> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      var formData = {'username': username, 'password': password};
      debugPrint(username);
      debugPrint(password);
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        body: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(response.body);

        if (responseData['success'] == true) {
          // Get SharedPreferences instance
          // final prefs = await SharedPreferences.getInstance();

          // Save username and randname (assuming randname is id from your response)
          // await prefs.setString(
          //   'username',
          //   responseData['data']['user']['username'].toString(),
          // );
          // await prefs.setString(
          //   'userId',
          //   responseData['data']['user']['id'].toString(),
          // );
          // await prefs.setString(
          //   'randName',
          //   responseData['data']['user']['randname'].toString(),
          // );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged in successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Failed to login'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
  }
}
