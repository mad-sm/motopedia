import '../models/user.dart';
import '/services/user_service.dart';
import '/utils/session_manager.dart';

class AuthService {
  final UserService _userService = UserService();

  // Login: return true jika berhasil
  Future<bool> login(String username, String password) async {
    final user = await _userService.login(username, password);
    if (user != null) {
      await SessionManager.saveSession(username);
      return true;
    }
    return false;
  }

  // Register: return true jika berhasil, false jika username sudah dipakai
  Future<bool> register(String username, String password) async {
    final user = User(username: username, password: password);
    return await _userService.registerUser(user);
  }

  // Logout: hapus session
  Future<void> logout() async {
    await SessionManager.clearSession();
  }

  // Cek session aktif
  Future<bool> isLoggedIn() async {
    return await SessionManager.isSessionActive();
  }

  // Dapatkan username login
  Future<String?> getLoggedInUsername() async {
    return await SessionManager.getUsername();
  }
}
