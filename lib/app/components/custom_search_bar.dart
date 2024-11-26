import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Buscar por nome...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
