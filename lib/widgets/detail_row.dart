import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color subtitleColor;

  const DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.subtitleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: subtitleColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: subtitleColor, fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
} 