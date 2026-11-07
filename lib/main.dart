import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bug_group_page.dart';
import 'bug_sender.dart';
import 'admin_page.dart';
import 'change_password_page.dart';
import 'chat_room_page.dart';

void main() {
  runApp(const VortaxApp());
}

// ─── SETTINGS & PREFERENCES STUBS ─────────────────────────────────────────────
class UserSettings {
  bool? darkMode;
  bool? amoledBackground;
  bool? materialTheme;
  bool? enableDiscordPresence;
  bool? useFramelessWindow;

  UserSettings({
    this.darkMode = true,
    this.amoledBackground = false,
    this.materialTheme = false,
    this.enableDiscordPresence = false,
    this.useFramelessWindow = true,
  });
}

class Settings {
  Future<UserSettings> getSettings() async {
    return UserSettings();
  }
}

class UserPreferencesData {
  UserPreferencesData();
}

class UserPreferences {
  static Future<UserPreferencesData> getUserPreferences() async {
    return UserPreferencesData();
  }
}

Future<int> getTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('themeId') ?? 1;
}

Future<void> setTheme(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeId', id);
}

void showToast(String message) {
  // no-op stub
}

// ─── RUNTIME & LOGGER STUBS ──────────────────────────────────────────────────
class _Logger {
  final String name;
  _Logger(this.name);

  void log(String message, {bool addToBuffer = false}) {
    print('[$name] $message');
  }
}

class Logs {
  static final _Logger app = _Logger('APP');

  static Future<void> writeAllLogs() async {
    // no-op stub
  }
}

class AppVersion {
  static String current = '1.0.0';

  static void init() {
    // no-op stub
  }
}

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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                ),
          Positioned(
            bottom: 40,
            right: 20,
            child: TextButton(
              onPressed: _navigateToLogin,
              child: const Text(
                "SKIP >>",
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
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
  late VideoPlayerController _bgController;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bgController = VideoPlayerController.asset('assets/landing.mp4')
      ..initialize().then((_) {
        setState(() {});
        _bgController.setLooping(true);
        _bgController.play();
      });
  }

  @override
  void dispose() {
    _bgController.dispose();
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
      body: Stack(
        children: [
          _bgController.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _bgController.value.size.width,
                      height: _bgController.value.size.height,
                      child: VideoPlayer(_bgController),
                    ),
                  ),
                )
              : Container(color: const Color(0xFF0A0E17)),
          Container(color: Colors.black.withOpacity(0.55)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 110),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _userController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
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
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _handleLogin,
                            child: const Text(
                              "ENTER DASHBOARD",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/popup_paper.png', width: 300),
            Positioned(
              width: 220,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "NOTICE",
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Welcome Captain ${widget.username}!\nVortax VD System fully operational.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Row(
          children: [
            Image.asset('assets/ornes_1.png', height: 32),
            const SizedBox(width: 10),
            const Text("VORTAX VD"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showPaperPopup,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/ornes_2.png',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(height: 140, color: Colors.black.withOpacity(0.4)),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Text(
                          "Welcome, ${widget.username}!",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
                    _buildMenuCard(
                      Icons.group_work, 
                      "Bug Group", 
                      Colors.redAccent, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BugGroupPage(
                              sessionKey: sessionKey,
                              role: userRole,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.bug_report, 
                      "Bug Sender", 
                      Colors.blueAccent, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BugSenderPage(
                              sessionKey: sessionKey,
                              username: widget.username,
                              role: userRole,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.admin_panel_settings, 
                      "Admin Panel", 
                      Colors.purpleAccent, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPage(sessionKey: sessionKey),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.chat, 
                      "Global Chat", 
                      Colors.greenAccent, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomPage(username: widget.username),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.lock_reset, 
                      "Ganti Password", 
                      Colors.orangeAccent, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(
                              username: widget.username,
                              sessionKey: sessionKey,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.description, 
                      "Notice Paper", 
                      Colors.amber, 
                      onTap: _showPaperPopup,
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Image.asset('assets/reze.png', height: 150),
          ),
          Positioned(
            bottom: 0,
            left: -10,
            child: Image.asset('assets/mobil.png', height: 100),
          ),
        ],
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
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
