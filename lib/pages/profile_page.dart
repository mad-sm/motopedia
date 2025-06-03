import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../utils/session_manager.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  final _userService = UserService();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    String? username = await SessionManager.getUsername();
    if (username == null) return;
    _user = await _userService.getUser(username);
    _usernameCtrl.text = _user?.username ?? "";
    _passwordCtrl.text = _user?.password ?? "";
    setState(() {});
  }

  void _save() async {
    if (_user == null) return;
    _user!.username = _usernameCtrl.text;
    _user!.password = _passwordCtrl.text;
    await _userService.updateUser(_user!);
    // update session if username changed
    await SessionManager.saveSession(_user!.username);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan!")));
  }

  void _delete() async {
    if (_user == null) return;
    await _userService.deleteUser(_user!);
    await SessionManager.clearSession();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _usernameCtrl, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _passwordCtrl, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("Simpan")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus Akun"),
            ),
          ],
        ),
      ),
    );
  }
}
