// ignore_for_file: file_names

import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/model/login.dart';
import 'package:declarative_route/model/register.dart';
import 'package:declarative_route/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = "state";
  final String stateToken = "token";
  final String userKey = "user";
  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString(stateToken);

    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(LoginResponse result) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(stateToken, result.loginResult.token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(stateToken);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    preferences.remove(stateToken);
    return preferences.setBool(stateKey, false);
  }

  Future<RegisterResponse> saveUser(RegisterRequest user) async {
    final result = await ApiService().postRegister(user);

    return result;
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }
}
