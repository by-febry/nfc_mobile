import 'package:flutter/material.dart';
import 'screens/get_started_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

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
  String _userEmail = 'admin@onetapp.com';
  String _userPassword = 'password123';

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
    if (email == _userEmail && password == _userPassword) {
      setState(() {
        _isLoggedIn = true;
        _showLogin = false;
      });
    } else {
      // Optionally show error
    }
  }

  void _updateEmail(String newEmail) {
    setState(() {
      _userEmail = newEmail;
    });
  }

  void _updatePassword(String newPassword) {
    setState(() {
      _userPassword = newPassword;
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
        onLogout: () {
          setState(() {
            _isLoggedIn = false;
            _showLogin = true;
            _showGetStarted = false;
          });
        },
        userEmail: _userEmail,
        onChangeEmail: _updateEmail,
        onChangePassword: _updatePassword,
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
