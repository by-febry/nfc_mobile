import 'package:flutter/material.dart';
import '../widgets/stat_box.dart';
import '../widgets/analytics_card.dart';
import '../widgets/sharing_method_row.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cards;
  const AnalyticsScreen({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic stats from cards data
    final int totalViews = cards.fold(0, (sum, card) => sum + (card['views'] as int));
    final int totalShares = cards.fold(0, (sum, card) => sum + (card['shares'] as int));
    final int activeCards = cards.length;
    
    // Calculate success rate based on views vs shares ratio
    final double successRate = totalViews > 0 ? (totalShares / totalViews * 100) : 0;
    final String successRateText = '${successRate.toStringAsFixed(0)}%';
    
    // Calculate sharing methods usage (simulated based on total activity)
    final int qrCodeUses = (totalShares * 0.6).round(); // 60% of shares via QR
    final int nfcEmulationUses = totalShares - qrCodeUses; // Remaining via NFC
    
    // Sort cards by performance (views + shares) for top performing section
    final sortedCards = List<Map<String, dynamic>>.from(cards);
    sortedCards.sort((a, b) => (b['views'] + b['shares']) - (a['views'] + a['shares']));

    // Dynamic theme colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7FF);
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 35, bottom: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFF5A4FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              children: [
                Text(
                  "Analytics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Your card performance",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StatBox(label: 'Total Views', value: totalViews.toString(), cardColor: cardColor),
                StatBox(label: 'Total Shares', value: totalShares.toString(), cardColor: cardColor),
                StatBox(label: 'Active Cards', value: activeCards.toString(), cardColor: cardColor),
                StatBox(label: 'Success Rate', value: successRateText, cardColor: cardColor),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Top Performing Cards',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
          ),
          const SizedBox(height: 12),
          ...sortedCards.map((card) => AnalyticsCard(card: card, cardColor: cardColor, textColor: textColor)),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Sharing Methods',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SharingMethodRow(method: 'QR Code', uses: qrCodeUses, textColor: textColor),
                  const SizedBox(height: 8),
                  SharingMethodRow(method: 'NFC Emulation', uses: nfcEmulationUses, textColor: textColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
} 