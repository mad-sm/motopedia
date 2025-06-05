import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/motorcycle.dart';
import '../widgets/navbar.dart';
import '../utils/session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  List<Motorcycle> _results = [];
  bool _loading = false;
  String? _error;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final username = await SessionManager.getUsername() ?? "";
    setState(() => _username = username);
  }

  void _search() async {
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();
    if (make.isEmpty) {
      setState(() {
        _error =
            "Kolom 'make' wajib diisi (contoh: Honda, Yamaha, Suzuki, dst).";
        _results = [];
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _results = [];
    });

    try {
      final res = await ApiService().fetchMotorcycles(
        make: make,
        model: model.isEmpty ? null : model,
      );
      setState(() {
        _results = res;
        _loading = false;
        if (res.isEmpty) {
          _error = "Tidak ada data ditemukan untuk make/model tersebut.";
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Gagal mengambil data: ${e.toString()}";
      });
    }
  }

  void _goToProfile() => Navigator.pushNamed(context, '/profile');
  void _logout() async {
    await SessionManager.clearSession();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToDetail(Motorcycle motor) {
    Navigator.pushNamed(context, '/detail', arguments: motor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        username: _username,
        onProfile: _goToProfile,
        onLogout: _logout,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 199, 22, 22),
              Color.fromARGB(255, 74, 124, 170),
              Color.fromARGB(255, 22, 22, 22),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Motopedia Search",
              style: const TextStyle(
                fontFamily: 'MotoGP',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: _makeController,
                      decoration: InputDecoration(
                        labelText: "Make (misal: Honda)",
                        prefixIcon: const Icon(Icons.motorcycle),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: "Model (opsional)",
                        prefixIcon: const Icon(Icons.build),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _search,
                        icon: const Icon(Icons.search),
                        label: const Text("Cari Motor"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            199,
                            22,
                            22,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(color: Colors.white),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final m = _results[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.two_wheeler,
                          color: Colors.red,
                        ),
                        title: Text(
                          "${m.make} ${m.model}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text("Tahun: ${m.year} • Tipe: ${m.type}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _goToDetail(m),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
