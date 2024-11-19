import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:satoe_connection/screen/wrapper.dart';
import 'package:satoe_connection/screen/homescreen.dart';
import 'package:http/http.dart' as http;

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  Future<void> _checkToken() async {
    // Membaca token dari flutter_secure_storage
    final token = await storage.read(key: 'auth_token');
    
    // Jika token tidak ada, langsung arahkan ke halaman login
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }

    // Kirim request ke server Laravel untuk memverifikasi token
    final response = await _verifyToken(token);

    if (response) {
      // Jika token valid, arahkan ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Wrapper()),
      );
    } else {
      // Jika token tidak valid, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // Fungsi untuk memverifikasi token dengan API Laravel
  Future<bool> _verifyToken(String token) async {
    final url = Uri.parse('http://192.168.137.1:8000/api/user'); // Ganti dengan URL API Anda

    // Kirim token melalui header Authorization
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Jika respons sukses, berarti token valid
      return true;
    } else {
      // Jika respons gagal, token tidak valid
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 60,
                      width: 60,
                      color: const Color(0xFF1D7874), // Teal/green color
                    ),
                    const SizedBox(height: 12), // Space between logo and text
                    const Text(
                      'Satoe Connection',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        color: Color(0xFF1D7874),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: LoadingAnimationWidget.discreteCircle(
                color: const Color(0xFF1D7874), // Match primary color
                size: 40, // Adjust size as needed
                secondRingColor: Colors.black,
                thirdRingColor: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
