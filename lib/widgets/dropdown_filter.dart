import 'package:flutter/material.dart';

class DropdownFilter extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onChanged;

  const DropdownFilter({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  static const types = [
    "Sport",
    "Cruiser",
    "Touring",
    "Standard",
    "Offroad",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedType,
      hint: const Text("Type"),
      onChanged: onChanged,
      items: types
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}
