import 'package:flutter/material.dart';
import 'package:satoe_connection/screen/chat.dart';
import 'package:satoe_connection/screen/kontak.dart';
import 'package:satoe_connection/screen/chat/chatService.dart';


class Beranda extends StatefulWidget {
  const Beranda({super.key});

  final ChatServices _chatServices = ChatServices();

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KontakPonsel(), // Navigate to Contact screen
            ),
          );
        },
        child: const Icon(Icons.contact_phone),
        backgroundColor: Colors.green[400],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Messages',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.search, color: Colors.green[800]),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ),
      ],
    );
  }


Widget _buildUserList() {
  return StreamBuilder(
    stream: _chatServices.getUserStream(),
    builder: (context, snapshot) {

    },
  );
}

}