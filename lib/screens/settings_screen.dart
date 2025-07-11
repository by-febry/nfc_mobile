import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final String userEmail;
  final VoidCallback onLogout;
  final ValueChanged<String> onChangeEmail;
  final ValueChanged<String> onChangePassword;
  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.userEmail,
    required this.onLogout,
    required this.onChangeEmail,
    required this.onChangePassword,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7FF);
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: textColor)),
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Account Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF7B61FF),
                  radius: 26,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userEmail,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Logged in',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => _AccountManagementDialog(
                        userEmail: widget.userEmail,
                        onChangeEmail: widget.onChangeEmail,
                        onChangePassword: widget.onChangePassword,
                        onLogout: widget.onLogout,
                      ),
                    );
                  },
                  icon: const Icon(Icons.manage_accounts, size: 18),
                  label: const Text('Account', style: TextStyle(fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Preferences
          Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: widget.isDarkMode,
                  onChanged: (_) => widget.onThemeToggle(),
                  title: Text('Dark Mode', style: TextStyle(color: textColor)),
                  secondary: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: textColor),
                ),
                Divider(height: 1, color: subtitleColor),
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                  title: Text('Enable Notifications', style: TextStyle(color: textColor)),
                  secondary: Icon(Icons.notifications, color: textColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // About
          Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info, color: textColor),
                  title: Text('App Version', style: TextStyle(color: textColor)),
                  subtitle: Text('1.0.0', style: TextStyle(color: subtitleColor)),
                ),
                Divider(height: 1, color: subtitleColor),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: textColor),
                  title: Text('Privacy Policy', style: TextStyle(color: textColor)),
                  onTap: () {
                    // TODO: Launch privacy policy URL
                  },
                ),
                Divider(height: 1, color: subtitleColor),
                ListTile(
                  leading: Icon(Icons.support_agent, color: textColor),
                  title: Text('Contact Support', style: TextStyle(color: textColor)),
                  onTap: () {
                    // TODO: Launch support email or page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountManagementDialog extends StatefulWidget {
  final String userEmail;
  final ValueChanged<String> onChangeEmail;
  final ValueChanged<String> onChangePassword;
  final VoidCallback onLogout;
  const _AccountManagementDialog({
    required this.userEmail,
    required this.onChangeEmail,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  State<_AccountManagementDialog> createState() => _AccountManagementDialogState();
}

class _AccountManagementDialogState extends State<_AccountManagementDialog> {
  int _tabIndex = 0;
  // Email change state
  String _newEmail = '';
  String _pin = '';
  String _confirmEmail = '';
  int _emailStep = 0;
  String? _emailError;
  // Password change state
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String? _passwordError;
  bool _passwordSuccess = false;
  // Demo: hardcoded current password
  String _demoPassword = 'password123';

  void _resetEmailFlow() {
    setState(() {
      _emailStep = 0;
      _newEmail = '';
      _pin = '';
      _confirmEmail = '';
      _emailError = null;
    });
  }

  void _resetPasswordFlow() {
    setState(() {
      _currentPassword = '';
      _newPassword = '';
      _confirmPassword = '';
      _passwordError = null;
      _passwordSuccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TabButton(
                  label: 'Change Email',
                  selected: _tabIndex == 0,
                  onTap: () {
                    setState(() {
                      _tabIndex = 0;
                      _resetEmailFlow();
                    });
                  },
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Change Password',
                  selected: _tabIndex == 1,
                  onTap: () {
                    setState(() {
                      _tabIndex = 1;
                      _resetPasswordFlow();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_tabIndex == 0) ...[
              // Change Email Flow
              if (_emailStep == 0) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    errorText: _emailError,
                  ),
                  onChanged: (val) => setState(() => _newEmail = val),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _newEmail.isNotEmpty && _newEmail != widget.userEmail
                        ? () {
                            setState(() {
                              _emailStep = 1;
                              _emailError = null;
                            });
                          }
                        : null,
                    child: const Text('Send PIN'),
                  ),
                ),
              ] else if (_emailStep == 1) ...[
                Text('A 4-digit PIN has been sent to your new email (demo: 1234).', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter PIN',
                    errorText: _emailError,
                  ),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() => _pin = val),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _pin == '1234'
                        ? () {
                            setState(() {
                              _emailStep = 2;
                              _emailError = null;
                            });
                          }
                        : null,
                    child: const Text('Verify PIN'),
                  ),
                ),
              ] else if (_emailStep == 2) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Confirm New Email',
                    errorText: _emailError,
                  ),
                  onChanged: (val) => setState(() => _confirmEmail = val),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmEmail == _newEmail && _newEmail.isNotEmpty
                        ? () {
                            widget.onChangeEmail(_newEmail);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Change Email'),
                  ),
                ),
              ],
            ] else ...[
              // Change Password Flow
              if (!_passwordSuccess) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    errorText: _passwordError,
                  ),
                  obscureText: true,
                  onChanged: (val) => setState(() => _currentPassword = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  onChanged: (val) => setState(() => _newPassword = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                  onChanged: (val) => setState(() => _confirmPassword = val),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _currentPassword == _demoPassword &&
                        _newPassword.isNotEmpty &&
                        _newPassword == _confirmPassword
                        ? () {
                            widget.onChangePassword(_newPassword);
                            setState(() {
                              _passwordSuccess = true;
                              _passwordError = null;
                            });
                          }
                        : null,
                    child: const Text('Change Password'),
                  ),
                ),
              ] else ...[
                const Text('Password changed successfully!', style: TextStyle(color: Colors.green)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
            Divider(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7B61FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}