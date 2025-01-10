import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const Chat({super.key, required this.chatData});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  
  @override
  void initState() {
    super.initState();
    _loadMessages(); // Memuat pesan yang sudah disimpan
  }

  // Fungsi untuk memformat waktu pesan
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(time);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(time)}';
    } else {
      return DateFormat('MMM d, HH:mm').format(time);
    }
  }

  // Fungsi untuk mengirim pesan
// Fungsi untuk mengirim pesan
Future<void> _sendMessage(String message) async {
  final receiverId = widget.chatData['id'];
  final currentTime = DateTime.now();

  // Menyimpan pesan ke SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> messages = prefs.getStringList('messages') ?? [];

  // Menyimpan pesan yang dikirim dan menerima pesan dari bot
  messages.add(jsonEncode({
    'message': message,
    'sender': 'You',
    'isSender': true,
    'time': currentTime.toIso8601String(), // Pastikan disimpan dalam string format
  }));

  // Simulasi bot yang membalas
  messages.add(jsonEncode({
    'message': 'Bot response to "$message"',
    'sender': 'Bot',
    'isSender': false,
    'time': currentTime.add(const Duration(seconds: 1)).toIso8601String(),
  }));

  // Menyimpan daftar pesan kembali ke SharedPreferences
  await prefs.setStringList('messages', messages);

  setState(() {
    _messages.add({
      'message': message,
      'sender': 'You',
      'isSender': true,
      'time': currentTime,
    });

    _messages.add({
      'message': 'Bot response to "$message"',
      'sender': 'Bot',
      'isSender': false,
      'time': currentTime.add(const Duration(seconds: 1)),
    });
  });

  _messageController.clear();
  _scrollToBottom();
}

// Fungsi untuk memuat pesan yang disimpan di SharedPreferences
Future<void> _loadMessages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> messages = prefs.getStringList('messages') ?? [];

  setState(() {
    _messages.clear();
    for (var message in messages) {
      var msg = jsonDecode(message);

      // Pastikan untuk mengubah waktu kembali ke DateTime setelah diambil dari SharedPreferences
      msg['time'] = DateTime.parse(msg['time']); // Parse string ke DateTime
      _messages.add(msg);
    }
  });
}

  // Fungsi untuk meng-scroll ke bawah
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Membuat AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 244, 237, 237),
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.green[800]),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Hero(
            tag: 'profile_${widget.chatData['name']}',
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.chatData['name'][0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membuat bubble pesan
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isSender = message['isSender'];
    final time = message['time'] as DateTime;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSender) ...[
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[300],
                child: Text(
                  message['sender'][0],
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              decoration: BoxDecoration(
                color: isSender ? Colors.green[800] : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: Radius.circular(isSender ? 16 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message['message'],
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      color: isSender ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat input pesan
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: const Color.fromARGB(255, 97, 91, 91)),
                filled: true,
                fillColor: const Color.fromARGB(175, 190, 185, 185),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (message) {
                if (message.isNotEmpty) {
                  _sendMessage(message);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green[800]),
            onPressed: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
              }
            },
          ),
        ],
      ),
    );
  }
}
