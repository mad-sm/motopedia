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
        _error = "Kolom 'make' wajib diisi (contoh: Honda, Yamaha, Suzuki, dst).";
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
        if (res.isEmpty) _error = "Tidak ada data ditemukan untuk make/model tersebut.";
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Gagal mengambil data: ${e.toString()}";
      });
    }
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void _logout() async {
    await SessionManager.clearSession();
    // ignore: use_build_context_synchronously
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _makeController,
                    decoration: const InputDecoration(
                      labelText: "Make (wajib, misal: Honda)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: "Model (opsional, misal: Supra)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            if (_results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final m = _results[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      child: ListTile(
                        title: Text("${m.make} ${m.model}"),
                        subtitle: Text("Tahun: ${m.year}  •  Tipe: ${m.type}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
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
