import 'package:hive/hive.dart';
import '../models/user.dart';

class UserService {
  final Box<User> _userBox = Hive.box<User>('users');

  Future<User?> getUser(String username) async {
  try {
    return _userBox.values.firstWhere((u) => u.username == username);
  } catch (e) {
    return null; // Jika tidak ketemu, return null dengan aman.
  }
}

  Future<bool> registerUser(User user) async {
    if (await getUser(user.username) != null) return false;
    await _userBox.add(user);
    return true;
  }

  Future<User?> login(String username, String password) async {
    final user = await getUser(username);
    if (user != null && user.password == password) return user;
    return null;
  }

  Future<void> updateUser(User user) async {
    await user.save();
  }

  Future<void> deleteUser(User user) async {
    await user.delete();
  }
}
