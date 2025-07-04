import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _showGetStarted = true;
  bool _showLogin = false;
  bool _isLoggedIn = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _continueToLogin() {
    setState(() {
      _showGetStarted = false;
      _showLogin = true;
    });
  }

  void _login(String email, String password) {
    setState(() {
      _isLoggedIn = true;
      _showLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (_showGetStarted) {
      homeWidget = GetStartedScreen(onContinue: _continueToLogin);
    } else if (_showLogin && !_isLoggedIn) {
      homeWidget = LoginScreen(onLogin: _login);
    } else {
      homeWidget = OneTappHome(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneTapp',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: homeWidget,
    );
  }

  static final _lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}

class GetStartedScreen extends StatelessWidget {
  final VoidCallback onContinue;
  const GetStartedScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to OneTapp',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class OneTappHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const OneTappHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
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
      'lastUsed': "2h ago"
    },
    {
      'initial': 'P',
      'title': "Personal Card",
      'subtitle': "Freelance Designer",
      'views': 12,
      'shares': 3,
      'lastUsed': "1d ago"
    },
    {
      'initial': 'C',
      'title': "Consulting Card",
      'subtitle': "Tech Consultant",
      'views': 8,
      'shares': 2,
      'lastUsed': "3d ago"
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
                    const SizedBox(width: 40), // Spacer for centering
                    const Text(
                      "OneTapp",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
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
                  "Virtual NFC Cards",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Add New Card Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text("+ Add New Card"),
              ),
            ),
          ),
          // Card List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
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
                                  fontSize: 17,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                card['subtitle'],
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.remove_red_eye, size: 16, color: statsColor),
                                  const SizedBox(width: 4),
                                  Text("${card['views']} views", style: TextStyle(color: statsColor, fontSize: 13)),
                                  const SizedBox(width: 12),
                                  Icon(Icons.share, size: 16, color: statsColor),
                                  const SizedBox(width: 4),
                                  Text("${card['shares']} shares", style: TextStyle(color: statsColor, fontSize: 13)),
                                  const SizedBox(width: 12),
                                  Text("Last used: ${card['lastUsed']}", style: TextStyle(color: statsColor, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 1) {
      bodyContent = const AddNewCardScreen();
    } else if (_selectedIndex == 2) {
      bodyContent = AnalyticsScreen(cards: cards);
    } else {
      bodyContent = const Center(child: Text('Settings', style: TextStyle(fontSize: 24)));
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
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class AddNewCardScreen extends StatelessWidget {
  const AddNewCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                  "Add New Card",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Scan your physical NFC card",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF7B61FF),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Tap to scan',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.qr_code, color: Colors.white),
                    label: Text('Scan QR Code Instead'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B61FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Or enter URL manually:', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'https://one-tapp-frontend.vercel.app/card',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF7F7FF),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B61FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add Card'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cards;
  const AnalyticsScreen({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    // Hardcoded stats from screenshot
    const int totalViews = 44;
    const int totalShares = 13;
    const int activeCards = 3;
    const String successRate = '85%';
    const int qrCodeUses = 12;
    const int nfcEmulationUses = 8;

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
              children: const [
                _StatBox(label: 'Total Views', value: '44'),
                _StatBox(label: 'Total Shares', value: '13'),
                _StatBox(label: 'Active Cards', value: '3'),
                _StatBox(label: 'Success Rate', value: '85%'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Top Performing Cards',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          ...cards.map((card) => _AnalyticsCard(card: card)),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Sharing Methods',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SharingMethodRow(method: 'QR Code', uses: 12),
                  SizedBox(height: 8),
                  _SharingMethodRow(method: 'NFC Emulation', uses: 8),
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF7B61FF)),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final Map<String, dynamic> card;
  const _AnalyticsCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF7B61FF),
            child: Text(card['initial'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          title: Text(card['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${card['views']} views • ${card['shares']} shares'),
        ),
      ),
    );
  }
}

class _SharingMethodRow extends StatelessWidget {
  final String method;
  final int uses;
  const _SharingMethodRow({required this.method, required this.uses});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(method, style: const TextStyle(fontSize: 16)),
        Text('$uses uses', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7B61FF))),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _launchOfficialSite() async {
    final Uri url = Uri.parse('https://onetapfrontend.vercel.app');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      final response = await http.post(
        Uri.parse('https://onetapp-backend-37xz.onrender.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        widget.onLogin(email, password);
      } else {
        setState(() {
          _errorMessage = 'Login failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login to your account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator(),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                        _handleLogin();
                      }
                    },
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _launchOfficialSite,
              child: const Text('Go to Official OneTapp Website'),
            ),
          ],
        ),
      ),
    );
  }
}
