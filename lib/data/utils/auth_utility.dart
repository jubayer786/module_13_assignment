import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthUtility {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';

  static String? accessToken;
  static UserModel? userInfo;

  static Future<void> saveUserInfo(String token, UserModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(model.toJson()));
    accessToken = token;
    userInfo = model;
  }

  static Future<void> updateUserInfo(UserModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(model.toJson()));
    userInfo = model;
  }

  static Future<void> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_tokenKey);
    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      userInfo = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  static Future<void> clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
    userInfo = null;
  }

  static bool get isLoggedIn => accessToken != null;
}
