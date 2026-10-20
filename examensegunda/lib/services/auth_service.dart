import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  final List<User> _users = [const User(username: kUsuario, password: kPassword)];
  Future<bool> login(String username, String password) async => _users.any((user) => user.username == username.trim() && user.password == password);
  Future<bool> register(String username, String password) async {
    if (_users.any((user) => user.username == username.trim())) return false;
    _users.add(User(username: username.trim(), password: password));
    return true;
  }
}
