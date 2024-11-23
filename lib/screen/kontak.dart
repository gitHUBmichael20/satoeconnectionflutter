import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KontakPonsel extends StatefulWidget {
  const KontakPonsel({super.key});

  @override
  State<KontakPonsel> createState() => _KontakPonselState();
}

class _KontakPonselState extends State<KontakPonsel> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  List<Map<String, String>> _kontakList = [];

  @override
  void initState() {
    super.initState();
    _loadKontak();
  }

  Future<void> _loadKontak() async {
    final prefs = await SharedPreferences.getInstance();
    String? kontakString = prefs.getString('kontakList');

    if (kontakString != null) {
      List<dynamic> kontakListJson = jsonDecode(kontakString);
      setState(() {
        _kontakList = List<Map<String, String>>.from(kontakListJson.map((item) => Map<String, String>.from(item)));
      });
    }
  }

  Future<void> _saveKontak() async {
    final prefs = await SharedPreferences.getInstance();
    String kontakString = jsonEncode(_kontakList);
    await prefs.setString('kontakList', kontakString);
  }

  Future<void> _tambahKontak() async {
    String id = _idController.text.trim();
    String nama = _namaController.text.trim();

    // Validasi input
    if (id.isEmpty || nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID dan Nama harus diisi')),
      );
      return;
    }

    // Cek apakah ID sudah ada
    bool isDuplicate = _kontakList.any((kontak) => kontak['id'] == id);
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID sudah ada di daftar kontak')),
      );
      return;
    }

    // Pengecekan ID ke API
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/verify/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String username = data['username'];

      setState(() {
        _kontakList.add({
          'id': id,
          'nama': nama,
          'username': username,
        });
      });

      _saveKontak();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kontak berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID atau User tidak ditemukan')),
      );
    }
  }

  Future<void> _renameNama(int index) async {
    final TextEditingController renameController = TextEditingController();
    renameController.text = _kontakList[index]['nama']!;

    // Dialog untuk mengubah nama
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: renameController,
          decoration: const InputDecoration(
            labelText: 'Nama Baru',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _kontakList[index]['nama'] = renameController.text.trim();
              });
              _saveKontak(); // Simpan perubahan
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID Pengguna',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _tambahKontak,
              child: const Text('Tambah Kontak'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Kontak yang telah disimpan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _kontakList.length,
                itemBuilder: (context, index) {
                  final kontak = _kontakList[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        kontak['nama']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID Pengguna: ${kontak['id']}'),
                          Text('Username: ${kontak['username'] ?? '-'}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _renameNama(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _kontakList.removeAt(index);
                              });
                              _saveKontak();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
