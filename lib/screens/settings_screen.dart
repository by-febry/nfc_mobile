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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF7B61FF),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.userEmail, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          const SizedBox(height: 4),
                          Text('Logged in', style: TextStyle(color: subtitleColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onLogout,
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final newEmail = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempEmail = widget.userEmail;
                            return AlertDialog(
                              title: const Text('Change Email'),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(labelText: 'New Email'),
                                onChanged: (val) => tempEmail = val,
                                controller: TextEditingController(text: widget.userEmail),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.pop(context, tempEmail), child: const Text('Save')),
                              ],
                            );
                          },
                        );
                        if (newEmail != null && newEmail.isNotEmpty && newEmail != widget.userEmail) {
                          widget.onChangeEmail(newEmail);
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Change Email'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        String tempPassword = '';
                        final newPassword = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Change Password'),
                              content: TextField(
                                autofocus: true,
                                obscureText: true,
                                decoration: const InputDecoration(labelText: 'New Password'),
                                onChanged: (val) => tempPassword = val,
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.pop(context, tempPassword), child: const Text('Save')),
                              ],
                            );
                          },
                        );
                        if (newPassword != null && newPassword.isNotEmpty) {
                          widget.onChangePassword(newPassword);
                        }
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text('Change Password'),
                    ),
                  ],
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