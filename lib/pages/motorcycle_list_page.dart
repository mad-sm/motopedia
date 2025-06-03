import 'package:flutter/material.dart';
import '../models/motorcycle.dart';
import '../services/api_service.dart';

class MotorcycleListPage extends StatelessWidget {
  const MotorcycleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String make = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Model $make")),
      body: FutureBuilder<List<Motorcycle>>(
        future: ApiService().fetchMotorcycles(make: make),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text("No model found"));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final m = list[i];
              return ListTile(
                title: Text(m.model),
                subtitle: Text("Tahun: ${m.year} - Type: ${m.type}"),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: m,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
