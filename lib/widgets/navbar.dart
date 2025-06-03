import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback? onProfile;
  final VoidCallback? onLogout;

  const Navbar({
    Key? key,
    required this.username,
    this.onProfile,
    this.onLogout,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Hello, $username"),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: onProfile,
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: onLogout,
        ),
      ],
    );
  }
}
