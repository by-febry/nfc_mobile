import 'package:flutter/material.dart';

class SharingMethodRow extends StatelessWidget {
  final String method;
  final int uses;
  final Color textColor;
  const SharingMethodRow({required this.method, required this.uses, required this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(method, style: TextStyle(fontSize: 16, color: textColor)),
        Text('$uses uses', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7B61FF))),
      ],
    );
  }
} 