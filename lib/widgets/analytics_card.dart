import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  final Map<String, dynamic> card;
  final Color cardColor;
  final Color textColor;
  const AnalyticsCard({required this.card, required this.cardColor, required this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black87;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF7B61FF),
            child: Text(card['initial'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          title: Text(card['title'], style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
          subtitle: Text('${card['views']} views • ${card['shares']} shares', style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
} 