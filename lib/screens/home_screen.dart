import 'package:flutter/material.dart';
import '../widgets/virtual_card.dart';
import '../widgets/stat_box.dart';
import '../widgets/analytics_card.dart';
import '../widgets/sharing_method_row.dart';
import '../screens/analytics_screen.dart';
import '../screens/settings_screen.dart';

class OneTappHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;
  final String userEmail;
  final ValueChanged<String> onChangeEmail;
  final ValueChanged<String> onChangePassword;

  const OneTappHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onLogout,
    required this.userEmail,
    required this.onChangeEmail,
    required this.onChangePassword,
  });

  @override
  State<OneTappHome> createState() => _OneTappHomeState();
}

class _OneTappHomeState extends State<OneTappHome> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> cards = [
    {
      'initial': 'J',
      'title': "John's Business Card",
      'subtitle': "Software Developer",
      'views': 24,
      'shares': 8,
      'lastUsed': "2h ago",
      'quantity': 1,
    },
    {
      'initial': 'P',
      'title': "Personal Card",
      'subtitle': "Freelance Designer",
      'views': 12,
      'shares': 3,
      'lastUsed': "1d ago",
      'quantity': 1,
    },
    {
      'initial': 'C',
      'title': "Consulting Card",
      'subtitle': "Tech Consultant",
      'views': 8,
      'shares': 2,
      'lastUsed': "3d ago",
      'quantity': 50, // <--- 50 copies
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7FF);
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final statsColor = isDark ? Colors.white60 : Colors.grey;

    Widget bodyContent;
    if (_selectedIndex == 0) {
      bodyContent = Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 35, bottom: 34),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFF5A4FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/logo.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "OneTapp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: widget.onThemeToggle,
                      icon: Icon(
                        widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Virtual NFC Card",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Card List
          Expanded(
            child: cards.isEmpty
                ? Center(
                    child: Text(
                      'No cards yet. Tap "+ Add New Card" to get started!',
                      style: TextStyle(color: subtitleColor, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: isDark ? 0 : 4,
                          shadowColor: isDark ? Colors.transparent : Colors.black12,
                          color: cardColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VirtualCard(card: card),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFF7B61FF),
                                    child: Text(
                                      card['initial'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Card Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          card['subtitle'],
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.remove_red_eye, size: 16, color: statsColor),
                                            const SizedBox(width: 4),
                                            Text("${card['views']} views", style: TextStyle(color: statsColor, fontSize: 13)),
                                            const SizedBox(width: 12),
                                            Icon(Icons.share, size: 16, color: statsColor),
                                            const SizedBox(width: 4),
                                            Text("${card['shares']} shares", style: TextStyle(color: statsColor, fontSize: 13)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 16, color: statsColor),
                                            const SizedBox(width: 4),
                                            Text("Last used: ${card['lastUsed']}", style: TextStyle(color: statsColor, fontSize: 13)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    } else if (_selectedIndex == 1) {
      bodyContent = AnalyticsScreen(cards: cards);
    } else {
      bodyContent = SettingsScreen(
        isDarkMode: widget.isDarkMode,
        onThemeToggle: widget.onThemeToggle,
        userEmail: widget.userEmail,
        onLogout: widget.onLogout,
        onChangeEmail: widget.onChangeEmail,
        onChangePassword: widget.onChangePassword,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: bodyContent,
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF7B61FF),
        unselectedItemColor: widget.isDarkMode ? Colors.white60 : Colors.black54,
        backgroundColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
} 