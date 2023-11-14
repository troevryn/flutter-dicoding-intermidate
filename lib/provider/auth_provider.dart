import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/db/AuthRepository.dart';
import 'package:declarative_route/model/login.dart';
import 'package:declarative_route/model/register.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);
  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool isError = false;
  String isErrorMessage = '';
  Future login(LoginRequest user) async {
    isLoadingLogin = true;
    notifyListeners();
    try {
      final userState = await ApiService().postLogin(user);
      await authRepository.login(userState);
      isLoggedIn = await authRepository.isLoggedIn();
      notifyListeners();
      return isError = false;
    } catch (error) {
      isError = true;
      return isErrorMessage = '$error';
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<dynamic> saveUser(RegisterRequest user) async {
    isLoadingRegister = true;
    notifyListeners();
    try {
      await ApiService().postRegister(user);
      return isError = false;
    } catch (error) {
      isError = true;
      return isErrorMessage = '$error';
    } finally {
      isLoadingRegister = false;
      notifyListeners();
    }
  }
}
