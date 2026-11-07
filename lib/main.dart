import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const VortaxApp());
}

// ─── STUBS & PREFERENCES ─────────────────────────────────────────────────────
class UserSettings {
  bool? darkMode = true;
  bool? amoledBackground = false;
  UserSettings();
}

class Settings {
  Future<UserSettings> getSettings() async => UserSettings();
}

class UserPreferencesData {
  UserPreferencesData();
}

class UserPreferences {
  static Future<UserPreferencesData> getUserPreferences() async => UserPreferencesData();
}

Future<int> getTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('themeId') ?? 1;
}

Future<void> setTheme(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeId', id);
}

void showToast(String message) {}

class VortaxApp extends StatelessWidget {
  const VortaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vortax VD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
        primaryColor: Colors.blueAccent,
      ),
      home: const SplashScreen(),
    );
  }
}

// ==================== 1. SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              "VORTAX VD",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Loading System...", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

// ==================== 2. LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    String user = _userController.text.trim();
    if (user.isEmpty) user = "Renz";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage(username: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, size: 60, color: Colors.blueAccent),
                const SizedBox(height: 16),
                const Text("VORTAX LOGIN", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 24),
                TextField(
                  controller: _userController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password Key",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _handleLogin,
                    child: const Text("ENTER DASHBOARD", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 3. DASHBOARD PAGE ====================
class DashboardPage extends StatefulWidget {
  final String username;
  const DashboardPage({super.key, required this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String userRole = "developer"; 
  final String sessionKey = "dummy_session_key_123";

  void _showPaperPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("NOTICE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Text("Welcome Captain ${widget.username}!\nVortax VD System fully operational.", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text("VORTAX VD — Captain ${widget.username}"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: _showPaperPopup),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.blueAccent, radius: 28, child: Icon(Icons.person, size: 32, color: Colors.white)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome, ${widget.username}!", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      const Text("Role: Developer | Status: Active", style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMenuCard(Icons.group_work, "Bug Group", Colors.redAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BugGroupPage(sessionKey: sessionKey, role: userRole)));
                }),
                _buildMenuCard(Icons.bug_report, "Bug Sender", Colors.blueAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BugSenderPage(sessionKey: sessionKey, username: widget.username, role: userRole)));
                }),
                _buildMenuCard(Icons.admin_panel_settings, "Admin Panel", Colors.purpleAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(sessionKey: sessionKey)));
                }),
                _buildMenuCard(Icons.chat, "Global Chat", Colors.greenAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(username: widget.username)));
                }),
                _buildMenuCard(Icons.lock_reset, "Ganti Password", Colors.orangeAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage(username: widget.username, sessionKey: sessionKey)));
                }),
                _buildMenuCard(Icons.description, "Notice Paper", Colors.amber, onTap: _showPaperPopup),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ==================== 4. SUB-PAGES ====================
class BugGroupPage extends StatelessWidget {
  final String sessionKey;
  final String role;
  const BugGroupPage({super.key, required this.sessionKey, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Bug Group Panel")), body: const Center(child: Text("Bug Group Control Active")));
  }
}

class BugSenderPage extends StatelessWidget {
  final String sessionKey;
  final String username;
  final String role;
  const BugSenderPage({super.key, required this.sessionKey, required this.username, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Bug Sender Panel")), body: const Center(child: Text("Bug Sender Execution Ready")));
  }
}

class AdminPage extends StatelessWidget {
  final String sessionKey;
  const AdminPage({super.key, required this.sessionKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Admin Panel")), body: const Center(child: Text("Admin Controls Operational")));
  }
}

class ChatRoomPage extends StatelessWidget {
  final String username;
  const ChatRoomPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Global Chat")), body: const Center(child: Text("Global Chat Room Active")));
  }
}

class ChangePasswordPage extends StatelessWidget {
  final String username;
  final String sessionKey;
  const ChangePasswordPage({super.key, required this.username, required this.sessionKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Ganti Password")), body: const Center(child: Text("Password Configuration Active")));
  }
}
