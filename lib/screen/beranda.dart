import 'package:flutter/material.dart';
import 'package:satoe_connection/screen/chat/chatService.dart';
import 'package:satoe_connection/screen/chat.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: buildContext(),
    );
  }

  Widget buildContext() {
    return StreamBuilder<List<Map>>(
      stream: ChatServices().getChats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final chats = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    chat['name'][0],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      chat['time'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                // In _BerandaState class, modify the onTap in ListTile:

                onTap: () {
                  final selectedChat = Map<String, dynamic>.from(chat);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(chatData: selectedChat),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
