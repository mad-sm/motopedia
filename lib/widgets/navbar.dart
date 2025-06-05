import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback onProfile;
  final VoidCallback onLogout;

  const Navbar({
    Key? key,
    required this.username,
    required this.onProfile,
    required this.onLogout,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade900, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Halo, $username!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'MotoGP',
                ),
              ),
              PopupMenuButton<int>(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 1) onProfile();
                  if (value == 2) onLogout();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.red),
                      title: Text('Profil'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
