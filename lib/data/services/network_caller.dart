import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app.dart';
import '../../presentation/screens/auth/sign_in_screen.dart';
import '../models/network_response.dart';
import '../utils/auth_utility.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest(String url) async {
    try {
      log('GET Request: $url');
      log('Headers: ${{'token': AuthUtility.accessToken ?? ''}}');

      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': AuthUtility.accessToken ?? '',
        },
      );

      log('GET Response Code [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: 200,
          responseData: decodedResponse,
        );
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Session expired. Please log in again.',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Network Error: $e');
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      log('POST Request: $url');
      log('Request Body: ${jsonEncode(body)}');

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': AuthUtility.accessToken ?? '',
        },
        body: jsonEncode(body),
      );

      log('POST Response Code [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: 200,
          responseData: decodedResponse,
        );
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Session expired. Please log in again.',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Network Error: $e');
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<void> _handleUnauthorized() async {
    await AuthUtility.clearUserInfo();
    if (TaskManagerApp.navigatorKey.currentState != null) {
      TaskManagerApp.navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    }
  }
}
