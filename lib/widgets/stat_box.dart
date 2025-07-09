import 'package:flutter/material.dart';

class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color cardColor;
  const StatBox({required this.label, required this.value, required this.cardColor, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black54;
    
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF7B61FF)),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
} 