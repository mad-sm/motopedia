import 'package:flutter/material.dart';

class SearchBarMotor extends StatelessWidget {
  final TextEditingController makeController;
  final TextEditingController modelController;
  final VoidCallback onSearch;

  const SearchBarMotor({
    Key? key,
    required this.makeController,
    required this.modelController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: makeController,
            decoration: const InputDecoration(
              hintText: "Make",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: TextField(
            controller: modelController,
            decoration: const InputDecoration(
              hintText: "Model",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }
}
