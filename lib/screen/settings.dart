  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:satoe_connection/screen/splashscreen.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Settings',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SettingsPage(),
      );
    }
  }

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Initialize FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
Future<void> _signOut(BuildContext context) async {
  try {
    // Dapatkan token yang tersimpan
    final token = await _storage.read(key: 'auth_token');
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Buat instance http client
    final response = await http.post(
      Uri.parse('http://192.168.137.1:8000/api/logout'), // Sesuaikan dengan base URL API Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Hapus token dari storage setelah berhasil logout dari server
      await _storage.delete(key: 'auth_token');

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have signed out successfully.')),
      );

      // Navigasi ke halaman splash screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Splashscreen(),
      ));
    } else {
      // Handle error response dari server
      throw Exception('Failed to logout. Please try again.');
    }
  } catch (e) {
    // Tampilkan error message ke user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    // Profile Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[200],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'johndoe@email.com',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Account Settings Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.person_outline, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'Notifications',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text('Customize your notification preferences'),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.lock_outline, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'Privacy',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // More Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'More',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.language, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'Language',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text('English (US)'),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.help_outline, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'Help & Support',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.info_outline, color: Colors.black87, size: 24),
                            ),
                            title: const Text(
                              'About',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
// Sign Out Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextButton(
                      onPressed: () => _signOut(context),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }