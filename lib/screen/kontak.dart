import 'package:flutter/material.dart';

class KontakPonsel extends StatefulWidget {
  const KontakPonsel({super.key});

  @override
  State<KontakPonsel> createState() => _KontakPonselState();
}

class _KontakPonselState extends State<KontakPonsel> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final List<Map<String, String>> _kontakList = [];

  void _tambahKontak() {
    String nama = _namaController.text.trim();
    String nomor = _nomorController.text.trim();

    if (nama.isNotEmpty && nomor.isNotEmpty) {
      setState(() {
        _kontakList.add({'nama': nama, 'nomor': nomor});
      });
      _namaController.clear();
      _nomorController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nomorController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _tambahKontak,
              child: const Text('Tambah Kontak'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _kontakList.length,
                itemBuilder: (context, index) {
                  final kontak = _kontakList[index];
                  return ListTile(
                    title: Text(kontak['nama']!),
                    subtitle: Text(kontak['nomor']!),
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
