import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._service);
  final AuthService _service;
  bool isLoading = false;
  bool isAuthenticated = false;
  String? error;
  void logout() {
    isAuthenticated = false;
    error = null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      isAuthenticated = await _service.login(username, password);
      if (!isAuthenticated) error = 'Usuario o contraseña incorrectos.';
      return isAuthenticated;
    } catch (_) {
      error = 'No pudimos iniciar sesión. Intenta de nuevo.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final created = await _service.register(username, password);
      if (!created) error = 'Ese usuario ya está registrado.';
      return created;
    } catch (_) {
      error = 'No pudimos crear la cuenta.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
