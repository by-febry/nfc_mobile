import 'package:flutter/material.dart';
import '../widgets/detail_row.dart';

class VirtualCard extends StatelessWidget {
  final Map<String, dynamic> card;
  const VirtualCard({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final buttonColor = const Color(0xFF7B61FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Virtual Card', style: TextStyle(color: textColor)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Virtual Card Display
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [buttonColor, buttonColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.nfc,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card['subtitle'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Views',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '${card['views']}',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Shares',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '${card['shares']}',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share card functionality
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // NFC emulation functionality
                    },
                    icon: const Icon(Icons.nfc),
                    label: const Text('Tap to Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Card Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Details',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DetailRow(
                    icon: Icons.remove_red_eye,
                    label: 'Total Views',
                    value: '${card['views']}',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  DetailRow(
                    icon: Icons.share,
                    label: 'Total Shares',
                    value: '${card['shares']}',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  DetailRow(
                    icon: Icons.access_time,
                    label: 'Last Used',
                    value: card['lastUsed'],
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  if (card['quantity'] != null && card['quantity'] > 1) ...[
                    const SizedBox(height: 12),
                    DetailRow(
                      icon: Icons.copy,
                      label: 'Quantity',
                      value: '${card['quantity']}',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 